//
//  DeclarationSection.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import mustache

// FIXME: This is slightly wrong, we need to loop over the declarations within.
fileprivate let template = Mustache(
  """
  <section id='declaration' class='declaration'>
    <h2>{{title}}</h2>
    <div class='declaration-group'>
      <pre class='source indented'><code>{{{tokensHTML}}}</code></pre>
    </div>
  </section>
  """
)

func DeclarationSection(title: String = "Declaration", tokensHTML: String)
     -> String
{
  template(title: title, tokensHTML: tokensHTML)
}
