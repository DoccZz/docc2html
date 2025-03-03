//
//  Volume.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

let VolumeTemplate = Mustache(
  """
  <div class="learning-path">
    <div class="main-container">
      <div class="secondary-content-container">
        <nav class="tutorials-navigation">
          <ol role="list" class="tutorials-navigation-list">
            <li class="volume">
              <ol role="list" class="tutorials-navigation-list">
                {{#chapters}}
                  <li><a href="#{{chapterID}}" class="tutorials-navigation-link"
                      >{{name}}</a></li>
                {{/chapters}}
              </ol>
            </li>
          </ol>
        </nav>
      </div>
      <div class="primary-content-container">
        <div class="content-sections-container">
          <section class="volume content-section">
            {{#chapters}}
              <section id="{{chapterID}}" class="chapter tile">
                <div class="info">
                  <div class="asset">{{{assetHTML}}}</div>
                  <div class="intro">
                    <h2 class="name">
                      <div class="eyebrow">{{eyebrow}}</div>
                      <span class="name-text">{{name}}</span>
                    </h2>
                    <div class="content">{{{contentHTML}}}</div>
                  </div>
                </div>
                <ol class="topic-list">
                  {{#tutorials}}
                    <li class="topic tutorial">
                      <div class="topic-icon"></div>
                      <a href="{{url}}" class="container">
                        <div class="link">{{title}}</div>
                        {{#estimatedTime}}
                          <div class="time">
                            <span class="time-label">{{estimatedTime}}</span>
                          </div>
                        {{/estimatedTime}}
                      </a>
                    </li>
                  {{/tutorials}}
                </ol>
              </section>
            {{/chapters}}
          </section>
        </div>
      </div>
    </div>
  </div>
  """
)

struct Chapter {
  
  struct Tutorial {
    let url           : String
    let title         : String
    let estimatedTime : String // yes, kept as a string in this case
  }
  
  let chapterID   : String
  let eyebrow     : String // Chapter 1 (labels.volumeChapter index + 1)
  let name        : String
  let contentHTML : String
  let assetHTML   : String
  let tutorials   : [ Tutorial ]
}

extension DZRenderingContext {
  
  // TODO: A volume can have a name/image too.
  func renderVolume(chapters: [ Chapter ]) -> String {
    return templates.volume(chapters: chapters)
  }
}
