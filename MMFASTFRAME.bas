$console:only
Option _Explicit


'=============================================================================
'  MMFASTFRAME  -  helper for X16 Movie Maker "Fast Frame Loading"
'
'  Converts ONE frame with QB64's own _LoadImage (8 bit palette mode) and
'  writes the result for MakeX16Movie to pick up.  MakeX16Movie starts several
'  of these at once so fast loading can use all of the CPU cores.
'
'  Compile it to MMFASTFRAME (MMFASTFRAME.exe on Windows) and keep it in the
'  same folder as the MakeX16Movie program.
'
'  Usage:  MMFASTFRAME  <frame image>  <temp out>  <final out>  <width>  <height>  [error file]
'
'  Output file:  256 palette entries (4 bytes each, as _PaletteColor gives them)
'                followed by width x height palette index bytes.
'  The result is written to <temp out> and renamed to <final out> when done, so
'  <final out> only exists once it is complete.
'  Exit code 0 = ok, anything else = failed.  If an [error file] is given, the
'  reason for a failure is written to it.
'=============================================================================

Dim InFile$, TmpFile$, FinFile$, ErrFile$, Reason$
Dim W As Long, H As Long
Dim Img As Long, Dst As Long, Src As Long
Dim M As _MEM
Dim I As Long
Dim F As Long
Dim Pal(0 To 255) As Long
ReDim Pix(0 To 0) As _Unsigned _Byte

On Error GoTo Failed
' QB64 switches to the folder of the program's EXE when it starts.  Go back to
' the folder it was started from, where the frame and output files are.
ChDir _StartDir$
InFile$ = Command$(1)
TmpFile$ = Command$(2)
FinFile$ = Command$(3)
W = Val(Command$(4))
H = Val(Command$(5))
ErrFile$ = Command$(6)
If InFile$ = "" Or TmpFile$ = "" Or FinFile$ = "" Or W < 1 Or H < 1 Then
    Reason$ = "bad arguments: " + Command$
    GoTo Failed
End If

Img = _LoadImage(InFile$, 257)
If Img >= -1 Then
    Reason$ = "could not load the image " + InFile$
    GoTo Failed
End If

For I = 0 To 255
    Pal(I) = _PaletteColor(I, Img)
Next

If _Width(Img) = W And _Height(Img) = H Then
    Src = Img
Else
    Dst = _NewImage(W, H, 256)
    _PutImage , Img, Dst
    Src = Dst
End If

ReDim Pix(0 To (W * H) - 1) As _Unsigned _Byte
M = _MemImage(Src)
_MemGet M, M.OFFSET, Pix()
_MemFree M

If _FileExists(TmpFile$) Then Kill TmpFile$
F = FreeFile
Open TmpFile$ For Binary As F
Put F, , Pal()
Put F, , Pix()
Close F

If _FileExists(FinFile$) Then Kill FinFile$
Name TmpFile$ As FinFile$
System 0

MAINERROR:
Resume Next

Failed:
On Error GoTo MAINERROR
If Reason$ = "" Then Reason$ = "QB64 error " + _Trim$(Str$(Err)) + " on line " + _Trim$(Str$(_ErrorLine))
If ErrFile$ <> "" Then
    F = FreeFile
    Open ErrFile$ For Output As F
    Print #F, Reason$
    Close F
End If
System 1
