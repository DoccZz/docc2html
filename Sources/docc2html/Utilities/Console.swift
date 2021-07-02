//
//  Console.swift
//  Macro
//
//  Created by Helge Hess.
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import struct Logging.Logger

public let console = Logger(label: "μ.console")

/**
 * Just a small JavaScript like `console` shim around the Swift Logging API.
 */
public extension Logger {
  
  @available(*, deprecated, message: "please use `console` directly")
  var logger : Logger { return self }
  
  @usableFromInline
  internal func string(for msg: String, _ values: [ Any? ]) -> Logger.Message {
    var message = msg
    for value in values {
      if let value = value {
        message.append(" ")
        if let s = value as? String {
          message.append(s)
        }
        else if let s = value as? CustomStringConvertible {
          message.append(s.description)
        }
        else {
          message.append("\(value)")
        }
      }
      else {
        message.append(" <nil>")
      }
    }
    return Logger.Message(stringLiteral: message)
  }
  
  @inlinable func error(_ msg: @autoclosure () -> String, _ values : Any?...) {
    error(string(for: msg(), values))
  }
  @inlinable func warn (_ msg: @autoclosure () -> String, _ values : Any?...) {
    warning(string(for: msg(), values))
  }
  @inlinable func log  (_ msg: @autoclosure () -> String, _ values : Any?...) {
    notice(string(for: msg(), values))
  }
  @inlinable func info (_ msg: @autoclosure () -> String, _ values : Any?...) {
    info(string(for: msg(), values))
  }
  @inlinable func trace(_ msg: @autoclosure () -> String, _ values : Any?...) {
    trace(string(for: msg(), values))
  }

  func dir(_ obj: Any?) {
    guard let obj = obj else {
      return notice("<nil>")
    }

    struct StringOutputStream: TextOutputStream {
      var value = ""
      mutating func write(_ string: String) { value += string }
    }
    var out = StringOutputStream()
    
    dump(obj, to: &out)
    return notice(Logger.Message(stringLiteral: out.value))
  }
}
