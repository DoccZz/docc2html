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
