// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name      : "docc2html",
  platforms : [ .macOS(.v10_14), .iOS(.v11) ],
  
  products  : [
    .library   (name: "DocCHTMLExporter"   , targets: [ "DocCHTMLExporter"   ]),
    .library   (name: "DocCStaticExporter" , targets: [ "DocCStaticExporter" ]),
    .executable(name: "docc2html"          , targets: [ "docc2html"          ])
  ],
  
  dependencies: [
    .package(url  : "https://github.com/AlwaysRightInstitute/mustache.git",
             from : "1.0.2"),
    .package(url  : "https://github.com/DoccZz/DocCArchive.git",
             from : "0.4.1"),
    .package(url  : "https://github.com/apple/swift-log.git",
             from : "1.5.4")
  ],
  
  targets: [
    .target(name         : "DocCHTMLExporter",
            dependencies : [ "DocCArchive", "Mustache", "Logging" ]),
    .target(name         : "DocCStaticExporter",
            dependencies : [ "DocCArchive", "DocCHTMLExporter", "Logging" ]),
    .target(name         : "docc2html",
            dependencies : [ "DocCStaticExporter", "Logging" ])
  ]
)
