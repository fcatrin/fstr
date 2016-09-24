program VCH2Bit;
uses crt;
type buf = array [0..40000] of byte;
     bufptr = ^buf;
var f1: file;
    orgsize : word;
    buffer  : bufptr;

Procedure InitVars;
begin
  New(buffer);
end;

Procedure Donevars;
begin
  Dispose(buffer);
end;

procedure readData;
begin
  assign(f1,Paramstr(1)+'.vch');
  reset(f1,1);
  orgsize:=FileSize(f1);
  BlockRead(f1,buffer^,orgsize);
  close(f1);
end;

Procedure WriteData;
begin
  assign(f1,Paramstr(1)+'.bit');
  rewrite(f1,1);
  BlockWrite(f1,buffer^[9],orgsize-9);
  close(f1);
end;

procedure Writeinfo;
begin
  Writeln('Alto :',Buffer^[7]);
  Writeln('Ancho :',Buffer^[6]);
  Writeln('Numero de caracteres ',Buffer^[8]);
  Writeln;
end;

begin
  initvars;
  ReadData;
  WriteData;
  WriteInfo;
  donevars;
end.
