# Package

packageName = "colc"
version     = "1.0.0"
author      = "jiro4989"
description = "Combinatory Logic Calc"
license     = "MIT"
srcDir      = "src"
binDir      = "bin"
bin         = @[packageName]
skipDirs    = @["tests", "util"]

# Dependencies

requires "nim >= 0.19.0"
requires "docopt >= 0.6.7"

import strformat

let
  binbin = &"{binDir}/{packageName}"
  distDir = "dist"

task buildjs, "JSをビルドする":
  exec &"nimble js -o:static/js/{packageName}.js src/{packageName}.nim"

task run, "バイナリをビルドする":
  exec "nimble build"
  exec binbin

task archive, "配布用に圧縮する":
  exec "nimble build"
  let
    pack = &"{packageName}_v{version}"
    archiveDir = &"{distDir}/{pack}"
  rmdir distDir
  mkdir distDir
  mkdir archiveDir
  cpFile binbin, &"{archiveDir}/{packageName}"
  cpFile "README.md", &"{archiveDir}/README.md"
  withDir distDir:
    exec &"tar czf {pack}.tar.gz {pack}"

task release, "GitHubにリリースする":
  exec "nimble test"
  exec "nimble buildjs"
  exec "hub checkout gh-pages"
  exec "hub merge master"
  exec "hub push"
  exec "hub checkout master"
  #exec "nimble test"
  #exec "nimble archive"
  #exec &"ghr v{version} {distDir}/"
