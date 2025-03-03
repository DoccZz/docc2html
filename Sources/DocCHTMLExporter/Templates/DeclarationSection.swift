//
//  DeclarationSection.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

// FIXME: This is slightly wrong, we need to loop over the declarations within.
let DeclarationSectionTemplate = Mustache(
  """
  <section id='declaration' class='declaration'>
    <h2>{{title}}</h2>
    <div class='declaration-group'>
      <pre class='source indented'><code>{{{tokensHTML}}}</code></pre>
    </div>
  </section>
  """
)

extension DZRenderingContext {
  
  func renderDeclarationSection(title: String? = nil, tokensHTML: String)
       -> String
  {
    return templates.declarationSection(title: title ?? labels.declaration,
                                        tokensHTML: tokensHTML)
  }
}
