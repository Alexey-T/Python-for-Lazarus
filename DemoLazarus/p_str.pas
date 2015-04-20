unit p_str;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  TStringDecodeRecW = record
    SFrom, STo: WideString;
  end;

function SBegin(const s, sub: string): boolean;
function SDecodeW(const S: WideString; const Decode: array of TStringDecodeRecW): WideString;
function SWideStringToPythonString(const Str: Widestring): string;


implementation

function SDecodeW(const S: WideString; const Decode: array of TStringDecodeRecW): WideString;
var
  i, j: Integer;
  DoDecode: Boolean;
begin
  Result := '';
  i := 1;
  repeat
    if i > Length(S) then Break;
    DoDecode := False;
    for j := Low(Decode) to High(Decode) do
      with Decode[j] do
        if (SFrom <> '') and (SFrom = Copy(S, i, Length(SFrom))) then
        begin
          DoDecode := True;
          Result := Result + STo;
          Inc(i, Length(SFrom));
          Break
        end;
    if DoDecode then Continue;
    Result := Result + S[i];
    Inc(i);
  until False;
end;

function SWideStringToPythonString(const Str: Widestring): string;
const
  Decode: array[0..0] of TStringDecodeRecW =
    ((SFrom: '"'; STo: '"+''"''+"'));
begin
  Result:= UTF8Encode(SDecodeW(Str, Decode));
  Result:= 'r"'+Result+'"';
end;

function SBegin(const s, sub: string): boolean;
begin
  Result:= Copy(s, 1, Length(sub))=sub;
end;


end.

