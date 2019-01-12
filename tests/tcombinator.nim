import unittest
include combinator

let cs = [
    Combinator(name:"S", argsCount:3, format:"{0}{2}({1}{2})"),
    Combinator(name:"K", argsCount:2, format:"{0}"),
    Combinator(name:"I", argsCount:1, format:"{0}"),
    ]

suite "takePrefixCombinator":
  test "先頭の文字を返す":
    check("S" == "Sxyz".takePrefixCombinator(cs))
  test "括弧で括られた文字の場合はそれらを返す":
    check("(SKI)" == "(SKI)xyz".takePrefixCombinator(cs))
  test "空文字の場合は空文字を返す":
    check("" == "".takePrefixCombinator(cs))
  test "コンビネータが登録されていないものなら1文字返す":
    check("x" == "xyz".takePrefixCombinator(cs))

suite "takeBracketCombinator":
  test "括弧で括られた文字を返す":
    check("(SKI)" == "(SKI)xyz".takeBracketCombinator)

suite "takeCombinator":
  test "コンビネータと引数と残りを返す":
    check((combinator: "S", args: @["x", "y", "z"], suffix: "") == "Sxyz".takeCombinator(cs))
  test "先頭のコンビネータが渡したコンビネータに存在しなければ、すべて空になる":
    let args: seq[string] = @[]
    check((combinator: "", args: args, suffix: "") == "abcdefg".takeCombinator(cs))
  test "引数不足ならargsは空":
    let args: seq[string] = @[]
    check((combinator: "S", args: args, suffix: "") == "Sxy".takeCombinator(cs))

suite "calcFormat":
  test "置換処理を実行する":
    check("xz(yz)" == cs[0].calcFormat(["x", "y", "z"]))
    check("(abc)(ghi)((def)(ghi))" == cs[0].calcFormat(["(abc)", "(def)", "(ghi)"]))

suite "calcCLCode1Time":
  test "1回だけ計算する":
    check("xz(yz)" == "Sxyz".calcCLCode1Time(cs))
  test "2回目は計算されない":
    check("Kz(Iz)" == "SKIz".calcCLCode1Time(cs))
  test "未定義コンビネータならそのまま返す":
    check("syz" == "syz".calcCLCode1Time(cs))

suite "calcCLCode":
  test "計算する":
    check("xz(yz)" == "Sxyz".calcCLCode(cs))
  test "2回目は計算されない":
    check("z" == "SKIz".calcCLCode(cs))
