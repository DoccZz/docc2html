//
//  Step.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

// TODO: do something w/ the media stuff
// the app itself does a lot of extra div's for the modal overlay presentation
// (not sure why they call those 'modal', there seems nothing modal about them)
let StepTemplate = Mustache(
  """
  <div class="step-container step-{{step}}">
    <div data-index="{{stepIndex}}" class="step">
      <p class="step-label">Step {{step}}</p>
      <div class="content">{{{contentHTML}}}</div>
      <div class="caption content">{{{captionHTML}}}</div>
    </div>

    {{#hasCode}}
      <div data-syntax="{{syntax}}" class="code-listing">
        <div class="container-general">
          <pre><code>{{#lines}}<span class="code-line-container"><span data-line-number="{{{line}}}" class="code-number" style="display: none;"></span><span class="code-line">{{code}}</span></span>
      {{/lines}}</code></pre>
        </div>
      </div>
    {{/hasCode}}
  </div>
  """
)

extension DZRenderingContext {
  
  func renderStep(_ step      : Int,
                  contentHTML : String,
                  captionHTML : String,
                  syntax      : String = "Swift", lines: [ String ]) -> String
  {
    struct Line {
      let line : Int
      let code : String
    }
    return templates.step(
      step        : step,
      stepIndex   : step - 1,
      contentHTML : contentHTML,
      captionHTML : captionHTML,
      syntax      : syntax,
      hasCode     : !lines.isEmpty,
      lines       : lines.enumerated().map { idx, code in
        Line(line: idx + 1, code: code)
      }
    )
  }
}
