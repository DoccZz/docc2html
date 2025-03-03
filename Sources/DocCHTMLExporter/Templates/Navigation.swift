//
//  Navigation.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

// TBD:
// nav: interfacelanguage, swiftpath, aria-label, svg for triangle
let NavigationTemplate = Mustache(
  """
  <nav role="navigation" class="nav documentation-nav">
    <div class="nav__wrapper">
      <div class="nav__background"></div>
      <div class="nav-content">
        <div class="nav-title">
          <span class="nav-title-link inactive">{{title}}</span>
        </div>
        <div class="nav-menu">
          <div class="nav-menu-tray">
            <ul class="nav-menu-items hierarchy">
              {{#navitems}}
                <li class="nav-menu-item hierarchy-item">
                  {{#isCurrent}}
                    <span class="current item">{{title}}</span>
                  {{/isCurrent}}
                  {{^isCurrent}}
                    <a href="{{link}}" class="item">{{title}}</a>
                  {{/isCurrent}}
                </li>
              {{/navitems}}
            </ul>
          </div>
        </div>
      </div>
    </div>
  </nav>
  """
)

struct NavigationItem {
  let title     : String
  let isCurrent : Bool
  let link      : String
}

extension DZRenderingContext {

  func renderNavigation(title: String? = nil, items: [ NavigationItem ])
       -> String
  {
    return templates
             .navigation(title: title ?? labels.documentation, navitems: items)
  }
}
