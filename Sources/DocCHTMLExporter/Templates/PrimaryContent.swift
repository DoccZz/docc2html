//
//  PrimaryContent.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

let PrimaryContentGridTemplate = Mustache(
  """
  <div class="container content-grid">
    <div class="description">
      <div class="abstract content">
        {{{abstractHTML}}}
      </div>
    </div>
    
    <!-- The sidebar once we have one: <div class="summary"></div> -->
    
    <div class="primary-content">
      {{{contentHTML}}}
    </div>
  </div>
  """
)

extension DZRenderingContext {
  
  func renderPrimaryContentGrid(abstractHTML: String, contentHTML: String)
       -> String
  {
    return templates.primaryContentGrid(abstractHTML: abstractHTML,
                                        contentHTML: contentHTML)
  }
}
