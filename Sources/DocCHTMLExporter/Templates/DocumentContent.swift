//
//  DocumentContent.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import mustache

fileprivate let template = Mustache(
  """
  {{{navigationHTML}}}
  <main id="main" role="main" class="main">
    {{{topicTitleHTML}}}
    {{{primaryContentHTML}}}
    {{{sectionsContentHTML}}}
    {{{topicSectionsHTML}}}
    {{{seeAlsoHTML}}}
  </main>
  """
)

func DocumentContent(navigationHTML      : String,
                     topicTitleHTML      : String,
                     primaryContentHTML  : String,
                     sectionsContentHTML : String,
                     topicSectionsHTML   : String,
                     seeAlsoHTML         : String) -> String
{
  template(navigationHTML      : navigationHTML,
           topicTitleHTML      : topicTitleHTML,
           primaryContentHTML  : primaryContentHTML,
           sectionsContentHTML : sectionsContentHTML,
           topicSectionsHTML   : topicSectionsHTML,
           seeAlsoHTML         : seeAlsoHTML)
}
