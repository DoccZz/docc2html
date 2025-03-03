//
//  ParametersSection.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

let ParametersSectionTemplate = Mustache(
  """
  <section id="parameters" class="parameters">
    <h2>{{title}}</h2>
    <dl>
      {{#parameters}}
        <dt class="param-name"><code>{{name}}</code></dt>
        <dd class="param-content">
          <div class="content">{{{contentHTML}}}</div>
        </dd>
      {{/parameters}}
    </dl>
  </section>
  """
)

struct Parameter {
  let name        : String
  let contentHTML : String
}

extension DZRenderingContext {
  
  func renderParametersSection(title: String? = nil, parameters: [ Parameter ])
       -> String
  {
    return templates.parametersSection(title: title ?? labels.parameters,
                                       parameters: parameters)
  }
}
