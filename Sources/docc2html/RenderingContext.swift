//
//  RenderingContext.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import DocCArchive // @DocZ
import struct Foundation.URL

fileprivate let ModuleToExternalURL : [ String : URL ] = [
  "Foundation":
    URL(string: "https://developer.apple.com/documentation/foundation/")!,
  "AppKit":
    URL(string: "https://developer.apple.com/documentation/appkit/")!,
  "UIKit":
    URL(string: "https://developer.apple.com/documentation/uikit/")!
]

final class RenderingContext {
  
  let pathToRoot : String
  let references : [ String : DocCArchive.Reference ]
  let traits     : Set<DocCArchive.ImageReference.Variant.Trait>
                 = [ .light, .retina ]

  init(pathToRoot: String, references: [ String : DocCArchive.Reference ]) {
    self.pathToRoot = pathToRoot
    self.references = references
  }
  
  
  // MARK: - URLs
  
  func makeRelativeToRoot(_ url: String) -> String {
    if url.hasPrefix("/") { return pathToRoot + url.dropFirst() }
    return pathToRoot + url
  }
  func makeRelativeToRoot(_ url: URL) -> String {
    return makeRelativeToRoot(url.path)
  }
  
  func externalDocumentBaseURL(for module: String) -> URL? {
    return ModuleToExternalURL[module]
  }
  func externalURLForTypeID(_ id: DocCArchive.DocCSchema.TypeIdentifier?)
       -> URL?
  {
    // https://developer.apple.com/documentation/foundation/date
    guard let id = id         else { return nil }
    guard id.parts.count == 2 else { return nil }
    guard let baseURL = externalDocumentBaseURL(for: id.parts[0]) else {
      return nil
    }
    return id.parts.dropFirst().reduce(baseURL) {
      $0.appendingPathComponent($1)
    }
  }
  
  // MARK: - References
  
  subscript(reference key: String) -> DocCArchive.Reference? {
    return references[key]
  }
  subscript(reference id: DocCArchive.DocCSchema.Identifier)
    -> DocCArchive.Reference?
  {
    return self[reference: id.stringValue]
  }
}
