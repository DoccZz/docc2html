//
//  DocCFileSystemExportTarget.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Logging

open class DocCFileSystemExportTarget: DocCStaticExportTarget,
                                       CustomStringConvertible
{
  
  public let logger      : Logger
  public let fileManager : FileManager
  public let targetPath  : String
  open   var targetURL   : URL { return URL(fileURLWithPath: targetPath) }
  
  public init(targetPath: String, fileManager: FileManager = .default,
              logger: Logger = Logger(label: "docc2html"))
  {
    self.logger      = logger
    self.targetPath  = targetPath
    self.fileManager = fileManager
  }
  
  
  open func doesTargetExist() -> Bool {
    return fileManager.fileExists(atPath: targetPath)
  }
  
  
  // MARK: - Copying Static Resources

  open func copyCSS(_ cssFiles: [ URL ], keepHash: Bool) throws {
    guard !cssFiles.isEmpty else { return }
    
    let targetURL = self.targetURL.appendingPathComponent("css")
    try ensureTargetDir("css")
    
    for css in cssFiles {
      let cssContents : String
      do {
        cssContents = try String(contentsOf: css)
                          .stringByRemovingDocCDataReferences()
      }
      catch {
        // TODO: Wrap in Own Error
        logger.error("Failed to load CSS:", css.path)
        throw ExitCode.couldNotLoadStaticResource
      }
      
      let targetName = keepHash
                     ? css.lastPathComponent
                     : css.deletingResourceHash().lastPathComponent
      
      let cssTargetURL = targetURL.appendingPathComponent(targetName)
      
      logger.trace("Copying CSS \(css.path) to \(cssTargetURL.path)")
      
      do {
        try cssContents.write(to: cssTargetURL, atomically: false,
                              encoding: .utf8)
      }
      catch {
        // TODO: Wrap in Own Error
        logger.error("Failed to save CSS:", cssTargetURL.path)
        throw ExitCode.couldNotCopyStaticResource
      }
    }
  }

  public func copyRaw(_ files: [ URL ], to directory: String,
                      keepHash: Bool = true) throws
  {
    guard !files.isEmpty else { return }
    
    let targetURL = self.targetURL.appendingPathComponent(directory)
    try ensureTargetDir(targetURL)

    for file in files {
      let targetName = keepHash
                     ? file.lastPathComponent
                     : file.deletingResourceHash().lastPathComponent
      
      let fileTargetURL = targetURL.appendingPathComponent(targetName)
      
      logger.trace("Copying resource \(file.path) to \(fileTargetURL.path)")
      
      // copyItem fails if the target exists.
      try? fileManager.removeItem(at: fileTargetURL)
      
      do {
        try fileManager.copyItem(at: file, to: fileTargetURL)
      }
      catch {
        // TODO: Wrap in Own Error
        logger.error("Failed to copy resource:", fileTargetURL.path, error)
        throw ExitCode.couldNotCopyStaticResource
      }
    }
  }
  
  
  // MARK: - Files
  
  open func write(_ content: String, to relativePath: String) throws {
    let url = targetURL.appendingPathComponent(relativePath)
    // TODO: own error
    try content.write(to: url, atomically: false, encoding: .utf8)
  }

  
  // MARK: - Subdirectories

  open func ensureTargetDir(_ relativePath: String) throws {
    var url = targetURL
    if !relativePath.isEmpty { url.appendPathComponent(relativePath) }
    try ensureTargetDir(url)
  }
  
  private func ensureTargetDir(_ url: URL) throws {
    do {
      try fileManager
        .createDirectory(at: url, withIntermediateDirectories: true)
      logger.trace("Created output subdir:", url.path)
    }
    catch {
      logger.error("Could not create target directory:", url.path, error)
      throw ExitCode.couldNotCreateTargetDirectory
    }
  }

  
  // MARK: - Description
  
  open var description: String {
    return targetPath
  }
}
