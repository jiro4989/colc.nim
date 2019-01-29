import combinator

proc write*(r: File, w: var File, cs: openArray[Combinator]) =
  try:
    var line: string
    while r.readLine line:
      let ret = line.calcCLCode cs
      w.writeLine ret
  except:
    stderr.write(getCurrentExceptionMsg())
  finally:
    if w != nil:
      w.close()

proc write*(f: string, w: var File, cs: openArray[Combinator], showFlag: bool) =
  var r: File
  try:
    r = f.open FileMode.fmRead
    var line: string
    while r.readLine line:
      var ret = line.calcCLCode cs
      # ファイル名を出力するかどうか
      if showFlag:
        ret = f & ":" & ret
      w.writeLine ret
  except:
    stderr.write(getCurrentExceptionMsg())
  finally:
    if r != nil:
      r.close()