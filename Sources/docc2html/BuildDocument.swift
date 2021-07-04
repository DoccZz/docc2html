//
//  BuildDocument.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive
import DocCHTMLExporter

func buildDocument(_ document : DocCArchive.Document,
                   in  folder : DocCArchive.DocumentFolder,
                   to     url : URL) throws
{
  console.trace("Build:", document, "\n  to:", url.path)
  
  let ctx = DZRenderingContext(
    pathToRoot: String(repeating: "../", count: folder.level),
    references: document.references
  )
  
  let html = try ctx.buildDocument(document, in: folder)
  
  try html.write(to: url, atomically: false, encoding: .utf8)
}
