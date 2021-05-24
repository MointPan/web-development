UNIT DictUnit; {Модуль организации частотного словаря входного текстового файла}
INTERFACE
CONST
  Letters = ['a' .. 'z', 'A' .. 'Z']; {Буквы слов}
TYPE
  DictPtr = ^Dictionary; 
  Dictionary = RECORD {Частотный словарь}
                 Word: STRING; {Слова}
                 Count: INTEGER; {Сколько раз слово встретилось}
                 LLink, RLink: DictPtr {Указатели для сортировки по алфавиту}
               END;
PROCEDURE MergeDict(VAR FIn: TEXT; VAR FOut: TEXT); {Собирает частотный словарь}
IMPLEMENTATION

FUNCTION LowerLetter(Let: CHAR): CHAR;
VAR
  CapLet, LowLet: CHAR;
  LowCapAlph: TEXT; 
BEGIN {LowerLetter}
  ASSIGN(LowCapAlph, 'RusEnAlphabets.txt');
  RESET(LowCapAlph);
  WHILE NOT EOF(LowCapAlph)
  DO
    BEGIN
      READ(LowCapAlph, CapLet);
      IF (CapLet = Let) AND (NOT EOLN(LowCapAlph))
      THEN
        BEGIN
          READ(LowCapAlph, LowLet);
          WRITELN(LowLet);
          LowerLetter := LowLet
        END
      ELSE
        LowerLetter := Let
    END;
  READLN(LowCapAlph)
END; {LowerLetter}

PROCEDURE ReadWord(VAR FIn: TEXT; VAR Word: STRING); {Считывает слово из "букв" до символа, интерпертируемого пробелами. Пропускает несколько стоящих подряд подобных символов}
VAR
  Ch: CHAR;
  SpaceFound: BOOLEAN;
BEGIN {ReadWord}                          
  SpaceFound := FALSE;
  Word := '';
  WHILE (NOT EOLN(FIn)) AND ((NOT SpaceFound) OR (Word = ''))
  DO
    BEGIN
      READ(FIn, Ch);
      IF Ch IN Letters
      THEN
        Word := Word + LowerLetter(Ch)
      ELSE
        SpaceFound := TRUE
    END
END; {ReadWord}

PROCEDURE Insert(VAR Ptr: DictPtr; WordRec: STRING); {Делает запись слова и количества его употреблений, соблюдая алфавитный порядок}
BEGIN
  IF Ptr = NIL
  THEN
    BEGIN 
      NEW(Ptr);
      Ptr^.Word := WordRec;
      Ptr^.Count := 1;
      Ptr^.LLink := NIL;
      Ptr^.RLink := NIL
    END
  ELSE
    IF Ptr^.Word > WordRec
    THEN
      Insert(Ptr^.LLink, WordRec)
    ELSE
      IF Ptr^.Word < WordRec
      THEN
        Insert(Ptr^.RLink, WordRec)
      ELSE 
        Ptr^.Count := Ptr^.Count + 1
END;  {Insert}

PROCEDURE WriteOutDict(VAR Res: TEXT; Ptr: DictPtr);
BEGIN {WriteOutDict}
  IF Ptr <> NIL
  THEN  
    BEGIN
      WriteOutDict(Res, Ptr^.LLink);
      WRITELN(Res, Ptr^.Word, ' ', Ptr^.Count);
      DISPOSE(Ptr);
      WriteOutDict(Res, Ptr^.RLink)
    END;
END; {WriteOutDict}

PROCEDURE MergeDict(VAR FIn: TEXT; VAR FOut: TEXT);
VAR
  DictRootPtr: DictPtr;
  CurrWord: STRING;
BEGIN {MergeDict}
  DictRootPtr := NIL;
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      WHILE NOT EOLN(FIn)
      DO
        BEGIN
          ReadWord(FIn, CurrWord);
          IF CurrWord <> '' 
          {CurrWord может быть пустым только в случае, если либо файл имеет строку, целиком состоящую из символов, 
          которые интерпретируются как пробелы, либо весь состоит из таких символов}
          THEN
            Insert(DictRootPtr, CurrWord)
        END;
      READLN(FIn)
  END;
  WriteOutDict(FOut, DictRootPtr)
END; {MergeDict}

BEGIN {DictUnit}

END. {DictUnit}
