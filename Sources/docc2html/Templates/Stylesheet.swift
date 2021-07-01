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
  background-color: white;
  color:            black;
  padding:          0;
  margin:           0;
  font-synthesis:   none;
  -webkit-font-smoothing: antialiased;
  line-spacing:     1em;
}

h1 {
  font-size:     3em;
  font-weight:   normal;
}
h2 {
  font-size:     2.5em;
  font-weight:   normal;
}
a {
  text-decoration: none;
}

/* navigation */

nav {
  position:      sticky;
  top:           0;
  width:         100%;
  z-index:       10;
  background-color: white;
  opacity:       0.95;
  
  font-size:     1.2em;
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
  padding:       2em 3em 1em 3em;
  margin:        0;
}
main .topictitle .eyebrow {
  font-size:     1.5em;
  color:         #777;
}


/* page content */

main .description {
  border-bottom: 1px solid #CCC;
  padding-bottom: 3em;
}

.description .abstract {
  font-size: 1.5em;
}

div.content > p, div.content > p > a, div.content > p > code {
  font-size:    1.3em;
  line-spacing: 1.3em;
}

div.content > p > a > code {
  display: inline;
}
"""
