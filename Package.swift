// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name      : "docc2html",
  platforms : [ .macOS(.v10_14), .iOS(.v11) ],
  products  : [ .executable(name: "docc2html", targets: [ "docc2html" ]) ],
  
  dependencies: [
    .package(url: "https://github.com/AlwaysRightInstitute/mustache.git",
             from: "1.0.1"),
    .package(url: "https://github.com/DoccZz/DocCArchive.git", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-log.git",
             from: "1.4.0")
  ],
  
  targets: [
    .target(name         : "docc2html",
            dependencies : [ "DocCArchive", "mustache", "Logging" ])
  ]
)
