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
import Mustache

/**
 * The object is used for rendering a single document. Not intended to be
 * invoked multiple times.
 */
open class DZRenderingContext {

  public static let defaultStyleSheet = stylesheet
  
  public struct Labels {
    public var documentation = "Documentation"
    public var tutorials     = "Tutorials"
    public var topics        = "Topics"
    public var seeAlso       = "See Also"
    public var declaration   = "Declaration"
    public var parameters    = "Parameters"
    public var framework     = "Framework"
    public var taskSection   = "Section"
    public var volumeChapter = "Chapter"
  }
  
  public struct Templates {

    public init() {}
    
    /// Arguments:
    /// relativePathToRoot, highlightCDN, contentHTML, footerHTML, title,
    /// cssPath
    public var htmlWrapper         : Mustache = PageTemplate
    
    /// Generates the navigation and the outer `main` tag.
    /// Arguments:
    //  navigationHTML, topicTitleHTML, primaryContentHTML, sectionsContentHTML,
    //  topicSectionsHTML, seeAlsoHTML,
    public var documentContent     : Mustache = DocumentContentTemplate
    
    /// Arguments: title, items(title,isCurrent,link)
    public var navigation          : Mustache = NavigationTemplate

    /// Arguments: abstractHTML, contentHTML
    public var primaryContentGrid  : Mustache = PrimaryContentGridTemplate
    
    /// Arguments: syntax, lines(line/code)
    public var codeListing         : Mustache = CodeListingTemplate
    
    /// Arguments:
    /// step, stepIndex, contentHTML, captionHTML, syntax, hasCode, lines
    public var step                : Mustache = StepTemplate
    
    /// Arguments: title, tokensHTML
    public var declarationSection  : Mustache = DeclarationSectionTemplate
    
    /// Arguments: title, parameters(name,contentHTML)
    public var parametersSection   : Mustache = ParametersSectionTemplate
    
    /// This is used for Topics and See Also
    /// Arguments:
    /// title, sectionID,
    /// sections(tile,items(url, decoratedTitleHTML, title, abstractHTML,
    ///                     isDeprecated))
    public var contentTableSection : Mustache = ContentTableSectionTemplate
    
    /// Arguments: title, eyebrow
    public var topicTitle          : Mustache = TopicTitleTemplate
    
    /// Arguments: eyebrow, title, duration, contentHTML, backgroundImage
    public var hero                : Mustache = HeroTemplate

    public var task                : Mustache = TaskTemplate
    public var taskIntro           : Mustache = TaskIntroTemplate
    
    public var volume              : Mustache = VolumeTemplate
  }
  
  let logger              : Logger

  let pathToRoot          : String
  let references          : [ String : DocCArchive.Reference ]
  let indexLinks          : Bool
  let isIndex             : Bool
  let dataFolderPathes    : Set<String>
  let traits              : Set<DocCArchive.ImageReference.Variant.Trait>
                          = [ .light, .retina ]
  
  let labels              : Labels
  let templates           : Templates
  let moduleToExternalURL : [ String : URL ]
  let highlightCDN        =
        "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.0.1"
  
  var activeStep = 0
  
  /**
   * Parameters:
   * - pathToRoot: The relative path to the root folder (containing css etc)
   * - references: DocCArchive references available for resolution
   * - templates:  The Mustache templates to be used for rendering
   * - labels:     The labels to be used for rendering
   * - moduleToExternalURL: Optional map of modules (like Foundation) to an
   *                        external site hosting documentation for those.
   * - logger:     The Logger to be used (defaults to `docc2html`)
   */
  public init(pathToRoot          : String,
              references          : [ String : DocCArchive.Reference ],
              isIndex             : Bool,
              dataFolderPathes    : Set<String>,
              indexLinks          : Bool,
              templates           : Templates?        = nil,
              labels              : Labels?           = nil,
              moduleToExternalURL : [ String : URL ]? = nil,
              logger              : Logger = Logger(label: "docc2html"))
  {
    self.pathToRoot          = pathToRoot
    self.references          = references
    self.isIndex             = isIndex
    self.dataFolderPathes    = dataFolderPathes
    self.indexLinks          = indexLinks
    self.templates           = templates ?? Templates()
    self.labels              = labels    ?? Labels()
    self.moduleToExternalURL = moduleToExternalURL ?? ModuleToExternalURL
    self.logger              = logger
  }
    
  
  // MARK: - URLs
  

  private func makeRelativeToRoot(_ url: String) -> String {
    if url.hasPrefix("/") { return pathToRoot + url.dropFirst() }
    return pathToRoot + url
  }
  private func makeRelativeToRoot(_ url: URL) -> String {
    // Since identifier (reference URL) is used to form links rather than url,
    // it's path needs to be lowercased, as url is, in order to match generated files .
    return makeRelativeToRoot(url.path.lowercased())
  }

  func linkToResource(_ url: String) -> String {
    return makeRelativeToRoot(url)
  }

  func linkToDocument(_ identifierURL: URL) -> String {
    // Note: This is not very clever yet, it essentially goes up the chain
    //       using `../..` and then appends the "absolute" path, like
    //       `../../documentation/SwiftBlocksUI/index.html`.
    // Note: Those can have path extensions, e.g. "color-swift.property"
    assert(identifierURL.scheme == "doc")
    assert(!dataFolderPathes.isEmpty)
    
    // This is a little hacky, but yeah. The dataFolderPathes are always
    // lowercase. Technically we are supposed to use the reference URL,
    // but that doesn't come w/ the `doc` scheme and is probably less safe
    // to use.
    let isIndexed = dataFolderPathes.contains(identifierURL.path.lowercased())
    
    let url = isIndexed
      ? identifierURL.appendingPathComponent("index.html")
      : identifierURL.appendingPathExtension("html")
    return makeRelativeToRoot(url)
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
