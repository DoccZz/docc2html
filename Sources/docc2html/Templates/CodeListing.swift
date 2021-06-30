//
//  CodeListing.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

fileprivate let template = Mustache(
  """
  <div data-syntax="{{syntax}}" class="code-listing">
    <div class="container-general">
      <pre><code>{{#lines}}<span class="code-line-container"><span data-line-number="{{{line}}}" class="code-number" style="display: none;"></span><span class="code-line">{{code}}</span></span>{{/lines}}</code></pre>
    </div>
  </span>
  """
)

func CodeListingContent(syntax: String = "Swift", lines: [ String ])
     -> String
{
  struct Line {
    let line : Int
    let code : String
  }
  return template(
    syntax: syntax,
    lines: lines.enumerated().map { idx, code in
      Line(line: idx + 1, code: code)
    }
  )
}
