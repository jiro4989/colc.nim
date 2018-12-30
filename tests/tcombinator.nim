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

suite "takeBracketCombinator":
    test "括弧で括られた文字を返す":
        check("(SKI)" == "(SKI)xyz".takeBracketCombinator)