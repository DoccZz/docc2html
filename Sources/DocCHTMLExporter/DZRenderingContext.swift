//
//  DZRenderingContext.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL
import DocCArchive
import Logging

/**
 * The object is used for rendering a single document. Not intended to be
 * invoked multiple times.
 */
public final class DZRenderingContext {

  public static let defaultStyleSheet = stylesheet
  
  struct Labels {
    let documentation = "Documentation"
    let tutorials     = "Tutorials"
    let topics        = "Topics"
    let seeAlso       = "See Also"
  }
  
  let logger     : Logger
  let labels     = Labels()

  let pathToRoot : String
  let references : [ String : DocCArchive.Reference ]
  let traits     : Set<DocCArchive.ImageReference.Variant.Trait>
                 = [ .light, .retina ]
  
  let moduleToExternalURL : [ String : URL ] = ModuleToExternalURL

  
  var activeStep = 0
  
  public init(pathToRoot : String,
              references : [ String : DocCArchive.Reference ],
              logger     : Logger = Logger(label: "docc2html"))
  {
    self.pathToRoot = pathToRoot
    self.references = references
    self.logger     = logger
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
    return moduleToExternalURL[module]
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
