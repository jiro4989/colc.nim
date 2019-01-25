import combinator as comb
import dom

let cs = [
    Combinator(name:"S", argsCount:3, format:"{0}{2}({1}{2})"),
    Combinator(name:"K", argsCount:2, format:"{0}"),
    Combinator(name:"I", argsCount:1, format:"{0}"),
    ]

proc calcCLCode(code: cstring): cstring {.exportc.} =
  return comb.calcCLCode($code, cs, -1)
