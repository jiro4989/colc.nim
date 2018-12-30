import dom
import combinator

let
    inputCLCode = document.getElementById("inputCLCode")
    executeCalcButton = document.getElementById("executeCalcButton")
    resultArea = document.getElementById("resultArea").TextAreaElement

let cs = [
    Combinator(name:"S", argsCount:3, format:"{0}{2}({1}{2})"),
    Combinator(name:"K", argsCount:2, format:"{0}"),
    Combinator(name:"I", argsCount:1, format:"{0}"),
    ]

proc getTextValue(id: cstring): cstring {.importc.}

proc calc(e: Event) =
    let clcode = $"inputCLCode".getTextValue
    let calcResult = clcode.takePrefixCombinator(cs)
    resultArea.value = calcResult

executeCalcButton.onclick = calc