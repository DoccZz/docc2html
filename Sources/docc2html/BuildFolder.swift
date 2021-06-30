//
//  BuildFolder.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

func buildFolder(_ folder: DocCArchive.DocumentFolder, into url: URL) {
  ensureTargetDir(url)

  for subfolder in folder.subfolders() {
    let dest = url.appendingPathComponent(subfolder.url.lastPathComponent)
    buildFolder(subfolder, into: dest)
  }

  for pageURL in folder.pageURLs() {
    do {
      let htmlURL = url.appendingPathComponent(
        pageURL
          .deletingPathExtension() // JSON
          .appendingPathExtension("html")
          .lastPathComponent
      )
      
      print("BUILD:", pageURL.path)
      let document = try folder.document(at: pageURL)
      try buildDocument(document, in: folder, to: htmlURL)
    }
    catch {
      print("ERROR: Could not process document at:", pageURL.path, error)
    }
  }
}
