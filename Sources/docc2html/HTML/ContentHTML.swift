//
//  ContentHTML.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension Sequence where Element == DocCArchive.Content {
  
  func generateHTML(in ctx: RenderingContext) -> String {
    return map { $0.generateHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.Content {
  
  func generateHTML(in ctx: RenderingContext) -> String {
    switch self {
      case .heading(let text, let anchor, let level):
        var ms = "<h\(level)"
        if !anchor.isEmpty { ms += " id='\(anchor.htmlEscaped)'" }
        ms += ">" + text.htmlEscaped + "</h\(level)>"
        return ms

      case .paragraph(let inlineContent):
        return "<p>" + inlineContent.generateHTML(in: ctx) + "</p>"
        
      case .aside(let style, let content):
        var ms = "<aside class='\(style.rawValue)'>" // ARIA?
        if style == .note { ms += "<p class='label'>Note</p>" }
        ms += "<p>\(content.generateHTML(in: ctx))</p>"
        if style == .note { ms += "</p>" }
        ms += "</aside>"
        return ms

      case .codeListing(let listing):
        return CodeListingContent(syntax: listing.syntax, lines: listing.code)
    }
  }
}
