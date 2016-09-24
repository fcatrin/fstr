program bit2gfx;
uses crt;
type bf = array [1..30000] of byte;
var buffer,comp:bf;
    size,sizeCom,sizeDes : word;
    fcomp:text;
    nombre :string;
    target:file;
Function readFile(FName: string) : boolean;
var f : file;
begin
  ReadFile:=false;
  Assign(f,FName);
  {$I-}
  Reset(f,1);
  {$I+}
  if IOResult=0 then begin
    size:=FileSize(F);
    if size<=30000 then begin
       BlockRead(f,buffer,size);
       ReadFile:=true;
    end
    else Writeln('File too long... ',size,' bytes');
    close(f);
  end else Writeln('Error attempting to read ',FName);
end;

Procedure WriteFile(FName: string) ;
var f : file;
begin
  Assign(f,FName);
  {$I-}
  Rewrite(f,1);
  {$I+}
  if IOResult=0 then
    BlockWrite(f,comp,sizeCom);
  close(f);
end;

procedure compress;
var lugar,orig,dest,bit:word;
    valor,long,flag:byte;

begin
  orig:=1;
  dest:=4;
  lugar:=3;
  Flag:=0;
  bit:=1;
  repeat
    valor:=buffer[orig];
    long:=0;
    While (valor=buffer[orig+long]) and (orig+long<=size) and (long<255) do inc(long);
    if long<>1 then begin
      flag:=flag+bit;
      bit:=bit*2;
      comp[dest]:=long;
      comp[dest+1]:=valor;
      dest:=dest+2;
      orig:=orig+long;
      if bit=256 then begin
         comp[lugar]:=flag;
         lugar:=dest;
         inc(dest);
         bit:=1;
         flag:=0;
      end;
    end else begin
      inc(orig);
      bit:=bit*2;
      comp[dest]:=valor;
      inc(dest);
      if bit=256 then begin
         comp[lugar]:=flag;
         lugar:=dest;
         inc(dest);
         bit:=1;
         flag:=0;
      end
    end;
  until orig>size;
  flag:=flag+bit;
  comp[dest]:=255;
  comp[dest+1]:=255;
  inc(dest);
  comp[lugar]:=flag;
  SizeCom:=dest;
  comp[1]:=lo(Size);
  comp[2]:=hi(size);
end;

procedure uncompress;
var flag,long,valor,actual : byte;
    orig,dest,bit:word;
begin
  orig:=3;
  dest:=1;
  bit:=1;
  flag:=comp[orig];
  inc(orig);
  repeat
    long:=0;
    if (flag and bit)<>0 then begin
       long:=comp[orig];
       valor:=comp[orig+1];
       if (long and valor)<>255 then begin
           for actual:=0 to long-1 do buffer[dest+actual]:=valor;
           dest:=dest+long-1;
           inc(orig);
       end;
    end else buffer[dest]:=comp[orig];
    inc(orig);
    inc(dest);
    bit:=bit*2;
    if bit=256 then begin
      bit:=1;
      flag:=comp[orig];
      inc(orig);
    end;
  until (valor and long)=255;
  sizedes:=dest-2;
end;

begin
  assign(fcomp,'compac.txt');
  assign(target,'FAC.RES');
  {$I-}
  rewrite(target,1);
  Reset(fcomp);
  {$I+}
  if IOResult=0 then begin
    while not eof(fcomp) do begin
      readln(fcomp,nombre);
      Write('Adding: ',nombre+'.bit');
      gotoxy(24,wherey);
      if readfile(nombre+'.bit') then begin
        compress;
        Write((sizecom/size)*100:3:1,' %  -->  ',nombre,'.gfx');
        Writefile(nombre+'.gfx');
        if readfile(nombre+'.gfx') then begin
          Blockwrite(target,size,2);
          BlockWrite(target,buffer,size);
          gotoxy(52,wherey);
          Writeln('     OK');
        end;
      end;
    end;
  close(fcomp);
  close(target);
  end else writeln('Compac.txt not found');
end.
