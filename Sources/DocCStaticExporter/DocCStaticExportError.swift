//
//  DocCStaticExportError.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

public enum DocCStaticExportError: Swift.Error {
  
  case targetExists(DocCStaticExportTarget)
  
  case expectedDocCArchive(URL)

  case couldNotLoadStaticResource(URL, underlyingError: Swift.Error)
  
  case couldNotCopyStaticResource(from: URL, to: String)
  
  case couldNotCreateTargetDirectory(String, underlyingError: Swift.Error)
}
