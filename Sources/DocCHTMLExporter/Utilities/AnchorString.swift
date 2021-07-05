//
//  AnchorString.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation

extension String {
  
  /// Replace all non-alphanumerics into dashes.
  /// E.g. "Hello World" into "Hello-World"
  var htmlAnchorize : String {
    String(map { char in
      switch char {
        case "a"..."z", "A"..."Z", "0"..."9", "_" : return char
        default                                   : return "-"
      }
    })
  }
}
