dosseg
.model small
.286
.stack 0200h
.code

Extrn StartPlaying:far,StopPlaying:far,SetFileName:far,Deallocate:far
Extrn Allocate:far, SetBlock:far,GetPeakdir:far,SetChannelOff:far
Extrn SetChannelOn:far, SetDrumsOff:far,SetDrumsOn:far
Extrn HChannels:far,SetAudioOff:far,GetPSName:far,GetPSComp:far
Extrn SetPathDir:far, SetList: Far, SongCh:far,xxstate:far,setxx:far
Extrn backxx:far,Advxx:far
Extrn permission21,permission25,permission13 : word
Extrn NumOrder,NumOftags,playing : word
datos    dw @code
Screenseg dw 0a000h
lgsname  equ word ptr 14
lgdir    equ word ptr 23
Paleta   db  768 dup (0)
PatronPeak db 10 dup (5,58,0),2 dup (55,6,0)
Chanof   db 9 dup (0)
Drumsof  db 0
Audiof   db 0
pmx      dw 0                      ;Last Mouse Position
pmy      dw 0
bufword  equ 17*2
bufCx    dw 73,36,145,241,14,68,279,124,3,0,0,0,0,49,10,271
         dw 63,255,63,64,267,9,11,133
bufcy    dw 7,35,29,34,94,87,94,149,167,64,161,79,176,4,91,91
         dw 83,83,83,141,117,117,137,187
bufAn    dw 180,48,32,43,31,187,24,78,69,320,320,320,320,230,39,39
         dw 5,4,192,192,44,44,40,53
bufAl    dw 13,12,30,14,10,54,10,9,6,4,4,4,4,23,16,16
         dw 62,62,4,4,28,28,6,12
bufcode  dw 11,12,13,14,15,16,17,18,19,20,20,21,21,22,23,23
         dw 24,25,20,21,26,26,27,30

PicMem   dw 0,9 dup (0),0,0,0,0,0,0,0,0,0
PicData  dw 0,9 dup (0),0,0,0,0,0,0,0,0,0
PicAl    dw 8,9 dup (8),33,33,139,115,11,11,7,40,2
PicAn    dw 7,9 dup (16),43,43,148,84,320,244,144,64,50
NormAn   dw 7,9 dup (16),43,43,148,84,320,244,144,64,50
LastAn   dw 0,9 dup (0),0,0,0,0,0,0,0,0,0
LastAl   dw 0,9 dup (0),0,0,0,0,0,0,0,0,0
PicX     dw 0,77,96,115,134,153,172,191,210,229,237,34,87,89,0,76,89,0,184
PicY     dw 0,9 dup (131),28,28,46,68,68,165,59,0,150
savemem  dw 0,9 dup (1),1,1,1,0,0,0,0,0,0
picerase dw 1,1,8 dup(0),1,0,1,1,1,1,1,1,1

SErrorRes db 'Cannot find resource file FSTR.RES in: ',0ah,0dh
GfxFile  db 64+9 dup (0)
         db 0ah,0dh,'Anormal program termination.',0ah,0dh,'$'
GfxFilen db 'FSTR.RES',0
GfxHandle  dw 0
LgCompBlk dw 0
bitcom   db 0
cualGfx  dw 0
CxGfx    dw 0

MouseAl  equ 8
MouseAn  equ 7

BoxX1    dw 77,96,115,134,153,172,191,210,229,236,34,272,145,268,304,8,43,13
BoxX2    dw 93,112,131,150,169,188,207,226,244,287,86,307,173,274,309,14,49,48
BoxY1    dw 9 dup (95),29,29,90,29,136,136,136,136,90
BoxY2    dw 9 dup (139),55,55,105,55,144,144,144,144,105
BoxHere  dw 0
BoxJumps dw 9 dup (offset TogChan),Toggledrums,ToggleAudio,quit,disco,incxx
         dw decxx,Advsng,Backsng,shell
comandos dw 18

BoxX1F   dw 173,173,186,16 dup (89),186,268,304, 6 dup (184)
BoxX2F   dw 183,183,232,16 dup (89+lgsname*6),232,274,309, 6 dup (234)
BoxY1F   dw 68,125,81
         i = 0
           rept 16
           dw (69+7*i)-1
           i = i+1
         endm
         dw 68,136,136
         i = 0
           rept 6
           dw (93+12*i)
           i = i+1
         endm
BoxY2F   dw 123,182,92
         i = 1
           rept 16
           dw 69+7*i
           i = i+1
         endm
         dw 78,144,144
         i = 1
           rept 6
           dw 94+12*i
           i = i+1
         endm
BoxJumpsF dw offset FileArrowUp,FileArrowDown,AbortFileLoad
          dw 16 dup (offset ToggleTag),OkLoad,IncXX,DecXX,6 dup (ccdrive)
comandosF dw 28


MousePresX dw 0
MousePresY dw 0
ButtonPress db 0
Waiting  db 0
PauseMouse db 0
DelayMouse db 0

FontMem  dw 0,0
FontAl   dw 6,9
FontAn   dw 6,8
FontAdd  dw 6*38,8*37
FontTrans db 0
CharCol  db 0

SongName db 40 dup (0),'$'
Composer db 40 dup (0),'$'
Num      db 3 dup ('0'),'$'

myxx         dw 1
mylastlin    dw 0
JunkSeg      dw 0
SnSeg        dw 0
OffPutSName  dw 0
NumOfFiles   dw 0
FirstOfFList dw 0
FirstMusic   dw 0
Nowlist      dw 0
LongList     equ 16
TagList      db 512 dup (0)
NumOfTag     dw 0
FilesSeg      dw 0
MyDTA        db 30 dup (0)
DTAFile      db 13 dup (0)
FileSeek     db lgsname dup (0),'$'
FileMask     db '*.mus',0
DirMask      db '*.*',0
CurDrive     db ' :\'
CurDir       db 70 dup (0),'$'
changedir    db 1
Changedir2   db 1
DefDrive     db ' :\'
DefDir       db 70 dup (0),'$'
fileseg      dw 0
execParam db 1,' '
execTparam dw 0,offset execparam,seg execparam,0,0,0,0
execFname  db 'c:\command.com',0
execpila   dw 0,0
listsize   dw 0
old_ax21   dw 0
old_bp21   dw 0

kbe0flag   db 0
kbmsx      dw 0
kbmsy      dw 0
kbmsbut    db 0
oldint9    dw 0,0
oldint33   dw 0,0
kblast     db 0
kbspd      dw 0

Drives     db 0,0,0,0,0,0,0
DriveLabel db 'Disk '
WhichDr    db ' :$'
NumOfDrives db 0

Terror1    db 'Sorry dude, you need $'
Terror2    db 'a 286 or higher processor $'
Terror3    db 'and $'
Terror4    db 'at least a VGA card $'
Memerror   db 'Not enough memory, you need 95 Kb '
Terror5    db 'to enjoy this program.',0dh,0ah,'$'
NoVGA      db 0
No286      db 0

Palbuf     dw 0
enclg      dw 0
encst      dw 0
enclg3     dw 0
encst3     dw 0
;----------------------------------------------------------------------------
;mouse-keyboard interrupt
;----------------------------------------------------------------------------
mousekb:   cli
           cmp  ax,3
           jne  msnoget
           cmp  kbmsx,320
           jb   msokx
           mov  kbmsx,319
msokx:     mov  cx,kbmsx
           shl  cx,1
           cmp  kbmsy,200
           jb   msoky
           mov  kbmsy,199
msoky:     mov  dx,kbmsy
           mov  bl,kbmsbut
           sti
           iret
msnoget:   cmp  ax,4
           jne  msnoset
           shr  cx,1
           mov  kbmsx,cx
           mov  kbmsy,dx
msnoset:   sti
           iret
;----------------------------------------------------------------------------
;keyboard interrupt
;----------------------------------------------------------------------------
keyint:    cli
           push ax bx
           mov     al,20h
           out     20h,al
           in   ax,60h
           xchg ah,al
           or   al,080h
           out  61h,al
           and  al,07fh
           out  61h,al
           mov  al,ah
           cmp  al,0e0h
           je   kbac
           cmp  kblast,al
           jne  kbnoac
           inc  kbspd
           jmp  kbac
kbnoac:    mov  kbspd,4
           mov  kblast,al
kbac:      and  al,07fh
           cmp  al,039h
           jne  knospc
           and  ah,80h
           rol  ah,1
           xor  ah,1
           mov  kbmsbut,ah
           pop  bx ax
           sti
           iret
knospc:    cmp  kbe0flag,1
           je   kbje0flag
           cmp  ah,0e0h
           jne  kbnone
           mov  kbe0flag,1
           jmp  kbnone
kbje0flag:
           mov  kbe0flag,0
           and  ah,080h
           jne  kbnone
           mov  bx,kbspd
           shr  bx,1
           cmp  al,48h
           je   kbup
           cmp  al,50h
           je   kbdn
           cmp  al,4bh
           je   kblf
           cmp  al,4dh
           jne  kbnone
           add  kbmsx,bx
           jmp  kbnone
kblf:      sub  kbmsx,bx
           jnc  kbnone
           mov  kbmsx,0
           jmp  kbnone
kbdn:      add  kbmsy,bx
           jmp  kbnone
kbup:      sub  kbmsy,bx
           jnc  kbnone
           mov  kbmsy,0
kbnone:    pop  bx ax
           sti
           iret

;----------------------------------------------------------------------------
;Procedure SetPal
;----------------------------------------------------------------------------
SetPal:    push ds
           mov  ds,datos
           mov  si,offset paleta
           mov  dx,3c8h
           out  dx,al
           xor  ah,ah
           mov  bx,3
           mul  bx
           add  si,ax
leena:     mov  dx,3c9h
           outsb
           outsb
           outsb
           mov  dx,03dah
noline:    in   al,dx
           test al,1
           jnz  noline
tono:      in   al,dx
           test al,1
           jz   tono
           loop leena
           pop  ds
           ret
;----------------------------------------------------------------------------
;Procedure Encen
;----------------------------------------------------------------------------

encen:   mov    bx,48
         call   allocate
         mov    es,ax
         mov    palbuf,ax
         mov    ds,datos
         mov    si,offset paleta
         xor    di,di
         mov    cx,384
         push   cx si
         rep    movsw
         pop    di cx
         mov    es,datos
         xor    ax,ax
         rep    stosw
         mov    encst,229
         mov    encst3,687
         mov    enclg,27
         mov    enclg3,81
         call   encenx
         mov    encst,0
         mov    encst3,0
         mov    enclg,229
         mov    enclg3,687
         call   encenx
         mov    es,palbuf
         call   deallocate
         ret

encenx:  mov    bl,63
enotro:  mov    ds,palbuf
         mov    es,datos
         mov    dx,3dah
         in     al,dx
         test   al,8
         jz     enotro
         mov    si,encst3
         mov    di,offset paleta
         add    di,encst3
         mov    cx,enclg3
ensube:  cmp    bl,ds:[si]
         jne    enosube
         dec    byte ptr ds:[si]
         inc    byte ptr es:[di]
enosube: inc    di
         inc    si
         loop   ensube
         mov    ax,encst
         mov    cx,enclg
         push   bx
         call   Setpal
         call   outlevel
         pop    bx
         dec    bl
         jne    enotro
         ret
;----------------------------------------------------------------------------
;Procedure Apaga
;----------------------------------------------------------------------------
Apaga:   mov    bl,64
Apotro:  mov    ds,datos
         mov    si,offset paleta
         mov    dx,3dah
         in     al,dx
         test   al,8
         jz     apotro
         mov    cx,768
apdec:   cmp    byte ptr ds:[si],0
         je     apm
         dec    byte ptr ds:[si]
apm:     inc    si
         loop   apdec
         push   bx
         call   Outlevel
         xor    al,al
         mov    cx,96
         call   Setpal
         mov    al,204
         mov    cx,52
         call   Setpal
         pop    bx
         dec    bl
         jne    apotro
         cmp    playing,0
         jne    app
         ret
app:     mov    cx,120
         mov    dx,3dah
apotro2: in     al,dx
         test   al,8
         jz     apotro2
axxxx:   in     al,dx
         test   al,8
         jnz     axxxx
         push   cx
         mov    ds,datos
         mov    si,offset patronpeak
         mov    cx,12*3
nodec3:  cmp    byte ptr [si],0
         je     nodec2
         dec    byte ptr [si]
nodec2:  inc    si
         loop   nodec3
         call   Outlevel
         pop    cx
         loop   apotro2
         ret
;----------------------------------------------------------------------------
;Procedure Outlevel
;----------------------------------------------------------------------------
Outlevel:  call GetPeakDir
          mov  es,datos
           mov  cx,9
           mov  bp,0
Sacando:    push cx
            mov  ax,12*3
            mul  bp
            mov  di,offset paleta
            add  di,ax
            add  di,96*3
            push  di
             mov   cx,12*3
             xor   al,al
             rep stosb
            pop   di
            lodsb
            xor   ah,ah
            mov   bx,3
            mul   bx
            push  ds
            push  si
             mov   ds,datos
             mov   si,offset patronpeak
             mov   cx,ax
             rep   movsb
            pop   si
            pop   ds
           pop   cx
           inc   bp
           loop  Sacando
           mov   al,96
           mov   cx,12*9
           call  SetPal
           ret

;----------------------------------------------------------------------------
;Procedure PutGraph bp=#pic*2
;----------------------------------------------------------------------------
PutmousePic:  mov   es,PicMem
           jmp   pnormal
PutGraph:  cmp   savemem[bp],0
           jne    Saveimg
           mov   ax,PicY[bp]
           mov   bx,320
           mul   bx
           add   ax,PicX[bp]
           push  ax
           jmp   Onlyput
Saveimg:   mov   ax,PicAl[bp]
           mov   bx,PicAn[bp]
           mul   bx
           shr   ax,4
           inc   ax
           mov   bx,ax
           call  allocate
           mov   PicMem[bp],ax
           mov   es,ax
PNormal:   mov   ds,screenseg             ; Get picture
           xor   di,di
           mov   ax,PicY[bp]
           mov   bx,320
           mul   bx
           add   ax,PicX[bp]
           push  ax
           mov   si,ax
           mov   cx,PicAl[bp]
GetPic:    push  cx
           push  si
           mov   cx,PicAn[bp]
           rep   movsb
           pop   si
           add   si,320
           pop   cx
           loop  GetPic
OnlyPut:   mov   es,screenseg            ; Put Picture
           mov   ds,cs:PicData[bp]
           xor   si,si
           pop   di
           mov   cx,PicAl[bp]
PutPic:    push  cx
           push  di
           push  si
           mov   cx,PicAn[bp]
copymlin:  lodsb
           or    al,al
           jne   notrans
           inc   di
           jmp   short trans
NoTrans:   stosb
Trans:     loop  copymlin
           pop   si
           pop   di
           add   si,NormAn[bp]
           add   di,320
           pop   cx
           loop  putpic
           mov   ax,PicAn[bp]
           mov   LastAn[bp],ax
           mov   ax,PicAl[bp]
           mov   LastAl[bp],ax
           ret
;----------------------------------------------------------------------------
;Procedure RestGraph bp=#pic*2
;----------------------------------------------------------------------------
RestGraph:
           mov  ds,PicMem[bp]
           mov  es,ScreenSeg
           mov  ax,PicY[bp]
           mov  bx,320
           mul  bx
           add  ax,PicX[bp]
           mov  di,ax
           xor  si,si
           mov  cx,LastAl[bp]
CopyMGfx:  push cx
           push di
           mov  cx,LastAn[bp]
           rep  movsb
           pop  di
           add  di,320
           pop  cx
           loop CopyMGfx
           cmp  savemem[bp],0
           je   esmousepic
           mov  es,PicMem[bp]
           mov  picmem[bp],0
           call deallocate
esmousepic: ret

;----------------------------------------------------------------------------
;Procedure PutMouse
;----------------------------------------------------------------------------
PutMouse:  mov  ax,pmx
           mov  bx,pmy
           cmp  ax,PicX
           jne  moviom
           cmp  bx,PicY
           jne  moviom
           ret
moviom:    push ax bx
           call restmouse
           pop  bx ax
           mov  picx,ax
           mov  picy,bx
OPutMouse: push bp
           xor  bp,bp
           call PutMousePic
           pop  bp
           ret
;----------------------------------------------------------------------------
;Procedure RestMouse
;----------------------------------------------------------------------------
RestMouse: push bp
           xor  bp,bp
           call RestGraph
           pop  bp
           ret

;----------------------------------------------------------------------------
;Procedure GetMousePos; cx=horiz,dx=vert
;----------------------------------------------------------------------------
GetMousePos:
           mov  ax,3
           int  33h
           shr  cx,1
           cmp  cx,320
           jb   okcxm
           mov  cx,319
okcxm:     cmp  dx,200
           jb   okcym
           mov  dx,199
okcym:     mov  pmx,cx
           mov  pmy,dx
           mov  ButtonPress,bl
           or   bl,bl
           jne  NoBotM
           mov  MousePresX,cx
           mov  MousePresY,dx
NoBotM:    mov  PicAn,MouseAn
           mov  PicAl,MouseAl
           mov  ax,320-MouseAn
           sub  cx,ax
           jbe  NoArX
           mov  ax,MouseAn
           sub  ax,cx
           mov  pican,ax
NoArX:     mov  ax,200-MouseAl
           sub  dx,ax
           jbe  NoAry
           mov  ax,MouseAl
           sub  ax,dx
           mov  pical,ax
NoArY:     ret

;----------------------------------------------------------------------------
;Procedure SetMousePos; cx=horiz,dx=vert
;----------------------------------------------------------------------------
SetMousePos:
           mov ax,4
           int 33h
           ret

;----------------------------------------------------------------------------
;Procedure Cual comando Boxhere=comando (255=ninguno),bp = grupo
;----------------------------------------------------------------------------
CualCom:
        mov  boxhere,255
        mov  cx,comandos
        xor  bp,bp
        mov  ax,MousePresX
        mov  bx,MousePresY
FindBox: cmp  ax,BoxX1[bp]
        jb   NoDentro
        cmp  ax,BoxX2[bp]
        jnb  NoDentro
        cmp  bx,BoxY1[bp]
        jb   Nodentro
        cmp  bx,BoxY2[bp]
        jnb  Nodentro
        shr  bp,1
        mov  BoxHere,bp
        ret
Nodentro: inc bp
        inc bp
        loop FindBox
        ret

;----------------------------------------------------------------------------
;Procedure PrepareScreen
;----------------------------------------------------------------------------
PrepareScreen:
        mov  ax,013h
        int  10h
        mov  dx,03c8h
        xor  ax,ax
        out  dx,al
        inc  dx
        mov  cx,768
outsss: out dx,al
        loop outsss

preotro:  mov    dx,3dah
         in     al,dx
         test   al,8
         jz     preotro

        mov  picX[bufword],0
        mov  picY[bufword],0
        mov  picAl[bufword],40
        mov  picAn[bufword],64
        mov  NormAn[bufword],64
        mov  cx,10
        call getgfx
        mov  ax,es
        mov  picdata[bufword],ax
        mov  bp,bufword
        mov  cx,5
vtext:  push cx
        mov  cx,5
htext:  push cx
        call PutGraph
        add  PicX[bufword],64
        pop  cx
        loop htext
        mov  picX[bufword],0
        add  PicY[bufword],40
        pop  cx
        loop vtext
        mov  es,picdata[bufword]
        call deallocate
        mov  cx,24
        mov  bp,0
cicloput: push  cx bp
        mov  ax,BufCx[bp]
        mov  PiCX[bufword],ax
        mov  ax,BufCy[bp]
        mov  PiCY[bufword],ax
        mov  ax,BufAl[bp]
        mov  PicAl[bufword],ax
        mov  ax,BufAn[bp]
        mov  PicAn[bufword],ax
        mov  Norman[bufword],ax
        mov  cx,bufcode[bp]
        call GetGfx
        mov  PicData[bufword],es
        mov  bp,bufword
        call PutGraph
        mov  es,PicData[bufword]
        call deallocate
        pop  bp
        add  bp,2
        pop  cx
        loop cicloput
        mov  cx,28
        call GetGfx
        push es
        pop  ds
        mov  es,datos
        mov  di,offset paleta
        xor  si,si
        mov  cx,384
        rep  movsw
        push ds
        pop  es
        call deallocate
        ret
;----------------------------------------------------------------------------
;Procedure DoneVars
;----------------------------------------------------------------------------
DoneVars:
        mov  ds,oldint9+2
        mov  dx,oldint9
        mov  ax,2509h
        int  21h
        mov  ds,oldint33+2
        mov  dx,oldint33
        mov  ax,2533h
        int  21h
        mov  ds,oldint24+2
        mov  dx,oldint24
        mov  ax,2524h
        int  21h

        call apaga

        mov  cx,768
        mov  dx,03c8h
        xor  al,al
        out  dx,al
        inc  dx
apadx:  out  dx,al
        loop apadx

        call StopPlaying
        mov  bp,14*2
        call RestGraph
        mov  bp,15*2
        call RestGraph
        mov  es,PicMem
        call deallocate
        mov  ax,3
        int  10h
        mov  ah,0eh
        mov  dl,DefDrive
        sub  dl,'A'
        int  21h
        mov  ah,03bh
        mov  ds,datos
        mov  dx,offset defDrive
        int  21h
        ret

;----------------------------------------------------------------------------
;Procedure OpenGfx
;----------------------------------------------------------------------------
OpenGFX: mov  ds,datos
        mov  es,datos
        mov  si,offset defDrive
        mov  di,offset GfxFile
        mov  cx,70
aquicd: lodsb
        or   al,al
        je   stopmd
        stosb
        loop aquicd
stopmd: cmp  byte ptr [si-2],'\'
        je   npbl
        mov  al,'\'
        stosb
npbl:   mov  si,offset gfxfilen
        mov  cx,6
        rep  movsw
        mov  dx,offset gfxfile
        mov  ax,3d00h
        int  21h
        jc   ErrorRes
        mov  gfxhandle,ax
        ret
ErrorRes: mov ax,3
        int  10h
        mov  dx,offset SErrorRes
        mov  ax,900h
        int  21h
        mov  ax,4c00h
        int  21h

CloseGfx:
        mov  bx,gfxhandle
        mov  ax,3e00h
        int  21h
        ret

;----------------------------------------------------------------------------
;Procedure GetGfx
;----------------------------------------------------------------------------
GetGfx: mov  cualgfx,0
        mov  cxgfx,cx
        mov  bx,gfxhandle
        mov  ax,4200h
        xor  cx,cx
        xor  dx,dx
        int  21h           ; move pointer to 0
otronlk: mov  ds,datos
        mov  dx,offset lgcompblk
        mov  ax,3f00h
        mov  cx,2
        int  21h
        mov  cx,cualgfx
        cmp  cx,cxgfx
        je   EsteEs
        inc  cualgfx
        mov  ax,4201h
        xor  cx,cx
        mov  dx,lgcompblk
        int  21h
        jmp  otronlk
EsteEs: push lgcompblk                   ; alocate mem & buffer
        mov  cx,2
        mov  ax,3f00h
        int  21h
        mov  bx,lgcompblk
        shr  bx,4
        inc  bx
        call allocate
        mov  es,ax
        pop  bx
        push bx
        shr  bx,4
        inc  bx
        call allocate
        mov  ds,ax                       ; load compressed info
        xor  dx,dx
        pop  cx
        mov  bx,gfxhandle
        mov  ax,3f00h
        int  21h
        xor  si,si                      ; uncompress
        xor  di,di
        xor  ch,ch
lp1:    mov  bitcom,8
        lodsb
        mov  bl,al
lp2:    ror  bl,1
        jnc  nocompr
        lodsb
        mov  cl,al
        lodsb
        mov  bh,al
        and  bh,cl
        cmp  bh,255
        je   endallC
        rep  stosb
        jmp  endf
Nocompr: movsb
endf:   dec  bitcom
        jne  lp2
        jmp  lp1
EndAllC: push es
        push  ds
        pop   es
        call  deallocate
        pop   es
        ret

;----------------------------------------------------------------------------
;Procedure PrepareGraphs
;----------------------------------------------------------------------------
PrepareGraphs:
        mov  cx,0
        call GetGfx                    ; Mouse pointer
        mov  PicData,es
        mov  cx,1
        call GetGfx                    ; off labels
        mov  cx,9
        mov  ax,es
        mov  es,datos
        mov  di,offset picdata+2
        rep  stosw
        push di es
        mov  cx,2
        call GetGfx                    ; cross
        mov  ax,es
        pop  es di
        stosw
        stosw
        push di es
        mov  cx,3
        call getgfx                    ; disk box
        mov  ax,es
        pop  es di
        stosw
        push di es
        mov  cx,4
        call getgfx                    ; backlist
        mov  ax,es
        pop  es di
        stosw
        push di es
        mov  cx,5
        call getgfx                    ; compoback
        mov  ax,es
        pop  es di
        stosw
        push di es
        mov  cx,6                      ; titleback
        call getgfx
        mov  ax,es
        pop  es di
        stosw
        push di es
        mov  cx,7
        call getgfx                    ; backdir
        mov  ax,es
        pop  es di
        stosw
        mov  cx,8
        call getgfx
        mov  fontmem,es
        mov  cx,9
        call getgfx
        mov  fontmem+2,es
        mov  cx,29
        call getgfx
        mov  picdata+18*2,es
        ret

;----------------------------------------------------------------------------
;Procedure InitVars
;----------------------------------------------------------------------------
Initvars: push es
        mov  ax,es              ; set program area
        mov  bx,ss
        sub  bx,ax
        add  bx,21h
        call SetBlock
        pop  ax
        mov  bx,es:[2]
        sub  bx,ax
        cmp  bx,6080
        jnb   OkMem
        mov  ds,datos
        mov  dx,offset memerror
        mov  ax,0900h
        int  21h
        mov  ax,04c00h
        int  21h
OkMem:  push sp
        mov  bp,sp
        mov  ax,[bp]
        pop  sp
        cmp  ax,sp
        je   Ok286
        mov  No286,1
Ok286:  mov  ax,01a00h
        int  10h
        cmp  bl,6
        jnb  OkVga
        mov  NoVga,1
OkVga:  mov  al,NoVga
        or   al,No286
        je   OkAll
        mov  ds,datos
        mov  dx,offset Terror1
        mov  ax,0900h
        int  21h
        cmp  No286,1
        jne  Si286
        mov  dx,offset Terror2
        mov  ax,0900h
        int  21h
        cmp  NoVga,1
        jne  SiVga
        mov  dx,offset Terror3
        mov  ax,0900h
        int  21h
Si286:  mov  dx,offset Terror4
        mov  ax,0900h
        int  21h
SiVga:   mov  dx,offset Terror5
        mov  ax,0900h
        int  21h
        mov  ax,04c00h
        int  21h

OkAll:
        mov  bx,0400h
        call Allocate
        mov  fileseg,ax
        mov  bx,0180h
        call Allocate
        mov  filesseg,ax
        mov  ds,datos
        mov  dx,offset MyDta    ; set DTA adress
        mov  ah,01ah
        int  21h
        mov  ah,019h
        int  21h
        add  al,65
        mov  DefDrive,al
        xor  dx,dx
inDetDr: push dx
        mov  ah,0eh
        int  21h
        mov  ah,019h
        int  21h
        mov  bl,0
        pop  dx
        cmp  dl,al
        jne  inNoex
        mov  bl,1
inNoex: mov  bp,dx
        mov  drives+bp,bl
        inc  dx
        cmp  bp,6
        jne  indetdr
        mov  dl,DefDrive
        sub  dl,'A'
        mov  ah,0eh
        int  21h
        mov  ax,0440eh
        mov  bl,1
        int  21h
        jc   norev
        or   al,al
        je   norev
        mov  ax,050h
        mov  ds,ax
        mov  al,ds:[04h]
        xor  al,1
        mov  bp,ax
        mov  drives+bp,0

norev:  mov  ax,04700h
        mov  ds,datos
        mov  si,offset DefDir
        xor  dl,dl
        int  21h
        mov  cx,128
        push ds
        pop  es
        mov  di,offset CurDrive
        mov  si,offset DefDrive
copydrv: lodsb
        or   al,al
        je   stopdr
        stosb
        loop copydrv
stopdr: xor  al,al
        stosb
        mov  al,'$'
        stosb
restallgfx:
        mov  ax,3533h
        int  21h
        mov  oldint33,bx
        mov  oldint33+2,es
        mov  ax,es
        or   ax,bx
        je   nomouse
        cmp  byte ptr es:[bx],0cfh
        je   nomouse
        xor  ax,ax
        int  33h                ; mouse present?
        or   ax,ax
        jne  yesmouse
nomouse: mov  ds,datos
        mov  dx,offset mousekb
        mov  ax,2533h
        int  21h
yesmouse:
        call Opengfx
        call PrepareScreen      ; set video mode and palette
        call PrepareGraphs
        call closeGfx
        mov  bp,14*2
        call PutGraph
        mov  bp,15*2
        call PutGraph
        call encen
        mov  ax,pical           ; allocate mouse buffer memory
        mov  bx,pican
        mul  bx
        shr  ax,4
        inc  ax
        mov  bx,ax
        call Allocate
        mov  PicMem,ax
        mov  PicX,160
        mov  PicY,100
        mov  bp,0
        Call PutMousepic
        call RestMouse
        call OPutMouse

        mov  ax,3509h
        int  21h
        mov  oldint9,bx
        mov  oldint9+2,es
        mov  ds,datos
        mov  dx,offset keyint
        mov  ax,2509h                 ; new keyboard interrupt
        int  21h

        mov  ax,3524h
        int  21h
        mov  oldint24,bx
        mov  oldint24+2,es

        mov  ax,2524h
        mov  ds,datos
        mov  dx,offset critical
        int  21h

        mov  cx,320
        mov  dx,100
        call SetMousePos       ; Put Mouse on center
        call GetMousePos
        mov  ax,pmx
        mov  bx,pmy
        ret
;----------------------------------------------------------------------------
;Procedure Channel off bp=channel
;----------------------------------------------------------------------------
ChannelOff:
        push  bp
        call  restmouse
        inc   bp
        shl   bp,1
        call  PutGraph
        call  OPutMouse
        pop   bp
        call  SetChannelOff
        ret
;----------------------------------------------------------------------------
;Procedure Channel on bp=channel
;----------------------------------------------------------------------------
ChannelOn:
        push  bp
        call  restmouse
        inc   bp
        shl   bp,1
        call  RestGraph
        call  OPutMouse
        pop   bp
        call  SetChannelOn
        ret
;----------------------------------------------------------------------------
;Procedure Toggle Channel bp=channel
;----------------------------------------------------------------------------
TogChan:
        cmp   Chanof[bp],0
        jne   nochanof
        mov   Chanof[bp],1
        call  Channeloff
        ret
nochanof: mov chanof[bp],0
        call  ChannelOn
        ret
;----------------------------------------------------------------------------
;Procedure Toggle Audio bp=channel
;----------------------------------------------------------------------------
ToggleAudio:
        cmp  Audiof,0
        jne  noapaudio
        mov  Audiof,1
        call SetAudioOff
        call restmouse
        mov  bp,11*2
        call PutGraph
        call OPutMouse
        ret
Noapaudio: mov Audiof,0
        mov  cx,9
        xor  bp,bp
EncenA: cmp  ChanOf[bp],0
        jne  noencenc
        call SetChannelOn
NoEncenc: inc bp
        loop EncenA
        call restmouse
        mov  bp,11*2
        call RestGraph
        call OPutMouse
        ret
;----------------------------------------------------------------------------
;Procedure Toggle Drums
;----------------------------------------------------------------------------
ToggleDrums:
        cmp  drumsof,0
        jne  noapadrums
        mov  drumsof,1
        call SetDrumsOff
        call restmouse
        mov  bp,10*2
        call PutGraph
        call OPutMouse
        ret
Noapadrums: mov drumsof,0
        call SetDrumsOn
        call restmouse
        mov  bp,10*2
        call RestGraph
        call OPutMouse
        ret
;----------------------------------------------------------------------------
;Procedure quit
;----------------------------------------------------------------------------
quit:   pop ax
        jmp esckey
;----------------------------------------------------------------------------
;Procedure shell
;----------------------------------------------------------------------------
shell:  xor  bp,bp
        mov  cx,19
sacag:  push cx
        cmp  picmem[bp],0
        je   noresta
        push bp
        mov  es,picmem[bp]
        call deallocate
        pop  bp
noresta: cmp  picerase[bp],0
        je   noerase
        mov  es,picdata[bp]
        push bp
        call deallocate
        pop  bp
noerase: add  bp,2
        pop  cx
        loop sacag
        mov  es,fontmem
        call deallocate
        mov  es,fontmem+2
        call deallocate
        mov  ax,3
        int  10h

        mov  ds,oldint9+2
        mov  dx,oldint9
        mov  ax,2509h
        int  21h
        mov  ds,oldint33+2
        mov  dx,oldint33
        mov  ax,2533h
        int  21h
        mov  ds,oldint24+2
        mov  dx,oldint24
        mov  ax,2524h
        int  21h

        cli
        xor  ax,ax
        mov  ds,ax
        mov  ax,ds:[132]
        mov  oldint21,ax
        mov  ax,ds:[134]
        mov  oldint21+2,ax
        mov  ds:[132],offset myint21
        mov  ds:[134],cs
        sti

        mov  execpila,ss
        mov  execpila+2,sp
        mov  ax,cs
        mov  ds,ax
        mov  es,ax
        mov  bx,offset exectparam
        mov  dx,offset execFname
        mov  ax,04b00h
        int  21h
        mov  sp,execpila+2
        mov  ss,execpila

        cli
        xor  ax,ax
        mov  ds,ax
        mov  ax,oldint21
        mov  bx,oldint21+2
        mov  ds:[132],ax
        mov  ds:[134],bx
        sti

        mov  changedir,1
        mov  changedir2,1
        mov  ds,datos
        mov  dx,offset mydta
        mov  ah,1ah
        int  21h
        mov  ax,04700h
        mov  ds,datos
        mov  si,offset curDir
        xor  dl,dl
        int  21h
        mov  cx,128
        push ds
        pop  es
        mov  di,offset CurDrive
        mov  si,offset curDrive
crdrv: lodsb
        or   al,al
        je   cropdr
        stosb
        loop crdrv
cropdr: xor  al,al
        stosb
        mov  al,'$'
        stosb
        mov  FirstOfFlist,0
        call restAllGfx
        mov  bp,2
        mov  cx,12
restx:  push cx
        cmp  picmem[bp],0
        je   norest
        push bp
        call putgraph
        pop  bp
norest: add  bp,2
        pop  cx
        loop restx
        cmp  playing,0
        je   regre
        mov  myxx,0
        mov  mylastlin,0
        call yws
regre:  ret
myint21:
        pushf
        push  cs
        push  offset retint21
        cmp   ah,0ch
        jb    nnes
        cmp   ah,04bh
        je    nnes
        mov   permission21,255

nnes:   db    0eah
oldint21 dw   0,0
retint21:  pushf
        mov   old_ax21,ax
        mov   old_bp21,bp
        pop   ax
        mov   bp,sp
        mov   [bp+4],ax
        mov   ax,old_ax21
        mov   bp,old_bp21
        mov   permission21,0
        iret
;----------------------------------------------------------------------------
;Procedure Writechar in es:si = pointer charset,al =char, bx=ancho, cx=alto
;----------------------------------------------------------------------------
WriteChar:
        cmp  al,'.'
        jne  nopuntoch
        mov  al,37
        jmp  yaImpch
NoPuntoCh:
        cmp  al,'\'
        jne  nobacklch
        mov  al,38
        jmp  YaImpCh
nobacklch:
        cmp  al,':'
        jne  NoDosPCh
        mov  al,39
        jmp  YaImpCh
NoDosPCh:
        cmp  al,39
        jne  noquotech
        mov  al,40
        jmp  YaImpCh
noquotech:
        cmp  al,'0'
        jb   EspacioCh
        cmp  al,'9'
        jnbe  NoNum
        sub  al,22
        jmp  yaimpCh
NoNum:  or   al,32
        cmp  al,'a'
        jb   EspacioCh
        cmp  al,'z'
        jnbe  EspacioCh
        sub  al,'a'
        jmp  short YaImpCh
EspacioCh: mov  al,36
YaImpCh: xor  ah,ah
        mul  bl
        mul  cx
        add  si,ax
OutText: push cx
        push di
        push si
        mov  cx,bx
HorizCh: lodsb
        or   al,al
        jne  nottrans
        cmp  FontTrans,0
        je   chtrans
        mov  al,FontTrans
        stosb
        dec  di
        jmp  short chtrans
Nottrans:  mov  al,Charcol
        stosb
        dec  di
chtrans: inc  di
        loop HorizCh
        pop  si
        add  si,bx
        pop  di
        add  di,320
        pop  cx
        loop outText
        ret
;----------------------------------------------------------------------------
;Procedure WriteText in (ax,cx) coordenadas, dx offset text, bp #font
;----------------------------------------------------------------------------
WriteText:
        shl  bp,1
        push dx
        mov  bx,320
        mul  bx
        add  ax,cx
        push ax
        mov  es,ScreenSeg
        mov  si,cs:fontmem[bp]
        mov  ds,si
        xor  si,si
        mov  cx,cs:fontal[bp]
        mov  bx,cs:fontan[bp]
        mov  dx,cs:fontadd[bp]
        pop  di
        pop  bp
otrochar: push  di
        push si
        push cx
        mov  al,cs:[bp]
        cmp  al,'$'
        je   EndLineT
        call WriteChar
        pop  cx
        pop  si
        inc  bp
        pop  di
        add  di,bx
        jmp  otrochar
EndLineT:
        pop  cx
        pop  si
        pop  di
        ret
;----------------------------------------------------------------------------
;Procedure Writenum in (ax,cx) coordenadas, bp #font,dl numero
;----------------------------------------------------------------------------
WriteNum: push ax
        mov   ax,dx
        mov   bl,100
        div   bl
        add   al,'0'
        mov   Num,al
        shr   ax,8
        mov   bl,10
        div   bl
        add   al,'0'
        add   ah,'0'
        mov   word ptr Num+1,ax
        pop   ax
        mov   dx,offset Num+1
        call  WriteText
        ret
;----------------------------------------------------------------------------
;Procedure CheckXXState
;----------------------------------------------------------------------------

checkxx:
        call  xxstate
        cmp   ax,myxx
        je    nupdate
        mov   myxx,ax
        push  bx
        call  restmouse
        mov   fontTrans,224
        mov   dx,myxx
        mov   bp,1
        mov   ax,124
        mov   cx,270
        mov   Charcol,1
        call  Writenum
        pop   dx
        cmp   dx,mylastlin
        je    nupdate1
        mov   mylastlin,dx
        mov   bp,1
        mov   ax,124
        mov   cx,293
        call  writenum
nupdate1: call  oputmouse
nupdate: ret
;----------------------------------------------------------------------------
;Procedure WriteSongInfo
;----------------------------------------------------------------------------
WriteSongInfo:
        cmp   playing,0
        jne   Yws1
        ret
yws1:   call  SongCh
        or    al,al
        jne   Yws
        jmp   chkxx
Yws:    call  RestMouse
        mov   bp,14*2
        call  PutGraph
        mov   bp,15*2
        call  PutGraph
        mov   fonttrans,0
        call  GetPSName
        mov   cx,40
        mov   di,offset songname
        mov   es,datos
        rep   movsb
        mov   ax,69 ;y
        mov   cx,0 ;x
        mov   dx,offset SongName
        mov   bp,1
        mov   Charcol,0
        call  WriteText
        call  GetPsComp
        mov   cx,40
        mov   es,datos
        mov   di,offset Composer
        rep   movsb
        mov   ax,167
        mov   cx,80
        mov   dx,offset Composer
        mov   bp,0
        mov   CharCol,37
        call  WriteText
        mov   fontTrans,224
        mov   Charcol,1
        mov   ax,123
        mov   cx,12
        mov   dl,byte ptr numorder
        mov   bp,1
        call  Writenum
        mov   ax,123
        mov   cx,35
        mov   dl,byte ptr numoftags
        mov   bp,1
        call  Writenum
        call  oputmouse
        mov   myxx,0ffffh
chkxx:  call  checkxx
        ret


;----------------------------------------------------------------------------
;Procedure Prepare filelist
;----------------------------------------------------------------------------
PrepareFileL:
        mov   NumOfFiles,0             ; Get FileNames ---> JunkSeg
        mov   FirstMusic,0
        cmp   Changedir2,1
        je    CambioDir
        cmp   CurDrive,'C'
        jnb   NoarreDr
CambioDir:
        mov   changedir2,0
        mov   NumOfTag,0
        mov   es,datos
        mov   di,offset TagList
        mov   cx,256
        xor   ax,ax
        rep   stosw
NoArreDr:
        mov   ds,datos
        mov   dx,offset DirMask
        mov   cx,10h
        mov   ah,4eh
        int   21h
        jnc   SiDir
        jmp   FilesNow
SiDir:  xor   di,di
        mov   es,JunkSeg
        jmp   short validName
DSeek:  mov   ah,4fh
        mov   cx,10h
        int   21h
        jc    NoMoreDir
validName:
        cmp   mydta+15h,10h
        jne   DSeek
CopyDirName:
        mov   si,offset DTAFile
        cmp   byte ptr [si],'.'
        jne   NormalDir
        cmp   byte ptr [si+1],'.'
        jne   DSeek
NorMalDir: mov   cx,6
        rep   movsw
        inc   NumOfFiles
        inc   FirstMusic
        jmp   DSeek
NoMoreDir:
        mov   cx,0
        mov   ds,junkseg
        mov   es,SnSeg
LeeDName: cmp cx,FirstMusic
        je    FilesNow
        push  cx
        mov   bp,cx
        mov   cs:TagList[bp],35
        mov   ax,cx
        mov   bx,12
        mul   bx
        mov   si,ax
        mov   ax,cx
        mov   bx,lgsname
        mul   bx
        mov   di,ax
        mov   cx,12
copyDN: lodsb
        or    al,al
        je    OkDFin
        stosb
        loop  copyDn
        stosb
        jmp   NMCopy
OkDfin: rep   stosb
        stosb
        stosb
NMcopy: pop   cx
        inc   cx
        jmp   leeDName
FilesNow:
        mov   ds,datos
        mov   dx,offset FileMask
        xor   cx,cx
        mov   ah,4eh
        int   21h
        jnc   noesperad
        jmp   NoFilesFound
noesperad: mov  ax,FirstMusic
        mov   bx,12
        mul   bx
        mov   di,ax
        mov   es,JunkSeg
        jmp   short copiaFName
CSeek:  mov   ah,4fh
        int   21h
        jc    NoMoreFiles
copiaFName:
        mov   si,offset DtaFile
        mov   cx,6
        rep   movsw
        inc   NumOfFiles
        jmp   CSeek

NoMoreFiles:                           ; Get SongNames ----SnSeg
        mov   cx,FirstMusic
LeeSName:
        push  cx
        mov   ax,cx
        mov   bx,12
        mul   bx
        mov   si,ax
        mov   ax,cx
        mov   bx,lgsname
        mul   bx
        mov   OffPutSName,ax
        mov   ds,junkseg
        mov   es,datos
        mov   di,offset FileSeek
        mov   cx,6
        rep   movsw
        xor   al,al
        stosb
        stosb
        push  es
        pop   ds
        mov   dx,offset FileSeek
        mov   ax,3d00h
        int   21h
        mov   bx,ax
        mov   ax,04200h
        xor   cx,cx
        mov   dx,16294+7
        int   21h
        mov   ds,snSeg
        mov   dx,OffPutSName
        mov   cx,LgSName
        mov   ax,3f00h
        int   21h
        mov   ax,3e00h
        int   21h
        pop   cx
        inc   cx
        cmp   NumOfFiles,cx
        jne   LeeSName
        clc
        ret

NoFilesFound:
        stc
        ret
;----------------------------------------------------------------------------
;Procedure WriteFileList
;----------------------------------------------------------------------------
WriteFileList:
        mov   al,Fonttrans
        push  ax
        cmp   changedir,1
        jne   NoWriteDir
        mov   charcol,0
        mov   FontTrans,0
        mov   ax,60
        mov   cx,90
        mov   dx,offset CurDrive
        mov   bp,0
        mov   bl,byte ptr [offset CurDrive+lgdir]
        push  bx
        mov   byte ptr [offset CurDrive+lgdir],'$'
        call  writeText
        pop   bx
        mov   byte ptr [offset CurDrive+lgdir],bl
        mov   changedir,0
NoWritedir: cmp   NumOfFiles,0
        jne   Sihay
        pop   ax
        ret
Sihay:
        mov   FontTrans,224
        mov   NowList,0
        mov   ax,FirstofFList
        mov   bx,lgsname
        mul   bx
        mov   si,ax
        mov   ds,snseg
        mov   es,datos
        mov   dx,FirstOfFList
otrofname:
        push  ds es
        mov   bp,dx
        mov   al,TagList[bp]
        mov   Charcol,al

        mov   di,offset FileSeek
        mov   cx,lgsname
        rep   movsb
        push  dx
        mov   ax,NowList
        mov   bx,fontal
        add   bx,1
        mul   bx
        add   ax,69
        mov   cx,89
        mov   dx,offset FileSeek
        mov   bp,0
        push  si
        call  WriteText
        pop   si
        pop   dx
        pop   es ds
        inc   Nowlist
        inc   dx
        cmp   dx,NumOfFiles
        je    nomoreList
        mov   ax,Nowlist
        cmp   ax,LongList
        jne   OtroFName
NoMoreList:
        pop ax
        mov   FontTrans,al
        ret
;----------------------------------------------------------------------------
;Procedure FileArrowUp
;----------------------------------------------------------------------------
FileArrowUp:
        cmp   FirstofFlist,0
        je    NoFUp
        dec   FirstOfFlist
        call  WriteFileList
NoFUp:  ret
;----------------------------------------------------------------------------
;Procedure FileArrowDown
;----------------------------------------------------------------------------
FileArrowDown:
        mov   ax,LongList
        add   ax,FirstOfFlist
        cmp   ax,NumOfFiles
        jnb   NoFDown
        inc   FirstOfFlist
        call  WriteFileList
NoFDown: ret
;----------------------------------------------------------------------------
;Procedure ToggleTag
;----------------------------------------------------------------------------
ToggleTag:
        mov   si,FirstOfFList
        add   si,BoxHere
        sub   si,3
        cmp   si,FirstMusic
        jb   aYesMusic
        jmp   YesMusic
aYesMusic:
        mov   ax,si
        mov   bx,12
        mul   bx
        mov   si,ax
        mov   ds,JunkSeg
        mov   es,datos
        mov   di,offset FileSeek
        mov   cx,6
        rep   movsw
        xor   al,al
        stosb
        mov   dx,offset fileseek
        push  es
        pop   ds
        mov   ah,03bh
        int   21h
Aquidir: mov   changedir,1
        mov   changedir2,1
        mov   FirstOffList,0
        mov   word ptr Curdir,0
        mov   ah,047h
        mov   ds,datos
        push  ds
        pop   es
        mov   si,offset Curdir
        push  si
        xor   dl,dl
        int   21h
        pop   si
        mov   di,offset Curdir
        mov   cx,128
CutDir: lodsb
        or    al,al
        je    YaCutDir
        stosb
        loop  CutDir
YacutDir: xor al,al
        stosb
        mov al,'$'
        stosb
        call  PrepareFileL
        call  RestMouse
        mov   bp,13*2
        call  PutGraph
        mov   bp,16*2
        call  PutGraph
        Call  WriteFileList
nolista: call  OputMouse
        mov   MousePresX,0ffffh
        ret
YesMusic:
        push  si
        add   si,offset Taglist
        mov   al,cs:[si]
        cmp   al,0
        je    TagOn
        cmp   al,1
        je    TagOn
        pop   si
        ret
TagOn:  xor   al,1
        mov   cs:[si],al
        dec   NumOftag
        cmp   al,1
        jne   noNewTag
        inc   NumOftag
        inc   NumOftag
NoNewTag:
        call  RestMouse
        call  WriteFileList
        call  OPutMouse
        mov   MousePresX,0ffffh
        pop   ax
        ret

;----------------------------------------------------------------------------
;Procedure Change Drive
;----------------------------------------------------------------------------
ccDrive: mov   cx,boxhere
        sub   cx,21
        cmp   cl,numofdrives
        jbe   drRight
        ret
DrRight:  xor   bp,bp
bprim:  cmp   Drives+bp,0
        jne   drpasar
        inc   bp
        jmp   bprim
drpasar:  inc   bp
        loop   bprim
        dec   bp
        mov   dx,bp
        add   dl,'A'
        mov   Curdrive,dl
        sub   dl,'A'
        mov   ah,0eh
        int   21h
        jmp   aquidir

;----------------------------------------------------------------------------
;Procedure OkLoad
;----------------------------------------------------------------------------
OkLoad: cmp  NumOftag,0
        je   Nadatoca
        mov  ds,datos
        mov  si,offset CurDrive
        call SetPathDir
        mov  ax,NumOfFiles
        mov  bx,12
        mul  bx
        push ax
        shr  ax,4
        inc  ax
        mov  bx,ax
        mov  ListSize,bx
;        call Allocate
        mov  ax,FilesSeg
        mov  es,ax
        mov  ds,junkseg
        xor  si,si
        xor  di,di
        pop  cx
        rep  movsb
        mov  bx,NumOfFiles
        mov  si,offset Taglist
        mov  ds,datos
        mov  cx,numoftag
        mov  bp,fileseg
        call Setlist
Nadatoca: pop ax
        jmp  exitf

;----------------------------------------------------------------------------
;Procedure AbortFileLoad
;----------------------------------------------------------------------------
AbortFileLoad:
        pop   ax
        jmp   exitF
;----------------------------------------------------------------------------
;Procedure incxx
;----------------------------------------------------------------------------
IncXX:  mov   ax,myxx
        cmp   ax,mylastlin
        je   endxx
        call  SetXX
        ret
DecXX:  mov   ax,myxx
        cmp   ax,1
        je   endxx
        dec   ax
        dec   ax
        call  setxx
endxx: ret
AdvSng: call  advxx
        ret
BackSng: call backxx
        ret

;----------------------------------------------------------------------------
;Procedure CualComF
;----------------------------------------------------------------------------
CualComF:
        mov  boxhere,255
        mov  cx,comandosF
        xor  bp,bp
        mov  ax,MousePresX
        mov  bx,MousePresY
FindBoxF: cmp  ax,BoxX1F[bp]
        jb   NoDentroF
        cmp  ax,BoxX2F[bp]
        jnb  NoDentroF
        cmp  bx,BoxY1F[bp]
        jb   NodentroF
        cmp  bx,BoxY2F[bp]
        jnb  NodentroF
        shr  bp,1
        mov  BoxHere,bp
        ret
NodentroF: inc bp
        inc bp
        loop FindBoxF
        ret

;----------------------------------------------------------------------------
;Procedure Disk Access
;----------------------------------------------------------------------------
Disco:  cmp   CurDrive,'C'
        jnb   HardDisk
        mov   bx,32
        call  allocate
        push  ax
        mov   es,ax
        xor   bx,bx
        mov   ax,0201h
        mov   dl,CurDrive
        sub   dl,'A'
        mov   dh,0
        mov   cx,1h
        int   13h
        jnc   hrDisk
        pop   es
        call  deallocate
        jmp   file_Err
hrdisk: pop   es
        call  deallocate
HardDisk:
        call  RestMouse
        mov   bp,12*2
        call  PutGraph
        mov   bp,13*2
        call  PutGraph
        mov   bp,16*2
        call  PutGraph

        mov Charcol,35
        xor  bp,bp
        mov  si,96
        mov  PicY[18*2],92
        mov  numofdrives,0
ListDr: push bp
        cmp  Drives+bp,0
        je   NoWriteDr
        mov  ax,bp
        add  al,65
        mov  WhichDr,al
        mov  dx,offset DriveLabel
        mov  ax,si
        mov  cx,190
        xor  bp,bp
        push si
        call Writetext
        mov  bp,18*2
        add  PicY[bp],12
        call PutGraph
        pop  si
        add  si,12
        inc  numofdrives
NoWriteDr: pop  bp
        inc  bp
        cmp  bp,6
        jne  ListDr

        call  OputMouse
        mov   bx,325
        call  Allocate
        mov   JunkSeg,ax
        mov   bx,325
        call  allocate
        mov   snseg,ax
        mov   changedir,1
        call  PrepareFileL
        cmp   NumOfFiles,0
        je    esperad
        call  restmouse
        call  WriteFileList
        call  oputmouse
        mov   PauseMouse,0
        mov   delayMouse,0
esperad: mov   dx,3dah
        in    al,dx
        test  al,8
        jz    esperad
esperad2: in   al,dx
        test  al,8
        jne   esperad2
        call  Outlevel
        call  GetMousePos
        call  PutMouse
        cmp   playing,0
        je    nocheck
        call  Checkxx
nocheck: cmp   ButtonPress,0
        je    NadaWaitF
        cmp   Waiting,0
        je    AtiendeF
        inc   PauseMouse
        cmp   PauseMouse,25
        jne   NadaWaitF
AtiendeF:  call  CualComF
        cmp   boxhere,255
        je    ningunboxF
        mov   bp,boxhere
        shl   bp,1
        mov   si,BoxJumpsF[bp]
        shr   bp,1
        call  si
ningunboxF:
        mov   waiting,255
        mov   BoxHere,255
        mov   PauseMouse,23
        cmp   delaymouse,0
        jne   NadaWaitF
        mov   delayMouse,1
        mov   PauseMouse,0
NadaWaitF:
        cmp   ButtonPress,0
        jne   contiespF
        mov   waiting,0
        mov   PauseMouse,0
        mov   delayMouse,0
contiespF: jmp esperad
exitF:  call  restmouse
        mov   bp,12*2
        call  Restgraph
        call  OputMouse
        mov   es,JunkSeg
        call  deallocate
        mov   es,snseg
        call  deallocate
File_err:   ret

Critical:
        test ah,128
        jne  nodiskerr
        mov  al,0
        iret
nodiskerr: db 0eah
oldint24  dw 0,0

;----------------------------------------------------------------------------
;MAIN Procedure
;----------------------------------------------------------------------------

begin:  call  initvars
espera: mov   dx,3dah
        in    al,dx
        test  al,8
        jz    espera
espera2: in   al,dx
        test  al,8
        jne   espera2
        call  Outlevel
        call  GetMousePos
        call  PutMouse
        call  WriteSongInfo
        cmp   ButtonPress,0
        je    NadaWait
        cmp   Waiting,0
        jne   Nadawait
        call  CualCom
        cmp   boxhere,255
        je    ningunbox
        mov   bp,boxhere
        shl   bp,1
        mov   si,BoxJumps[bp]
        shr   bp,1
        call  si
ningunbox: mov   MousePresX,0ffffh
        mov   MousePresy,0ffffh
        mov   waiting,255
        mov   BoxHere,255
NadaWait:  cmp ButtonPress,0
        jne    contiesp
        mov   waiting,0
contiesp: in  al,60h
        cmp  al,1
        je   esckey
        jmp  espera
esckey: call donevars
        mov  ax,4c00h
        int  21h

end begin
