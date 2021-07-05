//
//  ExternalLinks.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

let ModuleToExternalURL : [ String : URL ] = [
  "Foundation":
    URL(string: "https://developer.apple.com/documentation/foundation/")!,
  "AppKit":
    URL(string: "https://developer.apple.com/documentation/appkit/")!,
  "UIKit":
    URL(string: "https://developer.apple.com/documentation/uikit/")!
]
