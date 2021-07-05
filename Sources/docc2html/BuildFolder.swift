//
//  BuildFolder.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive
import DocCHTMLExporter

func buildFolder(_ folder: DocCArchive.DocumentFolder, into url: URL,
                 buildIndex: Bool)
{
  ensureTargetDir(url)
  
  let subfolders = folder.subfolders()

  for subfolder in subfolders {
    let dest = url.appendingPathComponent(subfolder.url.lastPathComponent)
    buildFolder(subfolder, into: dest, buildIndex: buildIndex)
  }
  let subfolderNames = Set(subfolders.map { $0.url.lastPathComponent })

  for pageURL in folder.pageURLs() {
    do {
      let document   = try folder.document(at: pageURL)
      let baseName   = pageURL.deletingPathExtension().lastPathComponent
      let pathToRoot = String(repeating: "../", count: folder.level)
      
      var indexURL : URL? {
        let isIndexPage = subfolderNames.contains(baseName)
        guard isIndexPage else { return nil }
        return url.appendingPathComponent(baseName)
                  .appendingPathComponent("index.html")
      }
      
      do {
        let htmlURL = url.appendingPathComponent(
          pageURL
            .deletingPathExtension() // JSON
            .appendingPathExtension("html")
            .lastPathComponent
        )

        console.trace("Build:", document, "\n  to:", htmlURL.path)
        
        let ctx = DZRenderingContext(
          pathToRoot : pathToRoot,
          references : document.references,
          isIndex    : false,
          indexLinks : buildIndex
        )
        
        let html = try ctx.buildDocument(document, in: folder)
        
        try html.write(to: htmlURL, atomically: false, encoding: .utf8)
      }
      
      if buildIndex, let htmlURL = indexURL {
        console.trace("Index:", document, "\n  to:", htmlURL.path)
        
        let ctx = DZRenderingContext(
          pathToRoot : pathToRoot + "../",
          references : document.references,
          isIndex    : true,
          indexLinks : true
        )
        
        let html = try ctx.buildDocument(document, in: folder)
        
        try html.write(to: htmlURL, atomically: false, encoding: .utf8)
      }
    }
    catch {
      console.error("ERROR: Could not process document at:",
                    pageURL.path, error)
    }
  }
}
