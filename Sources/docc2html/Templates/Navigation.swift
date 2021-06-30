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
// Arguments:
// - title
// - navitems / title|isCurrent
fileprivate let template = Mustache(
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
                  <span class="{{#isCurrent}}current {{/isCurrent}}item">{{title}}</span>
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
  var title     : String
  var isCurrent = true
}

func Navigation(title: String = "Documentation",
                items: [ NavigationItem ])
     -> String
{
  template(title: title, navitems: items)
}
