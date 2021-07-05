//
//  BuildNavigation.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Foundation
import DocCArchive

extension DocCArchive.Document {
  
  func buildNavigationPath(in   folder  : DocCArchive.DocumentFolder,
                           with context : DZRenderingContext)
       -> [ NavigationItem ]
  {
    let navPath = hierarchy.paths.first.flatMap {
                    buildNavigationPath(for: $0, in: context)
                  }
               ?? folder.buildIndexBasedNavigationForParents()
    
    return navPath + [ currentNavigationItem ]
  }
}

fileprivate extension DocCArchive.Document {
  
  func buildNavigationPath(for referencePath : [ String ],
                           in        context : DZRenderingContext)
       -> [ NavigationItem ]?
  {
    guard !referencePath.isEmpty else { return [] }
    
    // "url": "/documentation/slothcreator/namegenerator"
    var items = [ NavigationItem ]()
    items.reserveCapacity(referencePath.count)
    
    for ( idx, id ) in referencePath.reversed().enumerated() {
      // TBD: what do to about:
      //   "doc://SlothCreator/tutorials/SlothCreator/$volume"?
      if id.hasSuffix("$volume") {
        context.logger.log("not processing $volume in navpath")
        continue
      }
      
      guard let ref = context[reference: id] else {
        assert(context[reference: id] != nil, "missing hierarchy ref!")
        return nil
      }
      
      guard case .topic(let tr) = ref else {
        assertionFailure("Unexpected ref type in navigation!")
        return nil
      }

      let idURL = ref.identifierURL
      assert(idURL != nil)

      let hierarchy = String(repeating: "../", count: idx + 1)
      let relURL    = hierarchy
                    + (idURL?.appendingPathExtension("html").lastPathComponent
                    ?? "index.html")
      items.insert(
        NavigationItem(title: tr.title, isCurrent: false, link: relURL),
        at: 0
      )
    }
    
    return items
  }

  var currentNavigationItem: NavigationItem {
    NavigationItem(title: metadata.title, isCurrent: true, link: ".")
  }
}

fileprivate extension DocCArchive.DocumentFolder {
  
  func buildIndexBasedNavigationForParents() -> [ NavigationItem ] {
    return Array(
      path.dropFirst().reversed().enumerated().map {
        idx, title in
        // FIXME: Here we somehow need to figure out the real title, is this
        //        NOT in the JSON? Feels weird.
        NavigationItem(title: title, isCurrent: false,
                       link: String(repeating: "../", count: idx + 1)
                        .appending("index.html"))
      }.reversed()
    )
  }
}
