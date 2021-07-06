//
//  ExitCode.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Logging
import DocCStaticExporter

enum ExitCode: Int32, Swift.Error {
  case notEnoughArguments            = 1
  case expectedDocCArchive           = 2
  case couldNotCreateTargetDirectory = 3
  case targetDirectoryExists         = 4
  case couldNotLoadStaticResource    = 5
  case couldNotCopyStaticResource    = 6
  case couldNotFindTemplatesDir      = 7
}

extension ExitCode {
  
  init(_ error: DocCStaticExportError) {
    switch error {
      case .targetExists                 : self = .targetDirectoryExists
      case .expectedDocCArchive          : self = .expectedDocCArchive
      case .couldNotLoadStaticResource   : self = .couldNotLoadStaticResource
      case .couldNotCopyStaticResource   : self = .couldNotCopyStaticResource
      case .couldNotCreateTargetDirectory: self = .couldNotCreateTargetDirectory
    }
  }
}

func exit(_ error: ExitCode) -> Never {
  exit(error.rawValue)
}
func exit(_ error: Swift.Error) -> Never {
  if let error = error as? ExitCode { exit(error.rawValue) }
  Logger(label: "docc2html").error("Unexpected error:", error)
  exit(42)
}
