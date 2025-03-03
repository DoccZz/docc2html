//
//  Page.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache

#if false // attempt to reuse the stylesheets, but doesn't really fly
  fileprivate let stylesheets = [
    "documentation-topic.css",
    "documentation-topic~topic~tutorials-overview.css",

    // this hides the abstract: (because it is white on white)
    // "topic.css",
    // this hides stuff: maybe the CSS must be included per page type
    // "tutorials-overview.css",
    
    "site.css"
  ]
#else
  fileprivate let stylesheets = [ "site.css" ]
#endif

let PageTemplate = Mustache(
  """
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover" />
      
      <title>{{title}}</title>
      
      <link rel="icon"       href="{{{relativePathToRoot}}}favicon.ico" />
      <link rel="mask-icon"  href="{{{relativePathToRoot}}}favicon.svg" color="#333333" />
      \(stylesheets.map {
        "<link rel='stylesheet' href='{{{cssPath}}}\($0)' />"
      }.joined(separator: "\n"))
      <link rel="stylesheet" href="{{{highlightCDN}}}/styles/default.min.css" />
      <script src="{{{highlightCDN}}}/highlight.min.js"></script>
    </head>
    <body>
      <div id="app">
        <div class="doc-topic">
          {{{contentHTML}}}
        </div>
      </div>
      <footer class="footer">{{{footerHTML}}}</footer>
      <script>hljs.highlightAll();</script>
    </body>
  </html>
  """
)

extension DZRenderingContext {
  /**
   * Generates the header and the body.
   */
  func renderHTML(relativePathToRoot : String = "/",
                  title              : String? = nil,
                  contentHTML        : String,
                  footerHTML         : String = "")
       -> String
  {
    return templates.htmlWrapper(relativePathToRoot: relativePathToRoot,
                                 highlightCDN : highlightCDN,
                                 contentHTML  : contentHTML,
                                 footerHTML   : footerHTML,
                                 title        : title ?? labels.documentation,
                                 cssPath      : relativePathToRoot + "css/")
  }
}
