 dosseg
 .model small
 .286

public StartPlaying, SetFilename, StopPlaying, SetBlock, Allocate, Deallocate
public GetPeakDir, SetChannelOff, SetChannelOn, SetDrumsOff,SetDrumsOn
public HChannels,SetAudioOff,GetPSName,GetPSComp,SongCh,SetList,SetPathDir
public xxstate,setxx,backxx,advxx
public permission21,permission25,permission13
public NumOfTags,NumOrder,playing
.code

datos dw @code
notes dw 0159h,016dh,0183h,019ah,01b2h,01cch,01e8h,0205h,0223h,0244h,0267h,028bh
registros  db 020h,023h,040h,043h,060h,063h,080h,083h,0a0h,0b0h,0c0h
           db 021h,024h,041h,044h,061h,064h,081h,084h,0a1h,0b1h,0c1h
           db 022h,025h,042h,045h,062h,065h,082h,085h,0a2h,0b2h,0c2h
           db 028h,02bh,048h,04bh,068h,06bh,088h,08bh,0a3h,0b3h,0c3h
           db 029h,02ch,049h,04ch,069h,06ch,089h,08ch,0a4h,0b4h,0c4h
           db 02ah,02dh,04ah,04dh,06ah,06dh,08ah,08dh,0a5h,0b5h,0c5h
           db 030h,033h,050h,053h,070h,073h,090h,093h,0a6h,0b6h,0c6h
           db 031h,034h,051h,054h,071h,074h,091h,094h,0a7h,0b7h,0c7h
           db 032h,035h,052h,055h,072h,075h,092h,095h,0a8h,0b8h,0c8h
snadef     db 4h,0fh,3fh,02h,0f1h,0f7h,0ffh,0f7h,59h,1,92h
snadef2    db 4,0fh,3fh,2,0f1h,0f7h,0ffh,0f7h,20h,2h,92h
bassdef    db 1,1,0,0,0cfh,0cfh,068h,7,0abh,9,92h
hihatdef   db 1,9,30h,0ah,0f7h,0f6h,077h,077h,0ffh,11,92h
hiopdef    db 0,15,12h,30h,0f1h,0f6h,024h,0f8h,58h,18,92h
crashdef   db 0,15,0,30h,0f6h,0f6h,24h,0f8h,58h,13h,92h
tom1def    db 1,3,0,0,0f6h,0f2h,027h,028h,058h,14,92h
tom2def    db 1,3,2,0,0f6h,0f2h,025h,028h,058h,11,92h
drumjmp1   dw offset nada
           dw offset case1
           dw offset case11
           dw offset case3
           dw offset case4
           dw offset case5
           dw offset nada
           dw offset case7
           dw offset nada
           dw offset case9
           dw offset nada
           dw offset case11
           dw offset case11
           dw offset nada
           dw offset nada
           dw offset nada
drumjmp2   dw offset nada
           dw offset case5
           dw offset nada
           dw offset nada
           dw offset nada
           dw offset nada
           dw offset nada
           dw offset case27
           dw offset nada
           dw offset nada
           dw offset nada
           dw offset case11
           dw offset case11
           dw offset nada
           dw offset nada
           dw offset nada

SongChanged db 0
NumOrder   dw 0
NumOfsong  dw 0
NumOfFiles dw 0
MyTagList  db 512 dup (0)
numoftags  dw 0
SongDir    db 70 dup (0)
SongListSeg dw 0
llamar     db 0
permission21 dw 0
permission25 dw 0
permission13 dw 0

lastdrum   db 0
oldint     dw 0,0
FileError  db      'Error handling the file.',0ah,0dh,'$'
fileseg    dw 0
Loaded     db 0
canales    db 6
Audioflg   db 0
drumsys    dw 0
Chanof     db 9 dup (0)
drumof     db 3 dup (0)
Drumsoff   db 0
Playing    dw 0
peaklevel  db 9 dup (0)
speedbar   db 3
lastbar    db 0
YetinMem   db 0
xx         dw 0
EndMusic   db 0
SntMusic   db 0
Newlist    db 0
speed      db 1
lastinc    db 0
lastline   dw 1
musname    db 64+9 dup (0)
SongName   db 40 dup (0)
Composer   db 40 dup (0)
bufdisk    db 512 dup (0)
include    memcode.asm
;-----------------------------------------------------------------------------
; al = registro, ah=dato
;-----------------------------------------------------------------------------
outfm:
        push  dx ax
        mov   dx,388h
        out   dx,al
        rept  6
          in   al,dx
        endm
        inc   dl
        mov   al,ah
        out   dx,al
        dec   dl
        rept  35
          in  al,dx
        endm
        pop   ax dx
        ret
;-----------------------------------------------------------------------------
; procedure manda
; si: registros, di :datos
;-----------------------------------------------------------------------------
manda:
        mov  cx,11
repout: lodsb
        mov  ah,[di]
        inc  di
        cmp  ah,92h
        je   nout
        call outfm
nout:   loop repout
        ret

;-----------------------------------------------------------------------------
; procedure snare;
;-----------------------------------------------------------------------------
snare:
        mov  si,offset registros
        add  si,77
        mov  di,offset snadef
        jmp  manda

;-----------------------------------------------------------------------------
; procedure snare2;
;-----------------------------------------------------------------------------
snare2:
        mov  si,offset registros
        add  si,77
        mov  di,offset snadef2
        jmp  manda

;-----------------------------------------------------------------------------
;procedure bassdrum
;-----------------------------------------------------------------------------
bassdrum:
        mov  si,offset registros
        add  si,66
        mov  di,offset bassdef
        jmp  manda
;-----------------------------------------------------------------------------
;Procedure hihat
;-----------------------------------------------------------------------------
hihat:
        mov  si,offset registros
        add  si,88
        mov  di,offset hihatdef
        jmp  manda

;-----------------------------------------------------------------------------
;Procedure hihatop
;-----------------------------------------------------------------------------
hihatop:
        mov  si,offset registros
        add  si,77
        mov  di,offset hiopdef
        jmp  manda
;-----------------------------------------------------------------------------
;procedure crash
;-----------------------------------------------------------------------------
crash:
        mov  si,offset registros
        add  si,77
        mov  di,offset crashdef
        mov  ax,03f32h
        call outfm
        mov  ax,03f35h
        call outfm
        jmp  manda
;-----------------------------------------------------------------------------
;procedure tom1
;-----------------------------------------------------------------------------
tom1:
        mov  si,offset registros
        add  si,88
        mov  di,offset tom1def
        jmp  manda
;-----------------------------------------------------------------------------
;procedure tom2
;-----------------------------------------------------------------------------
tom2:
        mov  si,offset registros
        add  si,88
        mov  di,offset tom2def
        jmp  manda
;-----------------------------------------------------------------------------
;procedure drums
;al =drumdata
;-----------------------------------------------------------------------------
drums:  cmp  drumsoff,1
        jne  yesdrum
        ret
yesdrum: cmp  drumsys,offset drumjmp2
        jne  sistema1
        shr  al,4
sistema1: and  ax,15
        shl  ax,1
        mov  ds,datos
        mov  si,drumsys
        add  si,ax
        lodsw
        mov  si,ax
        call si
        mov  bp,6

        test bl,16
        je   nob4
        cmp  drumof,1
        jne  nob4of
        and  bl,255-16
        jmp  short nob4
nob4of: mov  byte ptr [offset Peaklevel]+bp,12
nob4:   test bl,10
        je   nob9
        cmp  drumOf+1,1
        jne  nob9of
        and  bl,255-10
        jmp  short nob9
nob9of: mov  byte ptr [offset Peaklevel+1]+bp,12
nob9:   test bl,5
        je   nob6
        cmp  drumOf+2,1
        jne  nob6of
        and  bl,255-5
        jmp  short nob6
nob6of:  mov  byte ptr [offset Peaklevel+2]+bp,12
Nob6:   mov  ah,lastdrum
        xor  bl,31
        and  ah,bl
        or   ah,020h
        mov  al,0bdh
        call outfm
        xor  bl,31
        mov  lastdrum,bl
        or   ah,bl
        or   ah,020h
        call outfm
        ret

case1:  call bassdrum
        mov  bl,16
        ret
case3:  call bassdrum
        call hihatop
        mov  bl,16+1
        ret
case4:  call tom2
        mov  bl,4
        ret
case5:  call bassdrum
        call crash
        mov  bl,16+1
        ret
case7:  call snare2
        mov  bl,8
        ret
case9:  call tom1
        mov  bl,4
        ret
case11: call snare
        mov  bl,8;
        ret

case27: call hihat
        mov  bl,2
        ret

nada:   mov bl,0
        ret
;-----------------------------------------------------------------------------
;procedure noteon
;al=nota, cl=canal
;-----------------------------------------------------------------------------
NoteOn: push  ds
        mov   ds,datos
        xor   ch,ch
        mov   bp,cx
        cmp   [chanof+bp],1
        je    NoNoteOn
        mov   [peaklevel+bp],12
        dec   al
        xor   ah,ah
        mov   bl,12
        div   bl
        push  ax
        mov   al,ah
        xor   ah,ah
        shl   ax,1
        mov   si,ax
        add   si,offset notes
        lodsw
        mov   bx,ax
        mov   ah,al
        mov   al,cl
        add   al,0a0h
        call  outfm
        pop   ax
        xor   ah,ah
        add   ax,2
        shl   ax,2
        or    al,bh
        mov   ah,cl
        add   ah,0b0h
        xchg  ah,al
        or    ah,020h
        call  outfm
NoNoteon: pop   ds
        ret
;-----------------------------------------------------------------------------
; procedure initsound
;-----------------------------------------------------------------------------
initsound:
        mov   ax,2001h
        call  outfm
        mov   ax,08h
        call  outfm
        mov   ax,20
fase1:  call  outfm
        inc   al
        cmp   al,40h
        jne   fase1
        mov   ah,3fh
fase2:  call  outfm
        inc   al
        cmp   al,056h
        jne   fase2
fase3:  mov   ah,0
        call  outfm
        inc   al
        cmp   al,60h
        jne   fase3
        mov   ah,0ffh
fase4:  call  outfm
        inc   al
        cmp   al,076h
        jne   fase4
        mov   ah,0
fase5:  call  outfm
        inc   al
        cmp   al,80h
        jne   fase5
        mov   ah,0ffh
fase6:  call  outfm
        inc   al
        cmp   al,096h
        jne   fase6
        mov   ah,0
fase7:  call  outfm
        inc   al
        cmp   al,0f6h
        jne   fase7
        ret

        mov   cx,9
        push  ds
        push  cs
        pop   es
        mov   di,offset Chanof
        xor   al,al
        rep   stosb
        mov   Drumsoff,0
        pop   ds
        ret

;-----------------------------------------------------------------------------
;procedure noteoff
;cl=canal
;-----------------------------------------------------------------------------
NoteOff:
        xor  ch,ch
        mov  bp,cx
        cmp  [chanof+bp],1
        jne  siapaga
        ret
siapaga: add  cl,0b0h
        mov  al,cl
        mov  ah,0
        jmp  outfm


;-----------------------------------------------------------------------------
;Procedure initins;
;-----------------------------------------------------------------------------
initins:
        mov  ds,fileseg
        mov  es,datos
        mov  si,16128
        mov  di,offset registros
        mov  cx,99
sacafm: lodsb
        mov  ah,es:[di]
        xchg ah,al
        call outfm
        inc  di
        loop sacafm
        mov  si,16258
        lodsb
        xor  ah,ah
        inc  ax
        mov  speed,al
        mov  si,16376
        lodsb
        xor  ah,ah
        inc  ax
        shl  ax,4
        mov  lastline,ax
        ret

;-----------------------------------------------------------------------------
;Procedure SetWhat Drum
;-----------------------------------------------------------------------------
SetWhatDr:
        mov    ds,Fileseg
        mov    cx,lastline
        dec    cx
        mov    bx,12
findone: mov    ax,cx
        mul    bx
        mov    si,ax
        add    si,11
        lodsb
        cmp    al,0
        jne    found
        loop   findone
found:  mov    dx,offset drumjmp2
        cmp    al,0fh
        ja     system2
        mov    dx,offset drumjmp1
system2: mov   drumsys,dx
        ret
;-----------------------------------------------------------------------------
;Procedure initvars;
;-----------------------------------------------------------------------------
initall:
    ;    mov    bx,2000h
    ;    call   SetBlock
        push   cs
        pop    ds
        mov    datos,ds
        mov    es,datos
        call   Loadmus
        jc     NoMusic
        call   initsound
        call   Initins
        call   SetWhatDr
NoMusic:
        ret
;-----------------------------------------------------------------------------
;Procedure donevars;
;-----------------------------------------------------------------------------
doneall:
        call initsound
  ;      mov  es,fileseg
  ;      call deallocate
        ret

;-----------------------------------------------------------------------------
;procedure play
;-----------------------------------------------------------------------------
play:    mov   cx,0
         mov   ds,fileseg
         mov   ax,xx
         mov   bx,12
         mul   bx
         mov   si,ax
         push  si
         add   si,cx
otroch:  lodsb
         cmp   al,0
         je    noplay
         push  si
         push  cx
         cmp   al,64
         jne   Nonotaoff
         call  NoteOff
         jmp   short devuel
Nonotaoff:  ja    devuel
         push  ax
         call  Noteoff
         pop   ax
         pop   cx
         push  cx
         call  Noteon
devuel:  pop   cx
         pop   si
noplay:  inc   cl
         cmp   cl,canales
         jne   otroch
         pop   si
         add   si,11
         lodsb
         call  drums
         inc   xx
         mov   ax,xx
         cmp   ax,Lastline
         jne   norep
         mov   ax,permission21
         or    ax,permission25
         or    ax,permission13
         je    sipuede
         dec   xx
         jmp   norep
sipuede: mov   EndMusic,255
norep:   mov   al,036h
         out   43h,al
         mov   al,149
         out   40h,al
         mov   al,66
         out   40h,al
         ret
;-----------------------------------------------------------------------------
;procedure loadmus
;-----------------------------------------------------------------------------


Loadmus: cmp    loaded,255
         je     yesload
         ret
yesload: mov    loaded,0
;         mov    bx,400h                ;   Get Mem where we can store
;         call   allocate               ;   our buffer
         mov    yetinmem,255
;         mov    fileseg,ax             ;
         cmp    SongDir,'C'
         jnb    HardDisk
         mov   bx,32
         mov   ax,seg bufdisk
;         call  allocate
         mov   es,ax
         push  ax
         mov   ax,0201h
         mov   dl,Songdir
         sub   dl,'A'
         mov   dh,0
         mov   bx,offset bufdisk
         mov   cx,1h
         int   13h
         jnc   nFile_err
         pop   es
;         call  deallocate
         jmp   File_err
nfile_err: pop  es
;         call  deallocate
HardDisk:
         mov    ds,datos
         mov    dx,offset musname      ;
         mov    ax,3d00h
         int    21h
         jc     file_err
         mov    bx,ax                   ;   Load file
         mov    ds,fileseg
         xor    dx,dx
         mov    cx,07h      
         mov    ax,3f00h    
         int    21h         
         jc     file_err
         mov    ax,3f00h
         mov    cx,04000h
         int    21h
         jc     file_err
         mov    ax,3e00h                ; close file
         int    21h                     ;

         mov    es,datos
         mov    di,offset SongName
         push   di
         mov    al,20h
         mov    cx,40
         rep    stosb
         pop    di
         mov    si,16294+39
         mov    cx,40
         std
findcn:  lodsb
         cmp    al,32
         jne    yafcn
         loop   findcn
yafcn:   mov    ax,40
         sub    ax,cx
         shr    ax,1
         add    di,ax
         mov    si,16294
         cld
         rep    movsb
         mov    si,16335
         mov    cx,40
         mov    di,offset Composer
         rep    movsb
         clc
         ret

file_err: ;mov   es,FileSeg
          ;call  Deallocate
          mov   YetInMem,0
          mov   Endmusic,255
          stc
          ret
;-----------------------------------------------------------------------------
;procedure initclock
;-----------------------------------------------------------------------------
initclock:
         xor   cx,cx
         mov   es,datos
         mov   ds,cx
         mov   si,4*8
         mov   di,offset Oldint
         movsw
         movsw
         mov   ax,offset inter
         mov   bx,17045          ;1193182/(18.2*4) ~ 70
         mov   dx,es
         jmp   setint
doneclock:
         mov   ax,Oldint
         mov   dx,oldint+2
         mov   bx,0
setint:  cli
         xor   cx,cx
         mov   es,cx
         mov   di,4*8
         stosw
         mov   ax,dx
         stosw
         mov   playing,bx
         mov   al,036h
         out   43h,al
         mov   al,bl
         out   40h,al
         mov   al,bh
         out   40h,al
         sti
         ret
;-----------------------------------------------------------------------------
;interrupt routine
;-----------------------------------------------------------------------------
inter:   pusha
         push  ds es
         mov   al,020h
         out   20h,al
         inc   lastbar
         mov   al,lastbar
         cmp   al,speedbar
         jne   nodec
         mov   lastbar,0
         mov   ds,datos
         mov   si,offset peaklevel
         mov   es,datos
         mov   di,si
         mov   cx,9
decpeak: lodsb
         or    al,al
         je    nodecre
         dec   al
nodecre: stosb
         loop  decpeak
nodec:   inc   lastinc
         mov   al,lastinc
         cmp   speed,al
         jne   aunno
         mov   lastinc,0
         call  play
aunno:   pop   es ds
         popa
         cmp   EndMusic,255
         jne   noEndM
         pushf
         push  cs
         push  offset FinMusic
NoEndM:  inc   llamar
         cmp   llamar,4
         jne   nollamar
         mov   llamar,0
         pushf
         push  OldInt+2
         push  Oldint
nollamar: iret

;-----------------------------------------------------------------------------
;procedure SetFilename (NumofSong)
;-----------------------------------------------------------------------------
StFileN:  mov   si,offset SongDir
          mov   es,datos
          mov   di,offset MusName
          mov   cx,128
CopyDirName:
          lodsb
          or    al,al
          je    UltimoChar
          stosb
          loop  CopyDirName
UltimoChar:
          cmp   byte ptr [si-2],'\'
          je    NoNeeded
          mov   al,'\'
          stosb
NoNeeded: mov   ax,NumOfSong
          mov   bx,12
          mul   bx
          mov   ds,SongListSeg
          mov   si,ax
          mov   cx,6
          rep   movsw
          xor   al,al
          stosb
          ret

;-----------------------------------------------------------------------------
;procedure BackMusic
;-----------------------------------------------------------------------------
backmusic:nop
Buscaback: mov si,numofsong
          cmp  si,0ffffh
          jne  nofondo
          mov  si,NumOfFiles
          mov  numofsong,si
          mov  ax,numoftags
          inc  ax
          mov  NumOrder,ax
nofondo:  dec  NumOfSong
          add  si,offset MyTaglist
          lodsb
          cmp  al,1
          jne  buscaback
          inc  NumOfsong
          call StFileN
          dec  NumOrder
          ret

;----------------------------------------------------------------------------
;procedure AdvanceMusic
;----------------------------------------------------------------------------
Advmusic: nop
BuscaOtro:
          mov   si,NumOfSong
          cmp   NumOfFiles,si
          jnb   SiNormalFile
          mov   si,0
          mov   NumOfSong,0
          mov   NumOrder,0
SiNormalFile:
          inc   NumOfSong
          add   si,offset MyTaglist
          lodsb
          cmp   al,1
          jne   BuscaOtro
          dec   NumOfSong
          call  stFileN
          inc   NumOrder
          ret

;-----------------------------------------------------------------------------
;procedure FinMusic
;-----------------------------------------------------------------------------
FinMusic: pusha
          push  ds es
          cmp   playing,0
          je    noloopm1
          cmp   newlist,255
          je    noloopm1
          cmp   numoftags,1
          jne   noloopm
          mov   xx,0
          mov   EndMusic,0
          jmp   errorondrive
noloopm1:  mov   newlist,0
          mov   numofsong,0ffffh
noloopm:   push  cs
          Call  StopPlaying
          mov   EndMusic,0
          cmp   Songdir,'C'
          jnb   NoVerif
          mov   bx,32
          mov   ax,seg bufdisk
;          call  allocate
          mov   es,ax
          push  ax
          mov   ax,0201h
          mov   dl,Songdir
          sub   dl,'A'
          mov   dh,0
          mov   bx,offset bufdisk
          mov   cx,1h
          int   13h
          jnc   nOnDrive
          pop   es
;          call  deallocate
          jmp   ErrorOnDrive
nOnDrive: pop   es
;          call  deallocate

NoVerif:
          mov   ds,datos
          cmp   sntmusic,0
          je    avanza
          dec   NumOfSong
          call  BackMusic
          mov   sntmusic,0
          jmp   skpav
avanza:   inc   NumOfSong
          call  AdvMusic
skpav:    mov   Loaded,0ffh
          push  cs
          call  StartPlaying
          mov   SongChanged,255
ErrorOnDrive:
          pop   es ds
          popa
          iret
;-----------------------------------------------------------------------------
;procedure Song Changed?
;-----------------------------------------------------------------------------
SongCh:   mov   al,SongChanged
          mov   SongChanged,0
          retf

;-----------------------------------------------------------------------------
;procedure setFilename
;-----------------------------------------------------------------------------
SetFileName:
         push es cx di
         mov  es,datos
         mov  di,offset musname
         mov  cx,200
         rep  movsb
         mov  loaded,0ffh
         pop  di cx es
         retf

;-----------------------------------------------------------------------------
;procedure StartPlaying
;-----------------------------------------------------------------------------
StartPlaying:
         pusha
         push  ds es
         cmp   playing,0
         je    noplaying
         call  doneclock
         call  initsound
noplaying: cmp  yetinmem,0
         je    nofree
;         mov   es,fileseg
;         call  deallocate
         mov   yetinmem,0
nofree:  cmp   loaded,0
         je    nold
         call  loadmus
         jc    NoStart
nold:    call  initsound
         call  Initins
         call  SetWhatDr
         mov   xx,0
         call  initclock
NoStart:
         pop   es ds
         popa
         retf
;-----------------------------------------------------------------------------
;procedure StopPlaying
;-----------------------------------------------------------------------------
StopPlaying:
         pusha
         push  ds es
         cmp   playing,0
         je    nostopp
         call  doneclock
         call  initsound
NoStopP:
         cmp   yetinmem,0
         je    Nolib
;         mov   es,FileSeg
;         call  Deallocate
         mov   yetinmem,0
Nolib:   pop   es ds
         popa
         retf

;-----------------------------------------------------------------------------
;procedure GetPeakDir
;-----------------------------------------------------------------------------
GetPeakDir:
         mov  ds,datos
         mov  si,offset Peaklevel
         retf
;-----------------------------------------------------------------------------
;procedure SetChannelOff bp=canal off
;-----------------------------------------------------------------------------
SetChannelOff:
         mov  chanof[bp],1
         mov  ax,0b0h
         add  ax,bp
         call outfm
         cmp  bp,6
         jb   nodrumoff
         sub  bp,6
         mov  drumof[bp],1
         add  bp,6
nodrumoff: retf
;-----------------------------------------------------------------------------
;procedure SetChannelOn bp=canal on
;-----------------------------------------------------------------------------
SetChannelOn:
         mov  chanof[bp],0
         cmp  bp,6
         jb   nodrumon
         sub  bp,6
         mov  drumof[bp],0
         add  bp,6
noDrumOn: retf
;-----------------------------------------------------------------------------
;procedure SetDrumsOn
;-----------------------------------------------------------------------------
SetDrumsOn: mov  canales,6
         mov  ax,0b6h
         call outfm
         inc  al
         call outfm
         inc  al
         call outfm
         mov  drumsoff,0
         retf
;-----------------------------------------------------------------------------
;procedure SetDrumsOff
;-----------------------------------------------------------------------------
SetDrumsOff:
        mov  drumsoff,1
        mov  ax,0bdh
        call outfm
        mov  ds,fileseg
        mov  es,datos
        mov  si,16128+66
        mov  di,offset registros+66
        mov  cx,33
        call sacafm
        mov  canales,9
        retf
;-----------------------------------------------------------------------------
;procedure SetAudioOff
;-----------------------------------------------------------------------------
SetAudioOff:
         xor  bp,bp
         mov  cx,9
AudioOff:  mov  chanof[bp],1
         mov  ax,0b0h
         add  ax,bp
         call outfm
         inc  bp
         loop AudioOff
         retf
;-----------------------------------------------------------------------------
;procedure HChannels
;-----------------------------------------------------------------------------
HChannels:
         mov  cl,canales
         xor  ch,ch
         retf
;-----------------------------------------------------------------------------
;procedure GetPSname
;-----------------------------------------------------------------------------
GetPSName:
         mov  ds, datos
         mov  si, offset SongName
         retf
;-----------------------------------------------------------------------------
;procedure GetPSComp
;-----------------------------------------------------------------------------
GetPSComp:
         mov  ds, datos
         mov  si, offset Composer
         retf
;-----------------------------------------------------------------------------
;procedure SetList
;-----------------------------------------------------------------------------
SetList: mov  fileseg,bp
         mov  numoftags,cx
         mov  es,datos
         mov  di,offset MyTagList
         mov  cx,256
         rep  movsw
         mov  SongListSeg,ax
         mov  NumOfFiles,bx
         mov  NumOfSong,0
         mov  newlist,255
         mov  numorder,0
         pushf
         push cs
         call FinMusic
         retf
;-----------------------------------------------------------------------------
;procedure SetPathDir
;-----------------------------------------------------------------------------
SetPathDir: mov es,datos
         mov  di,offset SongDir
         mov  cx,32
         rep  movsw
         retf
;-----------------------------------------------------------------------------
;procedure xxstate
;-----------------------------------------------------------------------------
xxstate:  mov  ax,xx
         shr  ax,4
         inc  ax
         mov  bx,lastline
         shr  bx,4
         retf
;-----------------------------------------------------------------------------
;procedure setxx
;-----------------------------------------------------------------------------
setxx:   shl  ax,4
         mov  xx,ax
         retf
;-----------------------------------------------------------------------------
;procedure backxx
;-----------------------------------------------------------------------------
backxx:  mov  sntmusic,255
advxx: mov  ax,lastline
         dec  ax
         mov  xx,ax
         retf
end
