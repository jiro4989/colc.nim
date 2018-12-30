import strutils

type Combinator* = object
  name*: string
  argsCount*: int
  format*: string

proc takeBracketCombinator(code: string): string =
  var cnt: int
  for c in code:
    result.add c
    case c
    of '(':
      inc cnt
    of ')':
      dec cnt
    else:
      discard
    if cnt <= 0:
      break
      
proc takePrefixCombinator*(code: string, cs: openArray[Combinator]): string =
  if code.len <= 0:
    return ""
  if code.startsWith "(":
    return code.takeBracketCombinator
  for c in cs:
    if code.startsWith c.name:
      return c.name
  return code.substr 1

proc calcCLCode(code: string, cs: openArray[Combinator], n: int = -1): string =
  result = ""