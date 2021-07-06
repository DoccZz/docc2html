//
//  Options.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Logging
import DocCStaticExporter

func usage() {
  let tool = URL(fileURLWithPath: CommandLine.arguments.first ?? "docc2html")
              .lastPathComponent
  print(
    """
    Usage: \(tool) [-f/--force] <docc archive folders...> <target folder>
    
    Example:
    
      \(tool) SlothCreator.doccarchive /tmp/SlothCreator/
    
    Options:
    
      -f/--force:                 overwrite/merge target directories and files
      -s/--silent:                silent logging
      -v/--verbose:               verbose logging
      -t/--templates <directory>: directory containing template files
    """
  )
}

/// The options for the tool itself.
struct Options {

  var exportOptions : DocCStaticExporter.Options
                    = [ .buildIndex, .buildAPIDocs, .buildTutorials ]
  let archivePathes : [ String ]
  let targetPath    : String
  let templatesPath : String?
  let logFactory    : ( String ) -> LogHandler
  
  var targetURL     : URL { URL(fileURLWithPath: targetPath) }

  init?(argv: [ String ]) {
    var argv = argv
    
    func processFlag(_ long: String, _ short: String = "") -> Bool {
      let ok = argv.contains(long)
            || (short.isEmpty ? false : argv.contains(short))
      argv.removeAll(where: { $0 == long || $0 == short })
      return ok
    }
    
    if processFlag("--force", "-f") { exportOptions.insert(.force        ) }
    if processFlag("--keep-hash")   { exportOptions.insert(.keepHash     ) }
    if processFlag("--copy-css")    { exportOptions.insert(.copySystemCSS) }
    
    if let idx = argv.firstIndex(of: "-t")
              ?? argv.firstIndex(of: "--templates"),
       (idx + 1) < argv.count
    {
      argv.remove(at: idx)
      templatesPath = argv[idx]
      argv.remove(at: idx)
    }
    else {
      let binURL = URL(fileURLWithPath: #filePath)
      let pkgURL = binURL.deletingLastPathComponent()
                         .deletingLastPathComponent()
                         .deletingLastPathComponent()
      let url    = pkgURL.appendingPathComponent("Templates")
      var isDir  : ObjCBool = false
      let fm     = FileManager.default
      if fm.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
        templatesPath = url.path
      }
      else {
        templatesPath = nil
      }
    }
    
    do { // Logging
      let silent  = processFlag("--silent",  "-s")
      let verbose = processFlag("--verbose", "-v")
      
      logFactory = { label in
        var handler = StreamLogHandler.standardOutput(label: label)
        if      verbose { handler.logLevel = .trace }
        else if silent  { handler.logLevel = .error }
        return handler
      }
    }
    
    // TODO: scan for unprocessed `-` and throw an error?
        
    let pathes    = argv.dropFirst().filter { !$0.hasPrefix("-") }
    guard pathes.count > 1 else { return nil }
    archivePathes = Array(pathes.dropLast())
    targetPath    = pathes.last ?? ""
  }
}
