//
//  InlineContentHTML.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension Sequence where Element == DocCArchive.InlineContent {
  
  func generateHTML(in ctx: RenderingContext) -> String {
    return map { $0.generateHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.InlineContent {
  
  func generateHTML(in ctx: RenderingContext) -> String {
    switch self {
      case .text(let value):
        return value.htmlEscaped
        
      case .emphasis(let value):
        return "<em>" + value.generateHTML(in: ctx) + "</em>"
        
      case .reference(let identifier, let isActive):
        // e.g. /documentation/SlothCreator/Sloth
        if let ref = ctx.references[identifier.stringValue] {
          return ref.generateHTML(isActive: isActive, in: ctx)
        }
        else {
          let activeClass = isActive ? "" : " class='inactive'"
          assertionFailure("missing ref \(identifier)?")
          let url = ctx.pathToRoot + identifier.url.path + ".html"
          var ms = "<a href='\(url.htmlEscaped)'\(activeClass)>"
          ms += "<code>\(identifier.url.lastPathComponent)</code>"
          ms += "</a>"
          return ms
        }
                
      case .image(let identifier):
        if let ref = ctx.references[identifier] {
          return ref.generateHTML(in: ctx)
        }
        else {
          let url = ctx.pathToRoot + identifier
          return "<img src='\(url.htmlEscaped)' />"
        }

      case .codeVoice(let code):
        // DocC inserts a few wbr tags here, we could too I guess, though I'm
        // not sure what algo they use here (before a `.` and before uppercase?)
        return "<code>\(code.htmlEscaped)</code>"
    }
  }
}
