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
    
      -f/--force:   overwrite/merge target directories and files
      -s/--silent:  silent logging
      -v/--verbose: verbose logging
      --keep-hash:  keep hashes in resource names
      --copy-css:   copy the CSS folder in the archive to the target
    """
  )
}

/// The options for the tool itself.
struct Options {

  var exportOptions : DocCStaticExporter.Options
                    = [ .buildIndex, .buildAPIDocs, .buildTutorials ]
  let archivePathes : [ String ]
  let targetPath    : String
  let logFactory    : ( String ) -> LogHandler
  
  var targetURL     : URL { URL(fileURLWithPath: targetPath) }

  init?(argv: [ String ]) {
    if argv.contains("--force") || argv.contains("-f") {
      exportOptions.insert(.force)
    }
    if argv.contains("--keep-hash") { exportOptions.insert(.keepHash     ) }
    if argv.contains("--copy-css")  { exportOptions.insert(.copySystemCSS) }
    
    let silent  = argv.contains("--silent")  || argv.contains("-s")
    let verbose = argv.contains("--verbose") || argv.contains("-v")

    logFactory = { label in
      var handler = StreamLogHandler.standardOutput(label: label)
      if      verbose { handler.logLevel = .trace }
      else if silent  { handler.logLevel = .error }
      return handler
    }
    
    let pathes  = argv.dropFirst().filter { !$0.hasPrefix("-") }
    guard pathes.count > 1 else { return nil }
    archivePathes = Array(pathes.dropLast())
    targetPath    = pathes.last ?? ""
  }
}
