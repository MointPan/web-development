PROGRAM WorkWithQueryString(INPUT, OUTPUT);
USES
  DOS;

FUNCTION GetQueryStringParameter(Key: STRING): STRING;
VAR
  Query, ParameterAndTheRestQuery: STRING;
  ParameterStartPos, QueryLinkerPos: INTEGER;
BEGIN
  Query := GetEnv('QUERY_STRING');
  ParameterStartPos := Pos(Key, Query);
  ParameterAndTheRestQuery := Copy(Query, ParameterStartPos, Length(Query) - ParameterStartPos + 1);
  QueryLinkerPos := Pos('&', ParameterAndTheRestQuery);
  IF ParameterStartPos <> 0
  THEN
    IF QueryLinkerPos <> 0
    THEN
      GetQueryStringParameter := Copy(ParameterAndTheRestQuery, 0, QueryLinkerPos-1) 
    ELSE
      GetQueryStringParameter := Copy(ParameterAndTheRestQuery, Length(Key) + 2, QueryLinkerPos - Length(Key) - 2)
END;

BEGIN {WorkWithQueryString}
  WRITELN('Content-Type: text/plain');
  WRITELN;
  WRITELN('First Name: ', GetQueryStringParameter('first_name'));
  WRITELN('Last Name: ', GetQueryStringParameter('last_name'));
  WRITELN('Age: ', GetQueryStringParameter('age'))
END. {WorkWithQueryString}

