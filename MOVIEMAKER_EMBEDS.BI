$Embed:'./co_done.mp3','donesnd'
$Embed:'./piccap.mp3','capsnd'
$Embed:'./error3.mp3','errorsnd'
$Embed:'./beep1.ogg','plainbeep'
$Embed:'./FILMREEL.ICO','filmicon'
$Embed:'./mjpeg2.png','mjpegimg'
$Embed:'./webp2.png','webpimg'
$Embed:'./ffhdr.png','ffhdr'
$Embed:'./test1bpp.bmp','testIMG1BPP'
$Embed:'./PLAYSPV.EXE','DOSPLAYER'


' $Embed:'./SPL.TTF','myfont'
$Embed:'./SPL.TTF','myfont'
$Embed:'./3270con.ttf','vicfont'

' $Embed:'./STD-TEMPLATE.PRG','x16player'
' $Embed:'./SPI-TEMPLATE.PRG','spiplayer'
$Embed:'./VIDPLAY-TEMPLATE.PRG','x16player'
$Embed:'./PLAYPARTS.PRG','partplayer'

Dim Shared ERROR_BEEP As Long
Dim Shared BEEP1 As Long
Dim Shared CAP_SND As Long
Dim Shared VID_FINISHED_SND As Long

ERROR_BEEP = _SndOpen(_Embedded$("plainbeep"), "MEMORY")
BEEP1 = _SndOpen(_Embedded$("errorsnd"), "MEMORY")
CAP_SND = _SndOpen(_Embedded$("capsnd"), "MEMORY")
VID_FINISHED_SND = _SndOpen(_Embedded$("donesnd"), "MEMORY")

_SndVol ERROR_BEEP, 1
_SndVol CAP_SND, 1
_SndVol VID_FINISHED_SND, .3

Dim Shared Myfont&
Dim Shared VICFNT As Long
Myfont& = _LoadFont(_Embedded$("myfont"), 20, "MEMORY|MONO")
VICFNT = _LoadFont(_Embedded$("vicfont"), 20, "MEMORY|MONO|BOLD")

Dim Shared AppIcon&
Dim Shared FFHdr&
Dim Shared MJPGPic&
Dim Shared WEBPPic&
Dim Shared TestIMG&

TestIMG& = _LoadImage(_Embedded$("testIMG1BPP"), 257, "MEMORY")

AppIcon& = _LoadImage(_Embedded$("filmicon"), 32, "MEMORY")
FFHdr& = _LoadImage(_Embedded$("ffhdr"), 32, "MEMORY")
MJPGPic& = _LoadImage(_Embedded$("mjpegimg"),,"MEMORY")
WEBPPic& = _LoadImage(_Embedded$("webpimg"),,"MEMORY")
If AppIcon& < -1 Then _Icon AppIcon&
