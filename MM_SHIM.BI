' MM_SHIM.BI -- declarations that replace the parts of BUTTONS.QLB that the engine
' still refers to.  Included BEFORE InForm.bi
$IncludeOnce

Type D_COLORS
    TITLE_FG As Long
    TITLE_BG As Long
    TITLE_BC As Long
    MSG_BC As Long
    MSG_FG As Long
    MSG_BG As Long
End Type

Type PointTYPE
    X As Integer
    Y As Integer
End Type

Type MouseBox
    TopLeft As PointTYPE
    BottomRight As PointTYPE
End Type

Type CheckBox
    Box As MouseBox
    CHECKED As Integer
    CREATED As Integer
    BorderColor As _Unsigned Long
    BGColor As _Unsigned Long
    TicColor As _Unsigned Long
End Type

Type BUTTONTYPE
    Height As Integer
    Width As Integer
    X As Integer
    Y As Integer
    Image As Long
    PushImage As Long
    OldImage As Long
    CREATED As Integer
    ONSCREEN As Integer
End Type

Dim Shared DIALOG_THEME As D_COLORS
Dim Shared Mx As Integer
Dim Shared My As Integer
Dim Shared MouseTick
Dim Shared Y_ADJUSTOR As Integer
Dim Shared CRLF As String
CRLF = Chr$(13) + Chr$(10)

' The engine "screen": every text screen the old program drew now lands on this image
' and is shown inside the preview PictureBox of the form.
Dim Shared MM_SCR As Long
Dim Shared MM_FFSCR As Integer ' while the FFmpeg screens are up, the header picture is the "Running FFmpeg." one (no X16 logo flash)
Dim Shared MM_PREVIEW_IMG As Long ' the image Showit builds (the conversion preview)
Dim Shared MM_PREVIEW_ON As Integer ' show MM_PREVIEW_IMG instead of MM_SCR
Dim Shared MM_CANCEL As Integer ' user pressed Cancel during a conversion
Dim Shared MM_SNAPREQ As Integer ' user pressed Snapshot during a conversion
Dim Shared MM_BUSY As Integer ' a conversion is running
Dim Shared MM_SHOW_RESET As Integer ' Showit must rebuild its window
Dim Shared MM_STATUSTXT$ ' one line status text for the form
