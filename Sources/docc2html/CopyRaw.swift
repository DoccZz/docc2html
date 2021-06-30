//
//  CopyRaw.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Macro
import Logging

func copyRaw(_ files: [ URL ], to targetURL: URL, keepHash: Bool = true,
             logger: Logger = console)
{
  guard !files.isEmpty else { return }

  let fm = FileManager.default
  for file in files {
    let targetName = keepHash
                   ? file.lastPathComponent
                   : file.deletingResourceHash().lastPathComponent
    
    let fileTargetURL = targetURL.appendingPathComponent(targetName)
    
    logger.trace("Copying resource \(file.path) to \(fileTargetURL.path)")
    
    // copyItem fails if the target exists.
    try? fm.removeItem(at: fileTargetURL)
    
    do {
      try fm.copyItem(at: file, to: fileTargetURL)
    }
    catch {
      logger.error("Failed to copy resource:", fileTargetURL.path, error)
      exit(ExitCode.couldNotCopyStaticResource)
    }
  }
}

