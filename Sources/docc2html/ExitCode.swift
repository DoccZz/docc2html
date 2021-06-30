//
//  ExitCode.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation

// TBD: Maybe make that rather a special kind of exception
enum ExitCode: Int32, Swift.Error {
  case notEnoughArguments            = 1
  case expectedDocCArchive           = 2
  case couldNotCreateTargetDirectory = 3
  case targetDirectoryExists         = 4
  case couldNotLoadStaticResource    = 5
  case couldNotCopyStaticResource    = 6
}

func exit(_ error: ExitCode) -> Never {
  exit(error.rawValue)
}
func exit(_ error: Swift.Error) -> Never {
  if let error = error as? ExitCode { exit(error.rawValue) }
  print("ERROR: Unexpected error:", error)
  exit(42)
}
