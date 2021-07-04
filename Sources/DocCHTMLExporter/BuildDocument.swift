//
//  BuildDocument.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import DocCArchive

public extension DZRenderingContext {
  
  func buildDocument(_ document : DocCArchive.Document,
                     in  folder : DocCArchive.DocumentFolder) throws -> String
  {
    logger.trace("Build:", document.identifier.url.lastPathComponent)
    
    let navTitle = folder.path.first.flatMap {
      if $0 == "documentation" { return labels.documentation }
      if $0 == "tutorials"     { return labels.tutorials }
      return nil
    } ?? labels.documentation
    
    let navPath = document.buildNavigationPath(in: folder, with: self)
    
    let primaryContent = document.primaryContentSections.flatMap { sections in
      PrimaryContent(
        abstractHTML : document.abstract?.generateHTML(in: self) ?? "",
        contentHTML  : sections.generateHTML(in: self)
      )
    } ?? ""
    
    // This is for tutorials, e.g. document.kind == .project
    // they have no primaryContent/topicSections
    let sectionsContent = document.sections.generateHTML(in: self)
    
    let topicSections = document.topicSections.flatMap { sections in
      BuildSections(title: labels.topics, sectionID: "topics",
                    sections: sections.map
      {
        $0.generateTemplateSection(in: self)
      })
    } ?? ""
    
    let seeAlso = document.seeAlsoSections.flatMap { sections in
      BuildSections(title: labels.seeAlso, sectionID: "see-also",
                    sections: sections.map
      {
        $0.generateTemplateSection(in: self)
      })
    } ?? ""

    let html = Page(
      relativePathToRoot: self.pathToRoot,
      title: document.metadata.title + "| Documentation",
      contentHTML:
        DocumentContent(
          navigationHTML: Navigation(title: navTitle, items: navPath),
          topicTitleHTML:
            TopicTitle(eyebrow: document.metadata.roleHeading?.rawValue ?? "",
                                     title: document.metadata.title),
          primaryContentHTML  : primaryContent,
          sectionsContentHTML : sectionsContent,
          topicSectionsHTML   : topicSections, seeAlsoHTML: seeAlso
        )
    )
    
    return html
  }
}
