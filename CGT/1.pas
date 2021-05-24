PROGRAM CountWords(INPUT, OUTPUT);
USES DictUnit;
VAR
  Dict: Dictionary;
  InText, Result: TEXT;
BEGIN {CountWords}
  ASSIGN(InText, 'Example.txt');
  ASSIGN(Result, 'Result.txt');
  RESET(InText);
  REWRITE(Result);
  MergeDict(InText, Result)
END. {CountWords}
