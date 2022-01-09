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
  
  func generateHTML(in ctx: DZRenderingContext) -> String {
    return map { $0.generateHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.Content {
  
  func generateHTML(in ctx: DZRenderingContext) -> String {
    switch self {
      case .heading(let text, let anchor, let level):
        var ms = "<h\(level)"
        if !anchor.isEmpty { ms += " id='\(anchor.htmlEscaped)'" }
        ms += ">" + text.htmlEscaped + "</h\(level)>"
        return ms

      case .paragraph(let inlineContent):
        return "<p>" + inlineContent.generateHTML(in: ctx) + "</p>"
        
      case .orderedList(let items):
        var ms = "<ol>"
        for item in items {
          ms += "<li><p>\(item.content.generateHTML(in: ctx))</p></li>"
        }
        ms += "</ol>"
        return ms
      case .unorderedList(let items):
        var ms = "<ul>"
        for item in items {
          ms += "<li><p>\(item.content.generateHTML(in: ctx))</p></li>"
        }
        ms += "</ul>"
        return ms
      
      case .table(let headerKind, let rows):
        assert(headerKind == .row)
        var ms = "<table>"
        if let headerRow = rows.first {
          ms += "<thead><tr>"
          for cell in headerRow {
            ms += "<th scope='col'>" // no idea what the scope is supposed to be
            ms += cell.generateHTML(in: ctx)
            ms += "</th>"
          }
          ms += "</tr></thead>"
          
          ms += "<tbody>"
          for row in rows.dropFirst() {
            ms += "<tr>"
            for cell in row {
              ms += "<td>"
              ms += cell.generateHTML(in: ctx)
              ms += "</td>"
            }
            ms += "</tr>"
          }
          ms += "</tbody>"
        }
        else {
          ms += "<!-- table w/o content, not even a header -->"
        }
        ms += "</table>"
        return ms

      case .aside(let style, let content):
        var ms = "<aside class='\(style.rawValue)'>" // ARIA?
        if style == .note { ms += "<p class='label'>Note</p>" }
        ms += "<p>\(content.generateHTML(in: ctx))</p>"
        if style == .note { ms += "</p>" }
        ms += "</aside>"
        return ms
      
      case .step(let step):
        ctx.activeStep += 1 // unfortunately the index is not part of the JSON
      
        let code : DocCArchive.DocCSchema.FileReference? = step.code.flatMap {
          id in
          
          guard let ref = ctx[reference: id] else {
            assertionFailure("did not find code id: \(id)")
            return nil
          }
          guard case .file(let file) = ref else {
            assertionFailure("code ref is not a file!: \(id) \(ref)")
            return nil
          }
          return file
        }

        return ctx.renderStep(ctx.activeStep,
                              contentHTML : step.content.generateHTML(in: ctx),
                              captionHTML : step.caption.generateHTML(in: ctx),
                              syntax      : code?.fileType.rawValue ?? "swift",
                              lines       : code?.content ?? [])
        
      case .codeListing(let listing):
        return ctx.renderCodeListing(syntax: listing.syntax,
                                     lines: listing.code)
    }
  }
}
