$Console:Only
$ExeIcon:'./FILMREEL.ICO'
'---------------------------------------------------------------------------------
' WRITE_AMPLAYER  -  helper program of the X16 Movie Maker  (PLACEHOLDER, FOR TESTING)
'
' The Movie Maker looks for this program in its own folder and runs it, hidden, at
' the end of an Amiga (VTYPE 199) conversion:
'
'        WRITE_AMPLAYER "path/to/MOVIE.SPV"
'
' For now it only writes a small text file next to the SPV, named
' <SPV name>-AMIGA-PLAYER.TXT, holding the text
'
'        Amiga Player placeholder for: <the SPV file name as it was passed>
'
' The real Amiga player generator will replace this program later, with no change
' needed in the Movie Maker.
' Console program only: no window of its own.
'---------------------------------------------------------------------------------
Option _Explicit

Dim SPVName$, OutName$, Q$
Dim I As Long, P As Long, S As Long, FF As Long

Q$ = Chr$(34)

If _CommandCount < 1 Then System 1

' the whole command line is the file name (it may have been passed with spaces and no quotes)
SPVName$ = Command$(1)
For I = 2 To _CommandCount
    SPVName$ = SPVName$ + " " + Command$(I)
Next
SPVName$ = _Trim$(SPVName$)
If Left$(SPVName$, 1) = Q$ Then SPVName$ = Mid$(SPVName$, 2)
If Right$(SPVName$, 1) = Q$ Then SPVName$ = Left$(SPVName$, Len(SPVName$) - 1)
If Len(SPVName$) = 0 Then System 1

' out file: the SPV name without its extension, plus -AMIGA-PLAYER.TXT
P = _InStrRev(SPVName$, ".")
S = _InStrRev(SPVName$, "/")
If _InStrRev(SPVName$, "\") > S Then S = _InStrRev(SPVName$, "\")
If P > S And P > 1 Then OutName$ = Left$(SPVName$, P - 1) Else OutName$ = SPVName$
OutName$ = OutName$ + "-AMIGA-PLAYER.TXT"

On Error GoTo WriteFailed
FF = FreeFile
Open OutName$ For Output As #FF
Print #FF, "Amiga Player placeholder for: " + SPVName$
Close #FF
System 0

WriteFailed:
System 1
