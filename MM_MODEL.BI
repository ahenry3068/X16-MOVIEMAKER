' MM_MODEL.BI -- state shared between the form and the conversion engine.
' Included BEFORE the engine so every procedure can see it.
$IncludeOnce

Const MM_SPRITE = 1
Const MM_BITMAP = 2
Const MM_SECTOR = 3
Const MM_DESKTOP = 4
Const MM_VGA = 5
Const MM_AMIGA = 6

' Values worked out from the form by MM_Calc
Dim Shared M_TYPE As Integer
Dim Shared M_SEL As Integer ' resolution drop down selection
Dim Shared M_W As Long
Dim Shared M_H As Long
Dim Shared M_BITS As Integer ' 1,2,4,8 bits per pixel of the frame
Dim Shared M_CUSTOM As Integer ' a custom (expert) size is chosen
Dim Shared M_FIXED As Integer ' the frame size cannot be edited
Dim Shared M_PALVAL As Integer ' BW_MODE .. COLOR_MODE
Dim Shared M_CCHOICE As Integer ' sprite colour choice 1..6
Dim Shared M_NCOLS As Integer ' number of colours (sprite/sector 8 bit)
Dim Shared M_ERR$ ' problem found by MM_Calc

' Choices made on the form that the engine reads
Dim Shared MM_FFCOLOR As Integer
Dim Shared MM_AUDIORATE$
Dim Shared MM_AUDIOCHOICE As Integer
Dim Shared MM_ABORT_REQ As Integer
Dim Shared MM_ABORTED As Integer
Dim Shared MM_PALCHOICE As Integer
Dim Shared MM_MODE As Integer ' 0 = setup page, 1 = conversion page
Dim Shared MM_LASTTYPE As Integer
Dim Shared MM_LASTHB As Integer
Dim Shared MM_STARTED As Integer
Dim Shared MM_IN_UPDATE As Integer
Dim Shared MM_PLAYFILE$
Dim Shared MM_SRCFILE$
Dim Shared MM_RELAUNCH_FILE$, MM_FATR As Long
Dim Shared MM_DOS83OK$
Dim Shared MM_IN_FFMPEG As Integer ' an ffmpeg extraction is running
Dim Shared MM_C1FG As _Unsigned Long
Dim Shared MM_C1BG As _Unsigned Long
Dim Shared MM_C1SET As Integer
Dim Shared MM_PalVal(1 To 8) As Integer
Dim Shared MM_PalN As Integer

' Audio frame choices (sector aligned & Amiga videos)
Dim Shared MM_ANUM As Integer
Dim Shared MM_ABASE As Integer
Dim Shared MM_AFRAME(1 To 8) As Long
Dim Shared MM_ARATE(1 To 8) As Double
Dim Shared MM_APERIOD(1 To 8) As Long

' More values worked out by MM_Calc
Dim Shared M_GRAY As Integer
Dim Shared M_PSHIFT As Integer
Dim Shared M_EXT As Integer
Dim Shared M_DOJPG As Integer
Dim Shared M_DOWEBP As Integer
Dim Shared MM_EXTRAWARNED As Integer
Dim Shared M_PROMOTE As Integer
Dim Shared M_PAL24 As Integer
Dim Shared M_JPGQ$
Dim Shared M_WEBPQ$
Dim Shared MM_DESKONLY As Integer
Dim Shared MM_DESKASP As Double
Dim Shared MM_DESKAW$, MM_DESKAH$
Dim Shared MM_HEIGHTWARNED As Integer
Dim Shared MM_WLAST As Integer
Dim Shared MM_DESKWARNED As Integer
Dim Shared M_SPI As Integer
Dim Shared M_DESK As Integer ' IS_DESKTOP_ONLY once the size and depth are known
Dim Shared M_OUTSPEC As Integer
Dim Shared M_FPS$
Dim Shared M_DEFFPS$
Dim Shared M_FLIMIT As Integer
Dim Shared MM_SCALE As Single ' size of the text screens relative to the 20 pt layout
Dim Shared MM_VGALAST As Integer ' last 8 bit VGA mode chosen (1 = 13h, 2 = Mode X 200, 3 = Mode X 240)
Dim Shared MM_BITSEL As Integer ' bits per pixel chosen with the radio buttons (1, 2, 4, 8)
Dim Shared MM_LINKBUSY As Integer
Dim Shared MM_CROPSEL As Integer ' crop choice captured before the page switch
Dim Shared MM_CROPUW As Integer ' crop list currently has the ultra wide entry
Dim Shared M_BIGW As Integer ' sector 4 bit bumped to 640 wide
Dim Shared M_SECTSEL As Integer ' sector choice after the color count remap
Dim Shared M_FPSEDIT As Integer ' the frame rate may be typed
Dim Shared M_SPIOK As Integer ' sprite size is valid for sector alignment
Dim Shared M_SIZELIMITS$
Dim Shared MM_AIDX(1 To 8) As Integer
Dim Shared MM_ADEF As Integer
Dim Shared MM_AFORCE_STEREO As Integer

' command line (kept as optional presets)
Dim Shared GOT_A_COMMAND_FILE As Integer
Dim Shared CFILE_NUMBER As Integer
Dim Shared GOT_A_COMMAND_FOLDER As Integer
Dim Shared CDIR_NUMBER As Integer
Dim Shared ExitSignal As Integer
Dim Shared MM_STARTCLK$
Dim Shared MM_ENDCLK$
Dim Shared MM_LASTPROGRESS As Double
Dim Shared MM_FASTUSE As Integer 
