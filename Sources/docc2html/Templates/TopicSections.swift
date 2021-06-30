//
//  TopicSections.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import mustache

fileprivate let template = Mustache(
  """
  <section id='topics' class='contenttable alt-light'>
    <div class='container'>
      <h2 class='title'>{{title}}</h2>

      {{#sections}}
        <div class="col section-title large-3 medium-3 small-12">
          <h3 class="title">{{title}}</h3>
        </div>
  
        <div class="col section-content large-9 medium-9 small-12">
          {{#items}}
            <div class="link-block topic">
              <a href="{{url}}" class="link has-adjacent-elements">
                <div class="abstract">
                  <div class="content">{{{abstractHTML}}}</div>
                </div>
              </a>
            </div>
          {{/items}}
        </div>
      {{/sections}}
    </div>
  </section>
  
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

struct TopicSection {
  
  struct Item {
    let url          : String
    let abstractHTML : String
  }
  
  let title : String
  let items : [ Item ]
}

/**
 * Arguments:
 * - title    : Defaults to "Topics"
 * - sections : The sections
 */
func TopicSections(title: String = "Topics", sections: [ TopicSection ])
     -> String
{
  template(title: title, sections: sections)
}
