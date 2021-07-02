<h2>docc2html
  <img src="http://zeezide.com/img/macro/MacroExpressIcon128.png"
           align="right" width="100" height="100" />
</h2>

Tool to convert "DocC" archives, a format to document Swift frameworks
and packages:
[Documenting a Swift Framework or Package](https://developer.apple.com/documentation/Xcode/documenting-a-swift-framework-or-package),
to a static HTML site.


## Usage

Example:
```bash
$ swift run docc2html ~/Downloads/SlothCreator.doccarchive /tmp/SlothCreator/docs
```


## TODO

- [ ] better templates
- [ ] refactor code into a proper type and module for easier reuse
- [ ] drop dependency on Macro
- [ ] support Mustache templates in the filesystem! (for customization & faster testing)


### Who

**docc2html** is brought to you by
the
[Always Right Institute](http://www.alwaysrightinstitute.com)
and
[ZeeZide](http://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.
