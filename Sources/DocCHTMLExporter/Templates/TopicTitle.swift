//
//  TopicTitle.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//
//

import Mustache

let TopicTitleTemplate = Mustache(
  """
  <div class="topictitle">
    <span class="eyebrow">{{eyebrow}}</span>
    <h1 class="title">{{title}}</h1>
  </div>
  """
)

extension DZRenderingContext {
  
  func renderTopicTitle(eyebrow: String? = nil, title: String) -> String {
    return templates.topicTitle(title   : title,
                                eyebrow : eyebrow ?? labels.framework)
  }
}
