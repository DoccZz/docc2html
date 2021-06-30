//
//  CopyCSS.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Macro
import Logging

func copyCSS(_ cssFiles: [ URL ], to targetURL: URL, keepHash: Bool,
             logger: Logger = console)
{
  guard !cssFiles.isEmpty else { return }
  
  for css in cssFiles {
    let cssContents : String
    do {
      cssContents = try String(contentsOf: css)
                        .stringByRemovingDocCDataReferences()
    }
    catch {
      logger.error("Failed to load CSS:", css.path)
      exit(ExitCode.couldNotLoadStaticResource)
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
      logger.error("Failed to save CSS:", cssTargetURL.path)
      exit(ExitCode.couldNotCopyStaticResource)
    }
  }
}
