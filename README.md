# FSTR - FAC SoundTracker Replayer

This is a player for MSX FAC Soundtracker files on MS-DOS Computer.
FSTR was released in 1994. The code is published only for historic reasons.

The published binary can be find here:
http://www.msxarchive.nl/pub/msx/utils/othersys/

Following is the original README file. For preserveration, the text is conserved as-is, no evident corrections to grammar problems will be done.

```
FAC Soundtracker Replayer for PC compatibles.

Overview:
      This is a program that  lets you hear FAC SoundTracker  MUS files on any
PC compatible with an AD-LIB or 100% compatible sound card.

System Requirements:

      - 286 or higher processor
      - VGA card
      - AD-LIB or 100% compatible sound card.
      - 95 kb of free memory.

How I use it?
      The management  of this program is quite easy. No command parameters. No
complicated menues etc.
      To start it you must type FSTR at the command prompt and then a graphics
display will be shown at front of you.
      The screen looks like this

              |---------------------------------------|
              |---------------------------------------|

               |----|          |-----|         |-----|
               | A  |          |  B  |         |  C  |
               |----|          |-----|         |-----|

               |---|  |-----------------------|  |---|
               | D |  |                       |  | F |
               |---|  |           E           |  |---|
                      |                       |
               |---|  |                       |  |---|
               | G |  |                       |  | H |
               |---|  |-----------------------|  |---|

      Here you got some icons that represent  the actions that you can do. All
you have  to do is place  the cursor  above  any of them  and press the  mouse
button or the space bar if you are using the keyboard.
      Now, here's the explanation of what they mean.

A.  Audio.
      With this icon  you can turn all  the melody channels  on or off and let
only the drums channels sound.

B.  File Access
      Pointing here will display a File selection box from where you can search
and load any song (*.mus), or select a song list.
      When you choose a song, its name will be highlighted (note that the list
contains the song name  and not the file  name). Also you can select more than
one song and they will be played continuously.

C.  Drums
      From this  you can select  9 melody  channels or 6 melody channels and 5
channels  for drums (they  are really 3 pairs  of modulators, but  we can play
5 different sound at the same time).
      This  button hasn't the same effect that turning the channels 7 to 9 off
because  there are music  that uses 9  melody channels + 1 drum channel, so if
you turn drums off you will hear all 9 channels playing the melody.

D.  Shell
      This is the interesting part, and the one who cause me a lot of pain and
suffering.
      When I start  this proyect I thought in  a little program  to play *.MUS
files,  but as  the time pass  I realize that  watching a screen  that doesn't
change in a long period of time is very boring. So what about placing the music
on  the background while using a text editor, or other process that requires a
few of the system power. And yeah... the word 'shell' appear on my eyes.
      The problem was that  the musics are  very short  (at least the musics I
used developing this program), and  it isn't very  comfortable exiting from an
aplication only to change the song. The solution was the file list.
      Now the problem was that it  isn't convenient to  load all the  songs of
the list in memory, why don't load only the song that I want to play. But there
will be a conflict if  the disk is currently accesed! :-(. Finally after  many 
hours of hard debugging I get this idea working hapily :-)

E.  Peak Meter
      From this section you can turn any of the nine channels on or off.

F.  Quit
      Push here when you want to return to the silent world.

G.  Song List Position.
      If you want to hear  the last song again or send to hell the actual song
you can use this.

H.  Song Pattern Position.
      Using this you can advance or go back within a song. 
      
     Finally I want to warning you that YOU ARE USING THIS PROGRAM AT YOUR OWN
RISK, IF YOUR COMPUTER SYSTEM OR YOUR EARS GET DAMAGED FOR ANY REASON, I'M NOT
RESPONSABLE. THIS IS A BETA VERSION.

-----------------------------------------------------------------------------
Read this section if you are a coder, musician or a simple curious guy.

History.

     I began this proyect when I saw that exist  many *.MUS files with amazing
names and  because I love music, then  I don't hesitate about  writing a *.MUS
player for my computer (PC).
     This was necesary beacause here on Chile there are few MSX machines,three
of my friends have  one and only  with PSG chips. So,  experimenting with some
MUS files in TP I found a  relationship between them,  and 3 days later, I got
the replaying routine working but  without the drum  channels, because this is
the first  time  I did a program  that uses my sound  card. The next  step was
imagine how  did the drum part of the file works, and how to program the drums
on the sound card.
     The first part  takes me about 1 day  to determine  which sounds mean the
codes in the file, but learning  to program  the drums and  obtaining a decent
sound took me a bigger time.
     One week after I  finished the replaying  part which runned  with a black
screen and it was computer speed dependant.
    I hadn't all my time free, because I have to study too. A period of finals
exams at Univerity came and the proyect was delayed. When this  period end, it
took me a  lot of time  to return  to code because  I was working in, at first
look, small programs that stealed me a lot of time.
     When I get back on FSTR I pass for many problems because I wanted a small
program (<10 kb long) made 100% in Assembly language. You can ask why not in C 
or TP,my answer is that C requires about 15Mb of disk space and it doesn't fit
on my HD, in  the other hand TP is  a nice language but  the compiled programs
include info that make the program grow. Also I choose assembler because it is
the only language that I know what does exactly happen with my code.
     It took me many hours learning how to do many things that I was used to do
with high level languages. One day I worked many hours and the coding was very
successful, the program was running with many of the facts I want to. Then,
when  I gone  to bed I made  a back up of all the work,  but instead of moving
the files  from  the working  to the back up  directory, I did it from the old
files overwriting the new files, so  all the work was lost and with that files
I lost my patience and my brain :-(
     With that accident on my back, I got up again and re-coded all the program
again but new stranges bug's appear. And finally,  2 months later I killed the
last bug (I think) and the program is ready for your use.

Observations.

     - MUS  file  format was  created by FAC  on the  MSX systems. I 've never
       heared a MUS song on a MSX computer, the replaying routine was developed
       testing and hearing what happened. I wrote an article on the MSX mailing
       list  (msx@stack.urc.tue.nl) if  somebody could help  me  with  the  MUS 
       format, but nobody respond  me. If you think  that you can  help me with 
       it, I will be very grateful and I promise that I will do the corrections 
       on the next version. See at the end of this TXT for contacting me.
     - This program was made for my own use, but I believe in Public Domain so
       we all can enjoy the creations  of each others. I  code because I  love
       coding (and girls of course), f*ck you business only coders.
     - For now I can't play musics beacause I sold my sound card, I think that
       the next version  could have 9 melody channels and 1 drum channel using
       a Sound Blaster DAC for the drums, also if you help me I can improve the  
       replaying routine to support effects (I still don't know what does some 
       of the codes mean).
     - The system requirements  says 95 Kb, but if you start using buttons the
       program needs more memory.
     - As you can see, using shell will reserve about 13 kb for code 16 kb for
       song and 6 kb for file list #|->.
     - Don't use directories full of musics because I don't check the limit of
       files (about 500 files)
     - On my country we read FAC as f*ck O:-)
     - If  your song  doesn't  sound  correctly  read the first  topic on this
       section.
     - If using the  shell and when  FSTR tries  to  load one song  the system
       crashes, you have to select only one song and not a song list.
     - Sorry by my poor english but I think if I write in  spanish many of you
       will not understand me.
     - Don't look at the code, it's very ugly, most of it is midnight code.
     - I don't know if the video and CPU detection works because I couldn't
       find any computer with less than VGA & 286.
     - I include the song  desert-dessert by  E.J. Schuller  if you don't have 
       any song.  I found it  in the  file  UNICORN.LZH  in /pub/msx/music  at 
       nic.funet.fi.

Acknowlegments

     -  Borland International. There's no one best than them. ;^)
     -  Jeffery Lee for the info on  FM-chips programming  (What happened with
        the drums?)
     -  David Jurgens for his HELP PC.

Greetings

     -  MSX & PC freaks  all over the  world. MCX (Max Celedon), some day I'll
        finish your PSG sound routine for VDPower, and when do you will finish
        it?. Luis Cueto (Thank you  for the internet access, I believe you can
        finish your career if you set it as a goal). JHM & CHM (Creators of
        the Spectrum emulator on MSX). Javier Gutierrez (Yeah, cool guy).
        Fernando Diaz. (get ready for xCommand)
     

Contacting with the author.

     E-Mail  hydefus@inf.utfsm.cl (MCX account) 
             or i5esp101@loa.disca.utfsm.cl. This last only until November '94

     Phone   +56 32 944871 (only if you speak spanish)

     Snail Mail      Eucaliptus 386  5§ sector Belloto Sur
                     Quilpu‚, V regi¢n 
                     Chile.

     All of them must be directed to Franco Catrin. 


                                               F.Catrin '94
```
