//
//  TopicTitle.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//
//

import Mustache

fileprivate let template = Mustache(
  """
  <div class="topictitle">
    <span class="eyebrow">{{eyebrow}}</span>
    <h1 class="title">{{title}}</h1>
  </div>
  """
)

func TopicTitle(eyebrow: String = "Framework", title: String) -> String {
  template(title: title, eyebrow: eyebrow)
}
