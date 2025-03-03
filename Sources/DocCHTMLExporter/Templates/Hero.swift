//
//  Hero.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

let HeroTemplate = Mustache(
  """
  <div id="introduction" class="tutorial-hero">
    <div class="hero dark">
      {{#backgroundImage}}
        <div class="bg"
         style="background-image: url(&quot;{{backgroundImage}}&quot;);"></div>
      {{/backgroundImage}}

      <div class="row">
        <div class="col large-7 medium-9 small-12">
          <div class="headline"><span class="eyebrow">{{eyebrow}}</span>
            <h1 class="heading">{{title}}</h1>
          </div>
        </div>
        <div class="intro">
          <div class="content">{{{contentHTML}}}</div>
        </div>
        <div class="metadata">
          <div class="item">
            <div class="content">
              <div class="duration">{{duration}}
                <div class="minutes">min</div>
              </div>
            </div>
            <div class="bottom">Estimated Time</div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
)

extension DZRenderingContext {

  func renderHero(eyebrow         : String,
                  title           : String,
                  duration        : Int,
                  contentHTML     : String,
                  backgroundImage : String = "")
       -> String
  {
    return templates.hero(eyebrow         : eyebrow,
                          title           : title,
                          duration        : duration,
                          contentHTML     : contentHTML,
                          backgroundImage : backgroundImage)
  }
}
