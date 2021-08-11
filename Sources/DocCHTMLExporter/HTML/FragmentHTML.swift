//
//  FragmentHTML.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension Sequence where Element == DocCArchive.Fragment {
  
  func generateHTML(in ctx: DZRenderingContext) -> String {
    return map { $0.generateHTML(in: ctx) }.joined()
  }
  func generateDecoratedTitleHTML(in ctx: DZRenderingContext) -> String {
    return map { $0.generateDecoratedTitleHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.Fragment {
  
  /// Return nil for no-span, empty for span w/o class
  var spanClass : String? {
    switch self {
      case .text             : return nil
      case .keyword          : return "token-keyword"
      case .identifier       : return "token-identifier"
      case .externalParam    : return "token-externalParam"
      case .internalParam    : return "token-internalParam"
      case .genericParameter : return "token-genericParameter"
      case .attribute        : return "token-attribute"
      case .typeIdentifier   : return ""
    }
  }

  func generateHTML(in ctx: DZRenderingContext) -> String {
    let content = stringValue.htmlEscaped
    
    switch self {
      case .text, .keyword, .identifier,
           .externalParam, .internalParam, .genericParameter, .attribute:
        break

      case .typeIdentifier(let text, let id, let tid):
        if let id = id, let ref = ctx.references[id.stringValue] {
          let url = ref.generateRelativeURL(in: ctx)
          var ms = "<a class='type-identifier-link' href='\(url.htmlEscaped)'>"
          ms += "<span>\(text.htmlEscaped)</span>"
          ms += "</a>"
          return ms
        }
        else if let url = ctx.externalURLForTypeID(tid)?.absoluteString {
          // Or builtin stuff like `Date` "s:10Foundation4DateV"
          // https://developer.apple.com/documentation/foundation/date
          var ms = "<a class='type-identifier-link' href='\(url.htmlEscaped)'>"
          ms += "<span>\(text.htmlEscaped)</span>"
          ms += "</a>"
          return ms
        }
        else {
          // Happens in fragments, though they still have the precideIdentifier
          return text.htmlEscaped
        }
    }

    if let clazz = spanClass {
      if clazz.isEmpty { return "<span>\(content)</span>"                  }
      else             { return "<span class='\(clazz)'>\(content)</span>" }
    }
    else {
      return content
    }
  }

  /**
   * Those are used in symbol topic titles. They render the fragments
   * differently.
   */
  func generateDecoratedTitleHTML(in ctx: DZRenderingContext) -> String {
    let content     = stringValue
    let contentHTML = content.htmlEscaped
    var spanClass   : String

    switch self {
      case .text, .keyword, .typeIdentifier,
           .externalParam, .internalParam, .genericParameter, .attribute:
        spanClass = "decorator"
      case .identifier:
        spanClass = "identifier"
    }

    if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      spanClass += " empty-token"
    }

    return "<span class='\(spanClass)'>\(contentHTML)</span>"
  }
}
