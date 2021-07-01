//
//  BuildDocument.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

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
  
  // This is for tutorials, e.g. document.kind == .project
  // they have no topicSections
  assert(document.sections.isEmpty)
  
  let topicSections = document.topicSections.flatMap { sections in
    BuildSections(title: "Topics", sectionID: "topics", sections: sections.map {
      $0.generateTemplateSection(in: ctx)
    })
  } ?? ""
  
  let seeAlso = document.seeAlsoSections.flatMap { sections in
    BuildSections(title: "See Also", sectionID: "see-also",
                  sections: sections.map
    {
      $0.generateTemplateSection(in: ctx)
    })
  } ?? ""

  let html = Page(
    relativePathToRoot: ctx.pathToRoot,
    title: document.metadata.title + "| Documentation",
    contentHTML:
      DocumentContent(
        navigationHTML: Navigation(title: navTitle, items: navPath),
        topicTitleHTML:
          TopicTitle(eyebrow: document.metadata.roleHeading?.rawValue ?? "",
                                   title: document.metadata.title),
        primaryContentHTML: primaryContent,
        topicSectionsHTML: topicSections, seeAlsoHTML: seeAlso
      )
  )
  
  try html.write(to: url, atomically: false, encoding: .utf8)
}
