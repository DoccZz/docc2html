//
//  PrimaryContent.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

fileprivate let template = Mustache(
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

/**
 * Arguments:
 * - abstractHTML (document.abstract:               [ InlineContent ])
 * - contentHTML  (document.primaryContentSections: [ Section ])
 */
func PrimaryContent(abstractHTML: String, contentHTML: String) -> String {
  template(abstractHTML: abstractHTML, contentHTML: contentHTML)
}
