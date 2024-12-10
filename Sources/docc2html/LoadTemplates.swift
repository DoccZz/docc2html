//
//  LoadTemplates.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

import Mustache
import Foundation
import DocCHTMLExporter // @docczz/docc2html

func loadTemplatesAndStylesheet(from path: String)
     -> ( templates: DZRenderingContext.Templates, stylesheet: String )
{
  let baseURL = URL(fileURLWithPath: path)
  let cssURL  = baseURL.appendingPathComponent("site.css")
  
  let stylesheet = (try? String(contentsOf: cssURL))
                ?? DZRenderingContext.defaultStyleSheet
  
  var templates  = DZRenderingContext.Templates()
  
  func load(_ name: String) -> Mustache? {
    let url = baseURL.appendingPathComponent(name)
                     .appendingPathExtension("mustache")
    guard FileManager.default.fileExists(atPath: url.path) else {
      logger.trace("No filesystem template for:", name)
      return nil
    }
    
    do {
      let s = try String(contentsOf: url)
      let m = Mustache(s)
      logger.trace("Did load template:", name, "from:", url.path)
      return m
    }
    catch {
      logger.error("Failed to load template:", name, error)
      return nil
    }
  }
  
  if let m = load("Page")               { templates.htmlWrapper         = m }
  if let m = load("DocumentContent")    { templates.documentContent     = m }
  if let m = load("Navigation")         { templates.navigation          = m }
  if let m = load("PrimaryContent")     { templates.primaryContentGrid  = m }
  if let m = load("CodeListing")        { templates.codeListing         = m }
  if let m = load("StepContent")        { templates.step                = m }
  if let m = load("DeclarationSection") { templates.declarationSection  = m }
  if let m = load("ParametersSection")  { templates.parametersSection   = m }
  if let m = load("Sections")           { templates.contentTableSection = m }
  if let m = load("TopicTitle")         { templates.topicTitle          = m }
  if let m = load("Hero")               { templates.hero                = m }
  if let m = load("Task")               { templates.task                = m }
  if let m = load("TaskIntro")          { templates.taskIntro           = m }
  if let m = load("Volume")             { templates.volume              = m }
  
  return ( templates: templates, stylesheet: stylesheet )
}
