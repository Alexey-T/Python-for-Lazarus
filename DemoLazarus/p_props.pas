unit p_props;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  cDefFixedFontName = {$ifdef windows} 'Consolas' {$else} {$ifdef linux} 'Ubuntu Mono' {$else} 'Monaco' {$endif} {$endif};
  cDefFixedFontSize = {$ifdef windows} 9 {$else} 11 {$endif};

  cDefVarFontName = {$ifdef windows} 'Tahoma' {$else} {$ifdef linux} 'Ubuntu' {$else} 'default' {$endif} {$endif};
  cDefVarFontSize = {$ifdef windows} 9 {$else} 10 {$endif};

implementation

end.
