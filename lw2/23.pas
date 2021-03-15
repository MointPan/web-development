PROGRAM HelloDear(INPUT, OUTPUT);
USES DOS;
VAR
  UserName: STRING;
BEGIN
  WRITELN('Content-Type: text/plain');
  WRITELN;
  UserName := GetEnv('QUERY_STRING');
  IF Pos('name', UserName) <> 0
  THEN
    WRITELN('Hello dear,', Copy(UserName, Pos('=', UserName)+1, Length(UserName)-Pos('=', UserName)+1))
  ELSE
    WRITELN('Hello Anonymus')
End.
