//
//  Sections.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import mustache

fileprivate let template = Mustache(
  """
  <section id='{{sectionID}}' class='contenttable alt-light'>
    <div class='container'>
      <h2 class='title'>{{title}}</h2>

      {{#sections}}
        <div class="row contenttable-section">
          <div class="col section-title large-3 medium-3 small-12">
            <h3 class="title">{{title}}</h3>
          </div>
    
          <div class="col section-content large-9 medium-9 small-12">
            {{#items}}
              <div class="link-block topic">
                {{#decoratedTitleHTML}}
                  <a href="{{url}}" class="link{{#isDeprecated}} deprecated{{/isDeprecated}} has-adjacent-elements">
                    <code class="decorated-title">
                      {{{decoratedTitleHTML}}}
                    </code>
                  </a>
                  <div class="abstract">
                    <div class="content">{{{abstractHTML}}}</div>
                  </div>
                {{/decoratedTitleHTML}}
                {{^decoratedTitleHTML}}
                  <a href="{{url}}" class="link has-adjacent-elements">
                    <div class="abstract">
                      <div class="content">{{{abstractHTML}}}</div>
                    </div>
                  </a>
                {{/decoratedTitleHTML}}
              </div>
            {{/items}}
          </div>
        </div>
      {{/sections}}
    </div>
  </section>
  """
)

struct Section {
  
  struct Item {
    let url                : String
    let decoratedTitleHTML : String
    let abstractHTML       : String
    let isDeprecated       : Bool
  }
  
  let title : String
  let items : [ Item ]
}

/**
 * Arguments:
 * - title    : "Topics"
 * - sections : The sections
 */
func BuildSections(title     : String,
                   sectionID : String,
                   sections  : [ Section ])
     -> String
{
  template(title: title, sectionID: sectionID, sections: sections)
}
