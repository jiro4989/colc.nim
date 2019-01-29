import combinator as comb
import sequtils

let cs = [
    Combinator(name:"S", argsCount:3, format:"{0}{2}({1}{2})"),
    Combinator(name:"K", argsCount:2, format:"{0}"),
    Combinator(name:"I", argsCount:1, format:"{0}"),
    ]

when isMainModule:
  when defined(js):
    proc calcCLCode(code: cstring): cstring {.exportc.} =
      return comb.calcCLCode($code, cs, -1)

    proc calcCLCodeAndResults(code: cstring, n: cint): seq[cstring] {.exportc.} =
      return comb.calcCLCodeAndResults($code, cs, n = n).mapIt(cstring(it))
  else:
    const doc = """
colc can calculate SKI Combinator.

usage:
  colc [options] <file>...
  colc [options]

options:
  -n --show-filename        show filename
  -o --outfile=<outfile>    out file
  <file>                    target file

help options:
  -h --help                 show this screen
  -v --version              show version
  """

    import docopt
    import logic
    import strutils

    let
      args = docopt(doc, version = "v1.0.0")
      files = @(args["<file>"])
      outfile = if not args["--outfile"]: "" else: $args["--outfile"]

    # 出力先指定
    var w: File =
      if outfile != "":
        outfile.open FileMode.fmWrite
      else:
        stdout

    try:
      # 標準入力を処理
      if files.len < 1:
        var r = stdin
        logic.write(r, w, cs)
        quit 0

      # ファイル入力を処理
      let showFlag = parseBool($args["--show-filename"])
      for f in files:
        logic.write(f, w, cs, showFlag)
    except:
      stderr.write(getCurrentExceptionMsg())
    finally:
      if w != nil:
        w.close()
