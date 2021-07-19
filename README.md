<h2>docc2html
  <img src="http://zeezide.com/img/docz/docc2html100.png"
           align="right" width="100" height="100" />
</h2>

Tool to convert "DocC" archives, a format to document Swift frameworks
and packages:
[Documenting a Swift Framework or Package](https://developer.apple.com/documentation/Xcode/documenting-a-swift-framework-or-package),
to a static HTML site.

Blog entry on the topic: [DocC 📚 Archived and Analyzed](https://www.alwaysrightinstitute.com/docz/).

## Usage

First grab the package:
```bash
$ git clone https://github.com/DoccZz/docc2html.git
$ cd docc2html
```

Then run it on your `.doccarchive`:
```bash
$ swift run docc2html ~/Downloads/SlothCreator.doccarchive /tmp/SlothCreator/docs
```

This will create the static site in /tmp/SlothCreatorSite.
The root documentation can be directly opened in the browser,
e.g.
```bash
open file:/tmp/SlothCreatorSite/documentation/slothcreator/index.html
```


## Status

### 2021-07-10

I think it is somewhat reasonable now. Templates (and Site.css) can be customized
using external files. If willing to ajust the CSS to your own liking, it might be
reasonable to use docc2html for something real.

### 2021-07-06

Well, it's getting closer and the source code starts to be quite
reasonable as well. Though you can still tell it started as a
quick hack.

### 2021-07-03

**It's not ready for production yet, needs some more work.**

This is a very quick hack/PoC full of quirks,
and pretty incomplete. 
But it has working parts and we invite everyone to improve it and provide PRs.
Or ignore it and come up with an own exporter base on the ideas (and
possibly [DocCArchive](https://github.com/DoccZz/DocCArchive)).

The tool is, as of today, just tested against the
[SlothCreator](https://developer.apple.com/documentation/xcode/slothcreator_building_docc_documentation_in_xcode)
example.

It does not export tutorials yet, only the documents in the
documentation folder.

It's not much yet, but a pretty good starting point.


## TODO

- [ ] better API doc templates
- [ ] improve tutorial templates
- [ ] better CSS
- [x] refactor code into a proper type and module for easier reuse
- [x] drop dependency on Macro
- [x] support Mustache templates in the filesystem! (for customization & faster testing)
- [x] generate proper index.html

### Using it on GitHub

We didn't try yet 🥸 But hope to be able to move the
[SwiftBlocksUI Documentation](https://github.com/SwiftBlocksUI/SwiftBlocksUI/tree/develop/Documentation)
to that. 
Going to take some time until it's possible.

The GH action would need to:
- patch the `Package.swift` version to 5.5
- run the `xcodebuild -doc` thing to produce the DocC archives
- use `docc2html` on each of the archives
- publish the result to GH Pages


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
