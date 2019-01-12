import strutils, sequtils

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

proc takeCombinator(code: string, cs: openArray[Combinator]): tuple[combinator: string, args: seq[string], suffix: string] =
  let
    pref = code.takePrefixCombinator cs
    matched = cs.filterIt(it.name == pref)
  if matched.len <= 0:
    return

  let co = matched[0]
  var
    code2 = code[pref.len .. code.len-1]
    args: seq[string] = @[]
  for i in 1..co.argsCount:
    let c = code2.takePrefixCombinator cs
    if c == "":
      return (pref, @[], code2[pref.len .. code2.len-1])
    args.add c
    code2 = code2[c.len .. code2.len-1]

  let joined = pref & args.join("")
  return (pref, args, code[0 .. joined.len-1])

proc calc(co: Combinator, args: openArray[string]): string =
  result = co.format
  for i in 0..<co.argsCount:
    let f = "{" & $i & "}"
    result = result.replace(f, args[i])

proc calcCLCode1Time(code: string, cs: openArray[Combinator]): string =
  let
    coTuple = code.takeCombinator cs
    matched = cs.filterIt(it.name == coTuple.combinator)
  if matched.len < 1:
    return
  let co = matched[0]
  result = co.calc coTuple.args

proc calcCLCode*(code: string, cs: openArray[Combinator], n: int = -1): string =
  var m = n
  if m == 0:
    return code
  if not m == -1:
    dec m
  let ret = code.calcCLCode1Time cs
  if code == ret:
    return
  result = ret.calcCLCode cs
