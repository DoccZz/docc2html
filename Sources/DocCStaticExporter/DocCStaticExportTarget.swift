//
//  DocCStaticExportTarget.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

public protocol DocCStaticExportTarget {
  
  /// Check whether the exporter container does already exist (to suppor the
  /// (non) --force option).
  func doesTargetExist() -> Bool

  /**
   * Makes sure that the given relative directory exists and can be written to
   * subsequently.
   *
   * Example:
   *
   *     ensureTargetDir("css")
   *
   */
  func ensureTargetDir(_ relativePath: String) throws

  func copyCSS(_ cssFiles: [ URL ], keepHash: Bool) throws
  
  /**
   * Copy the files from the given URLs to the directory within the target.
   *
   * Use an empty string for "root"
   *
   * Example:
   *
   *     copyRaw(archive.userImageURLs(), to: "images")
   */
  func copyRaw(_ files: [ URL ], to directory: String, keepHash: Bool) throws
  
  /// Write some content (e.g. a rendered page) to the given relative path
  func write(_ content: String, to relativePath: String) throws
}

public extension DocCStaticExportTarget {
  
  func copyRaw(_ files: [ URL ], to directory: String) throws {
    try copyRaw(files, to: directory, keepHash: false)
  }
}
