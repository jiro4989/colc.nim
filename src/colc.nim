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
  -o --out-file=<outfile>   out file
  <file>                    target file

help options:
  -h --help                 show this screen
  -v --version              show version
  """

    import docopt 

    let
      args = docopt(doc, version = "v1.0.0")
      files = @(args["<file>"])
    if files.len < 1:
      # stdin
      var line: string
      while stdin.readLine line:
        let ret = line.calcCLCode cs
        echo ret
    else:
      # file
      for f in files:
        var fp: File
        try:
          fp = f.open FileMode.fmRead
          var line: string
          while fp.readLine line:
            let ret = line.calcCLCode cs
            echo ret
        except:
          stderr.write(getCurrentExceptionMsg())
        finally:
          if fp != nil:
            fp.close()