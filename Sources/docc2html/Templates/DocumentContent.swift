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
  <div id="main" role="main" class="main">
    {{{topicTitleHTML}}}
    {{{primaryContentHTML}}}
    {{{topicSectionsHTML}}}
    {{{seeAlsoHTML}}}
  </div>
  """
)

func DocumentContent(navigationHTML     : String,
                     topicTitleHTML     : String,
                     primaryContentHTML : String,
                     topicSectionsHTML  : String,
                     seeAlsoHTML        : String) -> String
{
  template(navigationHTML     : navigationHTML,
           topicTitleHTML     : topicTitleHTML,
           primaryContentHTML : primaryContentHTML,
           topicSectionsHTML  : topicSectionsHTML,
           seeAlsoHTML        : seeAlsoHTML)
}
