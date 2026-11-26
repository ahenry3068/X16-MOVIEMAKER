' MM_GLOBALS.BI -- the global variables and constants of the converter engine
' ---------------------------------------------------------------------------
'  PARALLEL FRAME CONVERSION  (ImageMagick path only)
'  How many frames may be converting at the same time.  The frame being
'  processed plus the next MAGICK_PARALLEL-1 frames are always in flight.
'  1 = the old behavior (one frame at a time, no background jobs).
'  Does not apply to FAST (QB64) loading, MJPG or the CX16 image tool.
' ---------------------------------------------------------------------------
Dim Shared MAGICK_PARALLEL As Long
MAGICK_PARALLEL = THREAD_DEFAULT ' only a starting value, LOAD_THREAD_CONFIG sets the real one
Const MAX_PIPE_THREADS = 64
Const THREAD_CFG_NAME$ = "mm.threads.cfg" ' lives beside mm.run.cnt
Const MAGICK_TIMEOUT = 90 ' seconds to wait on one frame before redoing it directly
Const MM_VERSION$ = "2.0"
Dim Shared SAFEKILL_FAILED As Integer
Dim Shared PIPE_ANY_OK As Integer ' has any background frame finished yet this run
Dim Shared CX16_PRERUN As Integer ' cximg2bin already ran for this frame (background job)
Dim Shared PIPE_ON As Integer
Dim Shared PIPE_NEXT As Long ' next frame number to launch
Dim Shared PIPE_FIRST As Long
Dim Shared PIPE_END As Long
Dim Shared PF_ON As Integer ' the pre-filter only background pipeline is running (paths without the conversion pipeline)
Dim Shared PF_FIRST As Long
Dim Shared PF_NEXT As Long
Dim Shared PF_END As Long
Dim Shared PIPE_CUR As Long ' frame being loaded right now
Dim Shared PIPE_FAST As Integer ' the pipeline runs the FAST loading helper instead of ImageMagick
Dim Shared PIPE_DBGCMD$ ' the command line of the first helper job (for error reports)
Dim Shared FAST_HELPER$ ' full path of the helper program
Dim Shared FAST_HELPER_FILE$ ' when set, QB_LOADIMAGE_DATA reads this helper result
Dim Shared FAST_PAL(0 To 255) As Long


' THIS BLOCK OF VARIABLES IS FOR
' AMIGA VIDEO CONVERSIONS
Const AMIGA_VTYPE = 199
Dim Shared ENABLE_AMIGA As Integer
ENABLE_AMIGA = _FALSE
Dim Shared FOR_AMIGA As Integer
FOR_AMIGA = _FALSE
Dim Shared AMIGA_PAL As Integer
Dim Shared AMIGA_PERIOD As Long
Dim Shared AMIGA_RATE As Double



Const AMI_CLOCK_NTSC# = 3579545.45
Const AMI_CLOCK_PAL# = 3546894.6
Const AMI_MIN_PERIOD = 124


' THIS BLOCK OF VARIABLES IS FOR MS-DOS
' VIDEO VGA CONVERSIONS
Const VGA_VIDEO_TYPE = 86
Const VGA_X_TYPE = 88
' VGA 16 color is VTYPE 88 with header BPP = 4: 4 bit planar frames (EGA mode 0Dh layout) + 16 palette entries of 6 bit R,G,B

Dim Shared ENABLE_VGA As Integer
Dim Shared FOR_VGA As Integer
Dim Shared DO_JPG As Integer
Dim Shared DO_WEBP As Integer
Dim Shared JPG_QUAL$
Dim Shared WEBP_QUAL$
Dim Shared JPG_FRAMETOTALSIZE As _Unsigned _Integer64
Dim Shared JPG_IMAGE As Long


Dim Shared GO_DESKTOP_VIDEO As Integer
GO_DESKTOP_VIDEO = _FALSE
Dim Shared FULL_24BIT_PALETTE As Integer
Dim Shared OUT_OF_X16SPEC As Integer
Dim Shared VGA_MODEX As Integer
Dim Shared VGA_13H As Integer
FOR_VGA = _FALSE
VGA_MODEX = _FALSE
VGA_13H = _FALSE
Dim Shared VGA_16C As Integer ' VTYPE 88 with BPP 4, a sub type of the VGA choice (FOR_VGA is also true)
Dim Shared VGA16_BARS As Integer ' picture shorter than the screen: palette index 0 is kept black for the bars
VGA_16C = _FALSE
VGA16_BARS = _FALSE

ReDim Shared QBUFF1(0 To 2) As _Unsigned _Byte
ReDim Shared QBUFF2(0 To 2) As _Unsigned _Byte
ReDim Shared QBUFF3(0 To 2) As _Unsigned _Byte
ReDim Shared QBUFF4(0 To 2) As _Unsigned _Byte
Dim Shared QBUFFSIZE As _Unsigned Integer


Type J_HDRTYPE
    ID As String * 2
    SIZE As Long
End Type

Dim Shared JPEG_HEADER As J_HDRTYPE
JPEG_HEADER.ID = "jp"


Type VGAPAL_TYPE
    R As _Unsigned _Byte
    G As _Unsigned _Byte
    B As _Unsigned _Byte
End Type

Dim Shared VGA_PALETTE(0 To 255) As VGAPAL_TYPE
' END VGA VIDEO VARIABLE BLOCK.

Dim Shared VIDEO_IS_PREPADDED As Integer
VIDEO_IS_PREPADDED = _FALSE

Dim Shared StartTime As Double
Dim Shared EndTime As Double
Dim Shared ConversionTime As Double

Dim Shared LEFT_PARSE$
Dim Shared RIGHT_PARSE$

Dim Shared MY_POP_DIR$
Dim Shared I_FOUND_MYSELF As Integer
Dim Shared MY_NAME$

Dim Shared MY_PATH$
Dim Shared CX16_IMGCMD$
Dim Shared CMD_EXTRA$
Dim Shared CX16_IMG_AVAILABLE As Integer
Dim Shared CX16_IMG_MODE As Integer
Dim Shared USE_YOLO As Integer


MY_NAME$ = Command$(0)
I_FOUND_MYSELF = _FileExists(MY_NAME$)

If InStr(MY_NAME$, Chr$(32)) > 0 Then
    MY_NAME$ = Chr$(34) + MY_NAME$ + Chr$(34)
End If

MY_POP_DIR$ = _CWD$
ChDir _StartDir$

Type SVIDHeaderType
    ID As String * 4
    VTYPE As _Unsigned _Byte
    BPP As _Unsigned _Byte
    FPS As _Unsigned _Byte
    SpriteWidth As _Unsigned _Byte
    SpriteHeight As _Unsigned _Byte
    FrameWidth As _Unsigned Integer
    FrameHeight As _Unsigned Integer
    NumFrames As _Unsigned Long
    HINT As String * 1
    VeraRATE As _Unsigned _Byte ' Not necessary for vids with a seperate audio file
    AudFrmSize As _Unsigned Integer
    XAUD_FLAG As String * 1
    XAUD_BYTE As _Unsigned _Byte
    F_FPS As _Unsigned Integer
    EXTRA As String * 6
    PALTAG As String * 1
End Type

Type MovieType
    XRes As Integer
    YRes As Integer
    HINT As String * 1
End Type

Type BMPHeaderType2
    id As String * 2 'Should be "BM"
    size As Long 'Size of the data
    rr1 As Integer '
    rr2 As Integer '
    offset As Long 'Position of start of pixel data
    horz As Long '
    wid As Long 'Image width
    hei As Long 'Image height
    planes As Integer '
    bpp As Integer 'Should read 8 for a 256 colour image
    pakbyte As Long '
    imagebytes As Long 'Width*Height
    xres As Long '
    yres As Long '
    colch As Long '
    ic As Long '
End Type

Type BPalType
    B As _Unsigned _Byte
    G As _Unsigned _Byte
    R As _Unsigned _Byte
    A As _Unsigned _Byte
End Type

Type BMPHeaderType
    id As String * 2 'Should be "BM"
    size As Long 'Size of the data
    rr1 As Integer '
    rr2 As Integer '
    offset As Long 'Position of start of pixel data
    horz As Long '
    wid As Long 'Image width
    hei As Long 'Image height
    planes As Integer '
    bpp As Integer 'Should read 8 for a 256 colour image
    pakbyte As Long '
    imagebytes As Long 'Width*Height
    xres As Long '
    yres As Long '
    colch As Long '
    ic As Long '
    pal As String * 1024 'Stored as &amp;lt;Blue, Green, Red, 0&amp;gt;
End Type

Type VPALTYPE
    GB As _Unsigned _Byte
    R As _Unsigned _Byte
End Type

Type AMI_PALTYPE
    R As _Unsigned _Byte
    GB As _Unsigned _Byte
End Type

ReDim Shared AMIGAPAL(0 To 1) As AMI_PALTYPE


Dim Shared VERA_CUSTOM_FG As VPALTYPE
Dim Shared VERA_CUSTOM_BG As VPALTYPE


DEPENDENCIES:
Data "ffmpeg","ffprobe"
$If WINDOWS Then
    Data "magick"
$Else
    Data "convert"
$End If
Data "DONE"

DEPTITLES:
Data "ffmpeg ","ffprobe","ImageMagick"

DEPURLS_DOWNLOAD_PAGE:
Data "https://ffmpeg.org/download.html","https://ffmpeg.org/download.html","https://legacy.imagemagick.org/script/download.php"

DEPURLS_HOMEPAGE:
Data "https://www.ffmpeg.org","https://www.ffmpeg.org","https://imagemagick.org/index.php"

RES_CHOICES:
Data 160,112,192,128,96,160,80,144,320,112,320,88,224,112,224,196

Choice_Hints:
Data "N","N","T","T","D","D","D","D"


IMMORTAL_PALETTE:
Data 0,0,255,15,0,8,254,10,76,12,197,0,10,0,231,14,133,13
Data 64,6,119,15,51,3,119,7,246,10,143,0,187,11,0,0,17,1
Data 34,2,51,3,68,4,85,5,102,6,119,7,136,8,153,9,170,10
Data 187,11,204,12,221,13,238,14,255,15,0,0,0,3,0,4,0,5
Data 17,6,17,8,34,9,34,10,34,12,68,13,102,13,136,13,170,14
Data 187,14,204,14,255,15,0,0,16,3,32,4,49,5,65,7,82,8
Data 82,10,82,11,98,12,116,13,134,13,168,13,186,14,203,15,220,15
Data 255,15,0,0,32,3,48,4,65,5,81,7,97,8,114,9,130,10
Data 162,12,181,13,198,14,216,14,234,15,235,15,236,15,255,15,0,0
Data 48,3,64,4,81,5,97,6,113,7,146,9,162,10,194,12,213,13
Data 215,13,216,13,234,14,235,14,236,14,255,15,0,0,48,2,64,2
Data 81,3,113,4,129,5,146,5,162,6,194,7,212,8,214,9,216,10
Data 233,11,235,12,236,13,255,15,0,0,48,0,65,0,81,1,113,1
Data 130,2,147,2,163,2,196,2,213,4,215,6,217,8,234,10,235,11
Data 236,12,255,15,0,0,49,0,66,0,83,1,116,1,133,1,149,2
Data 166,2,199,1,216,4,217,6,218,8,235,9,236,11,237,12,255,15
Data 0,0,51,0,68,0,85,1,119,1,136,1,153,2,170,2,204,2
Data 221,4,221,6,221,8,238,9,238,11,238,12,255,15,0,0,19,0
Data 36,0,53,0,71,1,88,1,105,2,106,2,124,2,141,5,157,6
Data 173,8,190,10,206,11,222,12,255,15,0,0,3,0,4,1,5,2
Data 23,2,40,2,41,3,42,3,44,4,92,5,109,7,141,9,174,10
Data 190,11,206,12,255,15,0,0,3,0,4,1,21,2,23,3,25,4
Data 42,5,43,6,44,7,77,8,109,9,141,10,174,11,190,12,206,13
Data 255,15,0,0,3,2,4,3,21,4,23,5,24,6,41,7,42,8
Data 44,9,77,10,109,10,141,11,174,12,190,13,206,14,255,15,0,0
Data 2,3,3,4,20,5,21,7,37,8,38,9,39,10,41,12,74,13
Data 106,13,139,13,172,14,188,14,205,14,255,15,0,0,0,0,0,0
Data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Data 0,0,0,0,0,0,0,0

VERA_DEFAULT:
Data 0,0,255,15,0,8,254,10,76,12,197,0,10,0,231,14,133,13,64,6,119,15,51,3,119,7,246,10,143,0,187,11
VERA_GRAY:
Data 0,0,17,1,34,2,51,3,68,4,85,5,102,6,119,7,136,8,153,9,170,10,187,11,204,12,221,13,238
Data 14,255,15,17,2,51,4,68,6,102,8,136,10,153,12,187,15,17,2,34,4,51,6,68,8,85,10,102,12,119,15,0,2,17,4,17,6,34,8,34,10,51,12,51,15,0,2,0,4,0,6,0,8,0,10,0,12,0,15,33,2,67,4,100,6,134,8
Data 168,10,201,12,235,15,17,2,50,4,83,6,116,8,149,10,182,12,215,15,16,2,49,4,81,6,98,8,130,10,163,12,195,15,16,2,48,4,64,6,96,8,128,10,144,12,176,15,33,1,67,3,100,5,134,7,168,9,201,11,251
Data 13,33,1,66,3,99,4,132,6,165,8,198,9,247,11,32,1,65,2,97,4,130,5,162,6,195,8,243,9,32,1,64,2,96,3,128,4,160,5,192,6,240,7,33,1,67,3,101,4,134,6,168,8,202,9,252,11,33,1,66,2,100,3,133
Data 4,166,5,200,6,249,7,32,0,65,1,98,1,131,2,164,2,197,3,246,3,32,0,65,0,97,0,130,0,162,0,195,0,243,0,34,1,68,3,102,4,136,6,170,8,204,9,255,11,34,1,68,2,102,3,136,4,170,5,204,6,255,7,34
Data 0,68,1,102,1,136,2,170,2,204,3,255,3,34,0,68,0,102,0,136,0,170,0,204,0,255,0,18,1,52,3,86,4,104,6,138,8,172,9,207,11,18,1,36,2,70,3,88,4,106,5,140,6,159,7,2,0,20,1,38,1,56,2,74,2,92
Data 3,111,3,2,0,20,0,22,0,40,0,42,0,60,0,63,0,18,1,52,3,70,5,104,7,138,9,156,11,191,13,18,1,36,3,54,4,72,6,90,8,108,9,127,11,2,1,20,2,22,4,40,5,42,6,60,8,63,9,2,1,4,2,6,3,8,4,10,5,12,6
Data 15,7,18,2,52,4,70,6,104,8,138,10,156,12,190,15,17,2,35,4,53,6,71,8,89,10,107,12,125,15,1,2,19,4,21,6,38,8,40,10,58,12,60,15,1,2,3,4,4,6,6,8,8,10,9,12,11,15

SPRITE_MENU_BOXES:
Data 71,145,350,185
Data 71,210,350,250
Data 71,272,350,325
Data 71,350,350,415
Data 96,494,348,506
Data 96,528,348,540
Data 96,560,348,572
Data 96,592,348,602
Data 65,640,510,716

BITMAP_MENU_BOXES:
Data 70,145,364,185
Data 70,210,364,266
Data 70,290,364,330
Data 70,370,364,410
Data 70,450,364,490
Data 64,575,510,650

SECTOR_MENU_BOXES:
Data 72,161,292,203
Data 72,225,292,267
Data 72,289,292,331
Data 72,353,292,395
Data 72,417,292,459
Data 72,481,292,523

Dim Shared DITH_STR As String
Dim Shared CUSTOM_DITHER As Integer
Dim Shared USER_CHOSEN_DITHER As Integer

CUSTOM_DITHER = _FALSE
USER_CHOSEN_DITHER = _FALSE
Dim Shared IN_STD_BITMAP As Integer
Dim Shared IN_STD_SPRITE As Integer
Dim Shared IN_SPI_BITMAP As Integer
Dim Shared IN_SPI_SPRITE As Integer

Dim Shared NO_LIMITS As Integer
Dim Shared IS_DESKTOP_ONLY As Integer
Dim Shared WANT_A_TALLVIDEO As Integer
Dim Shared K_TYPE As Integer
' keep original aspect (HINT "A" scheme), see MM_ASPECT.BM
Const ASP_N_LO = 1.28
Const ASP_N_HI = 1.4
Const ASP_W_LO = 1.7
Const ASP_W_HI = 1.9
Const ASP_K_LO = 0.5
Const ASP_K_HI = 0.6
Dim Shared KEEP_ASPECT As Integer
Dim Shared ASPECT_A As Integer
Dim Shared ASPECT_VAL As Double
Dim Shared ASPECT_NOTE$
Dim Shared ASPECT_WARN$
Dim Shared SKIP_DEP_CHECKS As Integer

Dim Shared IN_CRITICAL_SECTION As Integer
IN_CRITICAL_SECTION = _FALSE

Dim Shared DoGreen As Integer
Dim Shared DoAmber As Integer

Dim Shared Src_Width As Double
Dim Shared Src_Height As Double
Dim Shared Src_Aspect As Double
Dim Shared WIDE_DISPLAY As Integer
Dim Shared Use16BitAudio As Integer
Dim Shared WantsPreview As Integer
Dim Shared ImageWidth As Long
Dim Shared ImageHeight As Long
Dim Shared SprWidth As Integer
Dim Shared SprHeight As Integer
Dim Shared Palsize As Integer
Dim Shared TRUE_FPS As Double
Dim Shared UsedCols$
Dim Shared MovieName$
Dim Shared MovieFPS$
Dim Shared BytesPerFrame As _Unsigned Long
Dim Shared FRAME_SIZE As _Unsigned Long
Dim Shared FRAMERATE_IS_SET As Integer
FRAMERATE_IS_SET = _FALSE

Dim Shared USE_QB64FASTMODE As Integer
USE_QB64FASTMODE = _FALSE

Dim Shared MainLFN As Long
Dim Shared BASENAME$
Dim Shared TName$
Dim Shared TPath$
Dim Shared DName$
Dim Shared HomeDir$

Dim Shared EXTRA_CONVERT_MSG$
Dim Shared EXTRA_CONVERT_MSG_T$
EXTRA_CONVERT_MSG$ = ""
EXTRA_CONVERT_MSG_T$ = ""

' Variables for Color Counting.
Dim Shared COLOR_IS_USED(0 To 255) As Integer
Dim Shared SWAP_REMAP(0 To 255) As _Unsigned _Byte ' deferred index remap built by SwapPaletteColors
Dim Shared SWAP_PENDING As Integer
Dim Shared NUMBER_OF_USED_COLORS As Integer
Dim Shared PALETTE_IS_PACKED As Integer

'  Variables to help Split up an Output Movie that is larger
'  Than 4gb in size.   (not yet implemented !)
' Dim Shared MOVIE_TOTAL_FRAMES As _Integer64
Dim Shared SPV_TOTAL_SIZE As _Unsigned _Integer64
Dim Shared FRAME_TOTAL_SIZE As _Unsigned _Integer64
Dim Shared AUDIO_TOTAL_SIZE As _Unsigned _Integer64
Dim Shared TOTAL_PALETTE_SIZE As _Unsigned Long
Dim Shared TARGET_PART_SIZE As _Unsigned _Integer64
Dim Shared DO_PART_VIDEO As Integer
Dim Shared NUMBER_OF_PARTS As Integer
Dim Shared CURRENT_PART As Integer
Dim Shared CURRENT_PART_FRAME As _Unsigned Long

Dim Shared CURRENT_OUTSPV$

Dim Shared PWindowX%
Dim Shared PWindowY%

Dim Shared FRAMES_PER_PART As Long
Dim Shared TRAILING_FRAMES As Long

Dim Shared VIDEO_DATA_RATE As Long
Dim Shared AUDIO_DATA_RATE As Long
Dim Shared TOTAL_DATA_RATE As Long
Dim Shared PCM_BYTERATE
Dim Shared REAL_FPS As Double

Const CROP4.3 = 1%
Const CROP16.9 = 2%
Const LETTERBOX = 3%

Const GIGA&& = 1000000000
Const DGIGA&& = GIGA * 2&&
Const HGIGA&& = GIGA \ 2
Const MAX_MOVIE_BYTES&& = 4000000000

Dim Shared MY_INSTALL_DIR$

$If WINDOWS Then
    Dim Shared OldDir$
    Dim Shared OldRoot$
$End If

Dim Shared ProjectHome$
Dim Shared Slash$

Dim Shared SUCCESS As Integer
Dim Shared NEW_VIDEO_PROJECT As Integer
Dim Shared USE_EXISTING_FRAMEFOLDER

Dim Shared GOT_EXISTING_AUDIO
Dim Shared VIDEO_TITLE_FOR_EXISTING$

Dim Shared NEW_TARGET_FOLDER$
Dim Shared TARGET_FOLDER$

Dim Shared FIRST_FRAME$
Dim Shared FRAME_FOLDER$

Dim Shared SRC_AUDIOFILE$

Dim Shared DO_USE_FASTENCODING As Integer
DO_USE_FASTENCODING = _FALSE

Dim Shared SAVE_CUSTOM_BMP As Integer
Dim Shared Use_EMBEDDED_FramePalette As Integer
Dim Shared EXT_PALETTE_ON As Integer
Dim Shared EXT_PALETTE_METHOD As Integer
Dim Shared SKIP_OVER_DISPLAYPAL_UPDATE As Integer
Dim Shared EXT_UPPER_COLOR As Integer
Dim Shared EXT_OFFSET As Integer
EXT_PALETTE_ON = _FALSE

Dim Shared EXTPAL_FILEERROR As Integer

Dim Shared MAP_BMPFILE_NAME$

Dim Shared Make4BPP_VIDEO As Integer
Dim Shared GrayScaleVideo As Integer

Dim Shared UseDither As Integer

Dim Shared PALETTE_SHIFTING_ENABLED As Integer

Dim Shared MY_DISPLAY As Long

Dim Shared FormatChoice
Dim Shared BitMapChoice
Dim Shared Wipe_TMP_Files
Dim Shared Bit_Map_Mode
Dim Shared ReturnChoice
Dim Shared EXPERT_MODE
Dim Shared ExtraMagick$
Dim Shared V_PADSIZE As _Unsigned Long
Dim Shared DoPadFrame

Dim Shared GO_BITMAP As Integer
Dim Shared GO_SPRITE As Integer
Dim Shared VIDEO_IS_PICKED As Integer
Dim Shared GOT_FRAMES_FOLDER As Integer
VIDEO_IS_PICKED = _FALSE
GOT_FRAMES_FOLDER = _FALSE

' The ImageMagick command.  Windows: magick.  Linux/Mac: convert (ImageMagick 6 and 7 with the
' legacy links), else magick when that is the only one installed (ImageMagick 7 without "convert").
Dim Shared Magick$
Magick$ = MM_MagickCmd$

Dim Shared wid
Dim Shared hei
Dim Shared Show&, Show2&
Dim Shared sizex_bpp
Dim Shared DO_SWAP_1BPP As Integer
Dim Shared Percentage As Single

Dim Shared RUN_PRE_FILTER As Integer
Dim Shared PRE_FILTER_COMMAND$

ReDim Shared ImageData(1) As _Unsigned _Byte
ReDim Shared ImageDataX_BPP(1) As _Unsigned _Byte

ReDim Shared Sprite(1) As _Unsigned _Byte
ReDim Shared Sprite4BPP(1) As _Unsigned _Byte

ReDim Shared VERAPALX_BPP(1) As VPALTYPE

Const BW_MODE = 0
Const GRAY_MODE = 1
Const GREEN_MODE = 2
Const AMBER_MODE = 3
Const SINGLE_PAL_MODE = 4
Const CUST_1BPP = 5
Const COLOR_MODE = 32

Dim Shared X_BITS As Integer
Dim Shared X_PALMODE As Integer

Dim Shared VERAPAL(0 To 255) As VPALTYPE
Dim Shared VERA_DEF_GRAY(0 To 15) As VPALTYPE

Dim Shared VERAPALDEFAULT(0 To 255) As VPALTYPE
Dim Shared VERA_LOADED_PALETTE(0 To 255) As VPALTYPE
Dim Shared VERA_DEFAULT_PALETTE_EXPANDED(0 To 255) As Long

Dim Shared TARGET_PAL_FOR_MAPPING(0 To 255) As Long

Dim Shared WorkingPAL(0 To 255) As VPALTYPE
Dim Shared VERAPAL4BPP(0 To 15) As VPALTYPE

Dim Shared VERA_RATE As _Unsigned _Byte
Dim Shared ImagePalette(0 To 255) As Long
Dim Shared FrameCount As _Unsigned Long

Dim Shared FrameExt$

Dim Shared VideoHeader As SVIDHeaderType
Dim Shared MovieChoice(1 To 12) As MovieType

Dim Shared FFMPEG_ERROR As Integer
Dim Shared MAKE_SILENT_VIDEO As Integer
MAKE_SILENT_VIDEO = _FALSE
Dim Shared aframe As _Unsigned Long
Dim Shared AudioByteCount As _Unsigned _Integer64
Dim Shared AudioFileSize As _Unsigned _Integer64
Dim Shared Audio_FrameSize As Integer

ReDim Shared AudioBuffer(0) As _Unsigned _Byte

ReDim Shared BlankAudioBuffer(0) As _Unsigned _Byte

ReDim Shared PadBuffer(0 To 1) As _Unsigned _Byte
Dim Shared AudIndxLimit As Integer
Dim Shared Interleave_Audio As Integer

Dim Shared AudioLFN As Integer
Dim Shared CROP_VIDEO As Integer
Dim Shared MAKE_SECTOR_VIDEO As Integer
Dim Shared ENABLE_SPI_SPRITES As Integer
Dim Shared SECTOR_CHOICE As Integer

' Following Group of Variables are used to enable AUDIO EXTENSIONS
' For SPV files.  Default Audio Format is 8 bit signed PCM Mono
Dim Shared AUDIO_EXTENTIONS_ON
Dim Shared VERA_AUDIO_CFG As _Unsigned _Byte
Dim Shared VERA_RATE_TWEAK As _Unsigned _Byte
Dim Shared ENABLE_STEREO_PCM As Integer
Dim Shared ENABLE_16BIT_PCM As Integer

Dim Shared PCM_SAMPLESIZE As _Unsigned Integer

Dim Shared VERA_16BIT As _Unsigned _Byte
Dim Shared VERA_STEREO As _Unsigned _Byte

Dim Shared USE_VIDEO_PLAYER As Integer
Dim Shared USE_ASK_PLAYER As Integer
Dim Shared DO_PARTS_PREVIEW As Integer

Dim Shared VIDEO_PLAYER_NAME$
Dim Shared ASK_PLAYER_NAME$
Dim Shared AMIGA_PLAYER_NAME$
Dim Shared USE_AMIGA_PLAYER As Integer

Dim I As Integer
Dim TMP$
Dim CHOICE As Integer
Dim NukeIT As Integer

Dim TargetName$, CMD$
Dim MoveDName$, AudioTrackName$, PName$, SubPath$, Sub$, PDirName$, POPDIR$


VERA_16BIT = &B00100000
VERA_STEREO = &B00010000

PCM_SAMPLESIZE = 1 ' 8 bit Mono PCM Sample Size is 1 byte

AUDIO_EXTENTIONS_ON = _FALSE
ENABLE_16BIT_PCM = _FALSE
ENABLE_STEREO_PCM = _FALSE

VERA_AUDIO_CFG = _FALSE
VERA_RATE_TWEAK = 0

MAKE_SECTOR_VIDEO = _FALSE
CROP_VIDEO = _FALSE
EXPERT_MODE = _FALSE
ExtraMagick$ = ""
DoPadFrame = _FALSE
GO_BITMAP = _FALSE
AudioLFN = 10
Wipe_TMP_Files = _TRUE
Interleave_Audio = _TRUE

$If WINDOWS Then
    Slash$ = "\"
    Const NULL$ = "NUL"
    Const CopyCmd$ = "COPY "
    Const MoveCmd$ = "MOVE "
    Const MoveOverCmd$ = "MOVE /Y "
    Const SystemOpen$ = "START "
    OldRoot$ = _Dir$("APPDATA")
    OldRoot$ = Left$(OldRoot$, (Len(OldRoot$) - 1))
    OldDir$ = OldRoot$ + Slash$ + "x16vidprojects"
    HomeDir$ = _Dir$("DOCUMENTS")
    HomeDir$ = Left$(HomeDir$, (Len(HomeDir$) - 1))
    Const NukeDir$ = "RMDIR /s /q "
$Else
    Slash$ = "/"
    Const NULL$ = "/dev/null"
    Const CopyCmd$ = "cp "
    Const MoveCmd$ = "mv "
    Const MoveOverCmd$ = "mv -f "
    HomeDir$ = Environ$("HOME")
    Const NukeDir$ = "rm -rf "
    $If MAC Then
       Const SystemOpen$="open "
    $Else
        Const SystemOpen$ = "xdg-open "
    $End If
$End If

If I_FOUND_MYSELF Then
    MY_PATH$ = GetFilePath(MY_NAME$)
    If Right$(MY_PATH$, 1) <> Slash$ Then
        MY_PATH$ = MY_PATH$ + Slash$
    End If
    If Left$(MY_PATH$, 1) = Chr$(34) Then MY_PATH$ = Right$(MY_PATH$, Len(MY_PATH$) - 1)
End If



MY_INSTALL_DIR$ = MY_POP_DIR$
If Right$(MY_INSTALL_DIR$, 1) <> Slash$ Then MY_INSTALL_DIR$ = MY_INSTALL_DIR$ + Slash$

CX16_IMGCMD$ = MY_INSTALL_DIR$ + "cximg2bin"
$If WINDOWS Then
    CX16_IMG_AVAILABLE = _FileExists(CX16_IMGCMD$ + ".exe")
$Else
    CX16_IMG_AVAILABLE = _FileExists(CX16_IMGCMD$)
$End If

If CX16_IMG_AVAILABLE Then
    If InStr(CX16_IMGCMD$, Chr$(32)) > 0 Then CX16_IMGCMD$ = Chr$(34) + CX16_IMGCMD$ + Chr$(34)
End If


VIDEO_PLAYER_NAME$ = MY_INSTALL_DIR$ + "PLAYMOVIES-VID"
$If WINDOWS Then
    VIDEO_PLAYER_NAME$ = VIDEO_PLAYER_NAME$ + ".exe"
$End If

ASK_PLAYER_NAME$ = MY_INSTALL_DIR$ + "ASKPLAY"
$If WINDOWS Then
    ASK_PLAYER_NAME$ = ASK_PLAYER_NAME$ + ".exe"
$End If

USE_VIDEO_PLAYER = _FileExists(VIDEO_PLAYER_NAME$)
If USE_VIDEO_PLAYER Then
    If InStr(VIDEO_PLAYER_NAME$, Chr$(32)) > 0 Then VIDEO_PLAYER_NAME$ = Chr$(34) + VIDEO_PLAYER_NAME$ + Chr$(34)
End If

USE_ASK_PLAYER = _FileExists(ASK_PLAYER_NAME$)

' WRITE_AMPLAYER: writes the Amiga player (placeholder for now), looked for in this program's folder
AMIGA_PLAYER_NAME$ = MY_INSTALL_DIR$ + "WRITE_AMPLAYER"
$If WINDOWS Then
    AMIGA_PLAYER_NAME$ = AMIGA_PLAYER_NAME$ + ".exe"
$End If
USE_AMIGA_PLAYER = _FileExists(AMIGA_PLAYER_NAME$)
If USE_AMIGA_PLAYER Then
    If InStr(AMIGA_PLAYER_NAME$, Chr$(32)) > 0 Then AMIGA_PLAYER_NAME$ = Chr$(34) + AMIGA_PLAYER_NAME$ + Chr$(34)
End If
If USE_ASK_PLAYER Then
    If InStr(ASK_PLAYER_NAME$, Chr$(32)) > 0 Then ASK_PLAYER_NAME$ = Chr$(34) + ASK_PLAYER_NAME$ + Chr$(34)
End If

NO_LIMITS = _FALSE