//
//  SectionHTML.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension Sequence where Element == DocCArchive.Section {
  
  func generateHTML(in ctx: RenderingContext) -> String {
    map { $0.generateHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.Section {

  func generateHTML(in ctx: RenderingContext) -> String {
    // has title, identifiers, generated and kind
    switch self.kind {
      case .content(let content):
        // Note: 'content' sections do not generate a `<section>`.
        // But I do think the 'content' div doesn't belong inside.
        return "<div class='content'>"
             + content.map { $0.generateHTML(in: ctx) }.joined()
             + "</div>"
        
      case .generic:
        fatalError("not implemented")
        
      case .relationships(let section):
        fatalError("not implemented \(section)")
        
      case .declarations(let declarations):
        // I think this would only contain multiple declarations for different
        // languages/platforms combinations?
        // FIXME: This is slightly wrong, it needs to be done in the template
        return declarations.map {
                 DeclarationSection(tokensHTML: $0.tokens.generateHTML(in: ctx))
               }.joined()
        
      case .hero(let section):
        fatalError("not implemented \(section)")
      case .volume(let section):
        fatalError("not implemented \(section)")

      case .parameters(let parameters):
        return ParametersSection(parameters: parameters.map {
          .init(name: $0.name, contentHTML: $0.content.generateHTML(in: ctx))
        })
      
      case .tasks(let section):
        fatalError("not implemented \(section)")
    }
    return ""
  }
}
