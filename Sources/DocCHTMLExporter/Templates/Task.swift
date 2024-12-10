//
//  Task.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

// Parameters: anchor, introHTML, stepsHTML
// intro is the display: flex
let TaskTemplate = Mustache(
  """
  <div id="{{anchor}}" class="section">
    {{{introHTML}}}
    <div class="steps">{{{stepsHTML}}}</div>
  </div>
  """
)

// This is special because it combines the task content w/ the task itself
// in a different stacking.
// Parameters: anchor, task (index), sectionTitle, title, contentHTML, assetHTML
let TaskIntroTemplate = Mustache(
  """
  <div class="intro-container">
    <div class="row intro intro-{{task}}">
      <div class="col left large-6 small-12">
        <div class="headline">
          <span class="eyebrow"><a href="#{{anchor}}">{{sectionTitle}}</a></span>
          <h2 class="heading">{{title}}</h2>
        </div>
        {{#contentHTML}}
          <div class="content">{{{contentHTML}}}</div>
        {{/contentHTML}}
      </div>
      <div class="col right large-6 small-12">
        <div class="media"><div class="asset">{{{assetHTML}}}</div></div>
      </div>
  </div>
  """
)

extension DZRenderingContext {

  func renderTaskIntro(anchor: String, task: Int, title: String,
                       contentHTML: String, assetHTML: String)
       -> String
  {
    return templates.taskIntro(anchor: anchor, task: task, title: title,
                               sectionTitle: labels.taskSection + " \(task)",
                               contentHTML: contentHTML)
  }
  
  func renderTask(anchor: String, introHTML: String, stepsHTML: String)
       -> String
  {
    return templates.task(anchor: anchor,
                          introHTML: introHTML, stepsHTML: stepsHTML)
  }
}
