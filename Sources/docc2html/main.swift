//
//  main.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Logging            // @apple/swift-log
import DocCStaticExporter // @docczz/docc2html
import DocCHTMLExporter   // @docczz/docc2html


// MARK: - Process Commandline Arguments and Setup Logging

guard let options = Options(argv: CommandLine.arguments) else {
  usage()
  exit(ExitCode.notEnoughArguments.rawValue)
}

LoggingSystem.bootstrap(options.logFactory)
let logger = Logger(label: "docc2html")


// MARK: - Load Templates, if available

let templates  : DZRenderingContext.Templates?
let stylesheet : String?
if let path = options.templatesPath {
  guard FileManager.default.fileExists(atPath: path) else {
    logger.error("Did not find templates directory:", path)
    exit(ExitCode.couldNotFindTemplatesDir)
  }
  
  logger.trace("Using templates directory:", path)
  ( templates, stylesheet ) = loadTemplatesAndStylesheet(from: path)
}
else {
  templates  = nil
  stylesheet = nil
}


// MARK: - Setup Site Exporter and Run

let exporter = DocCStaticExporter(
  target        : DocCFileSystemExportTarget(targetPath: options.targetPath),
  archivePathes : options.archivePathes,
  options       : options.exportOptions,
  templates     : templates,
  stylesheet    : stylesheet,
  logger        : logger
)

do {
  try exporter.export()
}
catch let error as DocCStaticExportError {
  exit(ExitCode(error).rawValue)
}
catch let error as ExitCode {
  exit(error.rawValue)
}
catch {
  exporter.logger.error("Unexpected error:", error)
  exit(99)
}
