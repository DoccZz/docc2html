//
//  Stylesheet.swift
//  docc2html
//
//  Created by Helge Heß.
//  Copyright © 2021 ZeeZide GmbH. All rights reserved.
//

let stylesheet =
"""
/* custom stylesheet */

/*
  TODO: media classes for responsiveness and light & dark
 */

body {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  background-color:       white;
  color:                  black;
  padding:                0;
  margin:                 0;
  font-synthesis:         none;
  -webkit-font-smoothing: antialiased;
}

code {
  font-family: "Menlo", monospace;
}

h1 {
  font-size:   2.4em;
  font-weight: normal;
}
h2 {
  font-size:   2em;
  font-weight: normal;
}
h3 {
  font-size:   1.5em;
  font-weight: normal;
}
a {
  text-decoration: none;
  color:           #4064F6;
}
a:visited { color: #4064F6; }

/* navigation */

nav {
  position:      sticky;
  top:           0;
  width:         100%;
  z-index:       10;
  background-color: white;
  opacity:       0.95;
  
  color:         #777;
  padding:       1em 3em 1em 3em;
  margin:        0;
  border-bottom: 1px solid #EEE;
}

nav .nav-content {
  display: flex;
  align-items: bottom;
}

nav ul {
  padding: 0;
  margin:  0;
  display: inline;
}
nav .hierarchy li {
  display: inline;
}
nav .hierarchy li *::before {
  content: ">";
  padding: 0 0.5em 0 0.5em;
}


/* page title */

main {
  padding: 2em 0em 1em 0em;
  margin:  0;
}
main .topictitle {
  padding: 0em 3em 0em 3em;
}
main > .container {
  padding: 0em 3em 0em 3em;
}

main .topictitle .eyebrow {
  font-size:     1.4em;
  color:         #777;
}


/* page content */

main .description {
  border-bottom:  1px solid #CCC;
  padding-bottom: 2em;
}

.description .abstract {
  font-size: 1.4em;
}

p > picture > img {
  max-width: 100%;
}

div.content {
  font-size:   1em;
  line-height: 1.5em;
}

div.content > p > a > code {
  display: inline;
}


/* topics */

section {
  padding: 0em 3em 0em 3em;
}

section.alt-light {
  background-color: #F7F7F7;
}

section h2 {
  padding: 1.5em 0 1em 0;
}

.topic .topic-icon-wrapper {
}

/* contenttable */

.contenttable h3 {
  margin: 0;
}
.contenttable .row {
  display:     flex;
  align-items: flex-start;
  border-top:  1px solid #CCC;
  padding:     2em 0 1em 0;
}

.contenttable .large-3 {
  max-width:   25%;
  flex-basis:  25%;
  flex-grow:   0;
  flex-shrink: 0;
}
.contenttable .large-9 {
  max-width:   75%;
  flex-basis:  75%;
  flex-grow:   0;
  flex-shrink: 0;
}

.link-block {
  padding-bottom: 1em;
}

.section-content {
  padding-left: 1em;
}

a code .decorator {
  color: #777;
}

.topic .abstract .content {
  padding: 1em 0 1em 3em;
}

/* declarations */

pre {
  border:        1px solid #CCC;
  border-radius: 4px;
  margin:        0;
  padding:       0;
}
pre {
  margin:  0;
  padding: 0;
}
"""
