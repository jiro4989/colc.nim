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
    import strutils

    let
      args = docopt(doc, version = "v1.0.0")
      files = @(args["<file>"])
      outfile = if not args["--outfile"]: "" else: $args["--outfile"]

    if files.len < 1:
      # stdin
      var line: string
      if outfile != "":
        # 出力先がファイル
        var ofp: File
        try:
          ofp = outfile.open FileMode.fmWrite
          while stdin.readLine line:
            let ret = line.calcCLCode cs
            ofp.writeLine ret
        except:
          stderr.write(getCurrentExceptionMsg())
        finally:
          if ofp != nil:
            ofp.close()
        quit 0

      # 出力先が標準出力
      while stdin.readLine line:
        let ret = line.calcCLCode cs
        echo ret
      quit 0

    # file
    let showFlag = parseBool($args["--show-filename"])
    for f in files:
      var fp: File
      try:
        fp = f.open FileMode.fmRead
        var line: string
        while fp.readLine line:
          var ret = line.calcCLCode cs
          # ファイル名を出力するかどうか
          if showFlag:
            ret = f & ":" & ret
          echo ret
      except:
        stderr.write(getCurrentExceptionMsg())
      finally:
        if fp != nil:
          fp.close()