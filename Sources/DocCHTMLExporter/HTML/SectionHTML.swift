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
  
  func generateHTML(in ctx: DZRenderingContext) -> String {
    map { $0.generateHTML(in: ctx) }.joined()
  }
}

extension DocCArchive.Section {

  func generateHTML(in ctx: DZRenderingContext) -> String {
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

extension DocCArchive.Section {
  
  func generateTemplateSection(in ctx: DZRenderingContext) -> Section {
    Section(title: self.title ?? "??", items: self.identifiers.compactMap {
      guard let ref = ctx.references[$0.url.absoluteString] else {
        return nil
      }
      
      switch ref {
        case .topic(let tr):
          return .init(url: ref.generateURL(in: ctx),
                       decoratedTitleHTML:
                         tr.fragments?.generateDecoratedTitleHTML(in: ctx) ?? "",
                       title: tr.title,
                       abstractHTML: ref.generateAbstractHTML(in: ctx),
                       isDeprecated: tr.deprecated ?? false)
        case .image, .file, .section, .unresolvable:
          return .init(url: ref.generateURL(in: ctx),
                       decoratedTitleHTML: "",
                       title: "",
                       abstractHTML: ref.generateAbstractHTML(in: ctx),
                       isDeprecated: false)
      }
    })
  }
}
