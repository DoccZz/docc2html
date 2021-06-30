//
//  HTMLEscape.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

extension String {
  
  var htmlEscaped : String {
    return self
      .replacingOccurrences(of: "&",  with: "&amp;")
      .replacingOccurrences(of: "<",  with: "&lt;")
      .replacingOccurrences(of: ">",  with: "&gt;")
      .replacingOccurrences(of: "\"", with: "&quot;")
      .replacingOccurrences(of: "'",  with: "&squot;")
  }
}
