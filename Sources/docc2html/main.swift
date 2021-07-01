//
//  main.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive // @DoccZz
import Logging     // @apple/swift-log

let fm = FileManager.default

// MARK: - Parse Commandline Arguments & Usage

guard let options = Options(argv: CommandLine.arguments) else {
  usage()
  exit(ExitCode.notEnoughArguments.rawValue)
}

LoggingSystem.bootstrap(options.logFactory)

func loadArchives(_ pathes: [ String ]) -> [ DocCArchive ] {
  var archives = [ DocCArchive ]()
  for path in pathes {
    do {
      let url = URL(fileURLWithPath: path)
      archives.append(try DocCArchive(contentsOf: url))
    }
    catch {
      console.error("Does not look like a .doccarchive:", error)
      exit(ExitCode.expectedDocCArchive.rawValue)
    }
  }
  return archives
}


// MARK: - Create Destination Folder

@discardableResult
func ensureTargetDir(_ relativePath: String) -> URL {
  var url = URL(fileURLWithPath: options.targetPath)
  if !relativePath.isEmpty { url.appendPathComponent(relativePath) }
  ensureTargetDir(url)
  return url
}
func ensureTargetDir(_ url: URL) {
  do {
    let fm = FileManager.default
    try fm.createDirectory(at: url, withIntermediateDirectories: true)
    console.trace("Created output subdir:", url.path)
  }
  catch {
    console.error("Could not create target directory:", url.path, error)
    exit(ExitCode.couldNotCreateTargetDirectory.rawValue)
  }
}

if !fm.fileExists(atPath: options.targetPath) {
  ensureTargetDir("")
}
else if !options.force {
  console.error("Target directory exists (call w/ -f/--force to overwrite):",
                options.targetPath)
  exit(ExitCode.targetDirectoryExists.rawValue)
}
else {
  console.log("Existing output dir:", options.targetPath)
}


// MARK: - Copy Static Resources

func copyStaticResources(of archives: [ DocCArchive ]) {
  for archive in archives {
    console.log("Copy static resources of:", archive.url.lastPathComponent)
    
    let cssFiles = archive.stylesheetURLs()
    if !cssFiles.isEmpty {
      copyCSS(archive.stylesheetURLs(), to: ensureTargetDir("css"),
              keepHash: options.keepHash)
    }
    
    copyRaw(archive.userImageURLs(),    to: ensureTargetDir("images"))
    copyRaw(archive.userVideoURLs(),    to: ensureTargetDir("videos"))
    copyRaw(archive.userDownloadURLs(), to: ensureTargetDir("downloads"))
    copyRaw(archive.favIcons(),         to: ensureTargetDir(""))
    
    copyRaw(archive.systemImageURLs(),  to: ensureTargetDir("img"),
            keepHash: options.keepHash)
  }
  
  do {
    let siteCSS = ensureTargetDir("css").appendingPathComponent("site.css")
    try stylesheet.write(to: siteCSS, atomically: false, encoding: .utf8)
  }
  catch {
    console.log("Failed to write custom stylesheet:", error)
  }
}

// MARK: - Generate

func generatePages(of archives: [ DocCArchive ]) {
  for archive in archives {
    
    if let folder = archive.documentationFolder() {
      let targetURL = options.targetURL.appendingPathComponent("documentation")
      buildFolder(folder, into: targetURL)
    }
    
    console.log("Generate archive:", archive.url.lastPathComponent)
  }
}


// MARK: - Run

let archives = loadArchives(options.archivePathes)
copyStaticResources(of: archives)
generatePages      (of: archives)
