//
//  Page.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import mustache

fileprivate let template = Mustache(
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
      <link rel="stylesheet" href="{{{cssPath}}}documentation-topic.css" />
      <link rel="stylesheet" href="{{{cssPath}}}documentation-topic~topic~tutorials-overview.css" />
  <!-- this hides the abstract: (because it is white on white)
      <link rel="stylesheet" href="{{{cssPath}}}topic.css" />
  -->
  <!-- this hides stuff: maybe the CSS MUST be included per page type
      <link rel="stylesheet" href="{{{cssPath}}}tutorials-overview.css" />
    -->
      <link rel="stylesheet" href="{{{cssPath}}}site.css" />
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
    </body>
  </html>
  """
)

/**
 * Generates the header and the body.
 */
func Page(relativePathToRoot : String = "/",
          title              : String = "Documentation",
          contentHTML        : String,
          footerHTML         : String = "",
          highlightCDN       : String = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.0.1")
     -> String
{
  template(relativePathToRoot: relativePathToRoot, highlightCDN: highlightCDN,
           contentHTML: contentHTML, footerHTML: footerHTML, title: title,
           cssPath: relativePathToRoot + "css/")
}
