//
//  DocumentContent.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

let DocumentContentTemplate = Mustache(
  """
  {{{navigationHTML}}}
  <main id="main" role="main" class="main">
    {{{topicTitleHTML}}}
    {{{primaryContentHTML}}}
    {{#sectionsContentHTML}}
      <div class="sections">{{{sectionsContentHTML}}}</div>
    {{/sectionsContentHTML}}
    {{{topicSectionsHTML}}}
    {{{seeAlsoHTML}}}
  </main>
  """
)

extension DZRenderingContext {

  /// Generates the navigation and the outer `main` tag.
  func renderDocumentContent(navigationHTML      : String,
                             topicTitleHTML      : String,
                             primaryContentHTML  : String,
                             sectionsContentHTML : String,
                             topicSectionsHTML   : String,
                             seeAlsoHTML         : String) -> String
  {
    return templates.documentContent(navigationHTML      : navigationHTML,
                                     topicTitleHTML      : topicTitleHTML,
                                     primaryContentHTML  : primaryContentHTML,
                                     sectionsContentHTML : sectionsContentHTML,
                                     topicSectionsHTML   : topicSectionsHTML,
                                     seeAlsoHTML         : seeAlsoHTML)
  }
}
