//
//  ReferenceHTML.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension DocCArchive.Reference {

  func generateHTML(isActive: Bool = true, in ctx: DZRenderingContext) -> String {
    var idURL : URL? { return URL(string: identifier) }
    
    switch self {
    
      case .topic(let ref):
        return ref.generateHTML(isActive: isActive, idURL: idURL, in: ctx)
        
      case .image(let ref):
        return ref.generateHTML(in: ctx)
        
      case .file(_):
        fatalError("unsupported file ref")
      case .section(_):
        fatalError("unsupported section ref")
        
      case .unresolvable(_, let title):
        return title.htmlEscaped
    }
    return "<!-- unsupported reference \(identifier) -->"
  }
  
  func generateRelativeURL(in ctx: DZRenderingContext) -> String {
    var idURL : URL? { return URL(string: identifier) }
    
    switch self {
    
      case .topic(let ref):
        guard let url = ref.url ?? idURL else { return "" }
        return ctx.makeRelativeToRoot(url) + ".html"

      case .image(let ref):
        guard let variant = ref.bestVariant(for: ctx.traits) else { return "" }
        return ctx.makeRelativeToRoot(variant.url)
        
      case .file(_):
        fatalError("unsupported file ref")
      case .section(_):
        fatalError("unsupported section ref")
        
      case .unresolvable:
        return ""
    }
    return ""
  }

  func generateDecoratedTitleHTML(in ctx: DZRenderingContext) -> String {
    switch self {
      case .image, .file, .unresolvable: return ""

      case .topic(let ref):
        if ref.kind == .symbol {
          assert(ref.fragments != nil, "missing fragment")
          return ref.fragments?.generateDecoratedTitleHTML(in: ctx) ?? ""
        }
        else {
          assert(ref.fragments == nil, "unexpected fragment")
          return ""
        }
        
      case .section(_):
        fatalError("unsupported section ref")
    }
  }

  func generateAbstractHTML(in ctx: DZRenderingContext) -> String {
    switch self {
    
      case .topic(let ref):
        return ref.abstract.generateHTML(in: ctx)
        
      case .image(let ref):
        return ref.alt.htmlEscaped
        
      case .file(_):
        fatalError("unsupported file ref")
      case .section(_):
        fatalError("unsupported section ref")
        
      case .unresolvable(_, let title):
        return title.htmlEscaped
    }
    return "<!-- unsupported reference \(identifier) -->"
  }
}

extension DocCArchive.TopicReference {

  /**
   * Generate an <a> for the topic reference.
   */
  func generateHTML(isActive: Bool = true, idURL: URL?,
                    in ctx: DZRenderingContext) -> String
  {
    let activeClass = isActive ? "" : " class='inactive'"
    let title       = self.title.htmlEscaped
    let url = (self.url ?? idURL).flatMap {
      ctx.makeRelativeToRoot($0.appendingPathExtension("html"))
    } ?? ""

    var ms = ""
    if !url.isEmpty { ms += "<a href='\(url.htmlEscaped)'\(activeClass)>" }
    
    switch kind {
      case .none   : ms += title
      case .symbol : ms += "<code>\(title)</code>"
        
      case .article, .overview, .project:
        assertionFailure("unsupported kind: \(kind as Any)")
        ms += title
    }
    if !url.isEmpty { ms += "</a>" }
    return ms
  }
}

extension DocCArchive.ImageReference {
  
  /**
   * Generate the `img` tag for the variant selected in the rendering context.
   * TBD: Good idea or not?
   */
  func generateHTML(in ctx: DZRenderingContext) -> String {
    guard let variant = bestVariant(for: ctx.traits) else {
      assertionFailure("Got no image variant?")
      return "<!-- invalid image ref -->\(alt.htmlEscaped)"
    }
    
    let media : String = {
      if ctx.traits.contains(.dark) {
        return " media='(prefers-color-scheme: dark)'"
      }
      else if ctx.traits.contains(.light) {
        return " media='(prefers-color-scheme: light)'"
      }
      else {
        return ""
      }
    }()
    
    let url    = ctx.makeRelativeToRoot(variant.url)
    let srcset = url.htmlEscaped
               + (ctx.traits.contains(.retina) ? " 2x" : "")

    var ms = "<picture><source\(media) srcset='\(srcset)'>"

    ms += "<img"
    if !alt.isEmpty { ms += " alt='\(alt.htmlEscaped)'" }
    ms += " srcset='\(srcset)'"
    ms += " src='\(url.htmlEscaped)'"
    ms += " width='\(variant.size.width)' height='auto'"
    ms += " />"
    ms += "</source></picture>"
    return ms
  }
}
