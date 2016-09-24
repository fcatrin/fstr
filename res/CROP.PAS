program crop;
uses crt,mouse,image;

var xx:integer;
    ch:char;
    fname:string;

procedure loadfile;
var scr : pointer;
    f1 : file;
begin
  scr:=ptr($a000,0);
  assign(f1,Paramstr(1));
  reset(f1,1);
  Blockread(f1,scr^,18);
  Blockread(f1,scr^,768);
    For xx:=0 to 255 do Fijargb(xx,mem[$a000:xx*3+2]div 4
                                  ,mem[$a000:xx*3+1]div 4
                                  ,mem[$a000:xx*3]div 4);
  Blockread(f1,scr^,64000);
  close(f1);
end;

procedure GetBloque;
var apx,apy,opx,opy:integer;
    color:byte;
    inipic,ancho,alto:word;
    f:file of byte;
procedure cualcoor(var px,py : integer);

begin
  point(64,40,0);
  repeat
    color:=GetPoint(px,py);
    repeat
      Point(px,py,1);
      point(px,py,color);
    until keypressed;
    ch:=readkey;
    case ch of
         'a' : if py<200 then inc(py);
         'q' : if py>0 then dec(py);
         'A' : if py<180 then py:=py+10;
         'Q' : if py>10 then py:=py-10;
         'p' : if px<320 then inc(px);
         'o' : if px>0 then dec(px);
         'P' : if px<300 then px:=px+10;
         'O' : if px>10 then px:=px-10;
    end;
  until ch=#13;
end;

begin
  apx:=0;
  apy:=0;
    Cualcoor(apx,apy);
    opx:=apx;
    opy:=apy;
    Cualcoor(opx,opy);
  Assign(f,'c:\appl\leng\asm\titlecua.bit');
  rewrite(f);
  For alto:=apy to opy do
     for ancho:=apx to opx do begin
       color:=GetPoint(ancho,alto);
       Write(f,color);
     end;
  close(f);
  ScrOff;
  Writeln(apx,' ',apy,' ',opx-apx+1,' ',opy-apy+1)
end;
procedure out(p1,p2:word);
begin
  port[p1]:=lo(p2);
  port[p1+1]:=hi(p2);
end;



begin
  ScrOn;
  Loadfile;
  GetBloque;
  repeat until keypressed;
end.
