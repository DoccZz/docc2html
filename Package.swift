// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name      : "docc2html",
  platforms : [ .macOS(.v10_14), .iOS(.v11) ],
  products  : [ .executable(name: "docc2html", targets: [ "docc2html" ]) ],
  
  dependencies: [
    .package(url: "https://github.com/AlwaysRightInstitute/Mustache.git",
             from: "1.0.1"),
    .package(url: "https://github.com/DoccZz/DocCArchive.git", from: "0.1.0"),
    
    // TODO: remove this dep, not really necessary for this exporter.
    .package(url: "https://github.com/Macro-swift/Macro.git",  from: "0.8.10")
  ],
  
  targets: [
    .target(name         : "docc2html",
            dependencies : [ "DocCArchive",
                             .product(name: "mustache", package: "Mustache"),
                             "Macro" ])
  ]
)
