//
//  BuildDocument.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive
import Macro

func buildDocument(_ document : DocCArchive.Document,
                   in  folder : DocCArchive.DocumentFolder,
                   to     url : URL) throws
{
  console.trace("Build:", document, "\n  to:", url.path)
  
  let ctx = RenderingContext(
    pathToRoot: String(repeating: "../", count: folder.level),
    references: document.references
  )
  
  let navTitle = folder.path.first.flatMap {
    if $0 == "documentation" { return "Documentation" }
    if $0 == "tutorials"     { return "Tutorials" }
    return nil
  } ?? "Documentation"
  
  let navPath = folder.path.dropFirst().map {
    NavigationItem(title: $0, isCurrent: false)
  } + [ NavigationItem(title: document.metadata.title, isCurrent: true) ]
  
  let primaryContent = document.primaryContentSections.flatMap { sections in
    PrimaryContent(
      abstractHTML : document.abstract?.generateHTML(in: ctx) ?? "",
      contentHTML  : sections.generateHTML(in: ctx)
    )
  } ?? ""
  
  assert(document.sections.isEmpty)
  
  let topicSections = document.topicSections.flatMap { sections in
    TopicSections(sections: sections.map { topic in
      .init(title: topic.title ?? "??", items: topic.identifiers.compactMap {
        guard let ref = ctx.references[$0.url.absoluteString] else {
          return nil
        }
        
        return .init(url: ref.generateURL(in: ctx),
                     abstractHTML: ref.generateAbstractHTML(in: ctx))
      })
    })
  } ?? ""
  
  let html = Page(
    relativePathToRoot: ctx.pathToRoot,
    title: document.metadata.title + "| Documentation",
    contentHTML:
      """
      \(Navigation(title: navTitle, items: navPath))
      <div id="main" role="main" class="main">
        \(TopicTitle(eyebrow: document.metadata.roleHeading?.rawValue ?? "",
                     title: document.metadata.title))
        \(primaryContent)
        \(topicSections)
      </div>
      """
  )
  
  try html.write(to: url, atomically: false, encoding: .utf8)
}
