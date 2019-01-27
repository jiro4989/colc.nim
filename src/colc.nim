import combinator as comb
import sequtils

let cs = [
    Combinator(name:"S", argsCount:3, format:"{0}{2}({1}{2})"),
    Combinator(name:"K", argsCount:2, format:"{0}"),
    Combinator(name:"I", argsCount:1, format:"{0}"),
    ]

when defined(js):
  proc calcCLCode(code: cstring): cstring {.exportc.} =
    return comb.calcCLCode($code, cs, -1)

  proc calcCLCodeAndResults(code: cstring, n: cint): seq[cstring] {.exportc.} =
    return comb.calcCLCodeAndResults($code, cs, n = n).mapIt(cstring(it))
else:
  echo "linux"