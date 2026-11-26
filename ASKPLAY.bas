$Console:Only
$ExeIcon:'./FILMREEL.ICO'
'---------------------------------------------------------------------------------
' ASKPLAY  -  used internally by the X16 Movie Maker
' Asks (with the system dialog) whether to play a just converted video, and if so
' starts PLAYMOVIES-VID with it:     PLAYMOVIES-VID -PLAY file
' Console program only: no window of its own.
'---------------------------------------------------------------------------------
Option _Explicit

Dim PlayerPath$, PFile$, PCMD$, Slash$, Nm$, Q$
Dim R As Long

Q$ = Chr$(34)
$If WINDOWS Then
    Slash$ = "\"
$Else
    Slash$ = "/"
$End If

' the player sits in the same folder as this program (started with its full path)
Dim P0$, K As Long
P0$ = Command$(0)
K = 0
Dim J As Long
For J = Len(P0$) To 1 Step -1
    If Mid$(P0$, J, 1) = "/" Or Mid$(P0$, J, 1) = "\" Then K = J: Exit For
Next
If K > 0 Then PlayerPath$ = Left$(P0$, K) Else PlayerPath$ = _CWD$
If Right$(PlayerPath$, 1) <> Slash$ And Right$(PlayerPath$, 1) <> "/" Then PlayerPath$ = PlayerPath$ + Slash$
PlayerPath$ = PlayerPath$ + "PLAYMOVIES-VID"
$If WINDOWS Then
    PlayerPath$ = PlayerPath$ + ".exe"
$End If

If _CommandCount <> 1 Then BadCommandLine
If Not _FileExists(Command$(1)) Then BadCommandLine

If Not _FileExists(PlayerPath$) Then
    R = _MessageBox("NO PLAYER", "PLAYMOVIES-VID IS MISSING !", "ok", "warning", 1)
    System
End If

PFile$ = Command$(1)
Nm$ = PFile$
Do While InStr(Nm$, "/") > 0 Or InStr(Nm$, "\")
    If InStr(Nm$, "/") > 0 Then Nm$ = Mid$(Nm$, InStr(Nm$, "/") + 1) Else Nm$ = Mid$(Nm$, InStr(Nm$, "\") + 1)
Loop

R = _MessageBox("PLAY " + Nm$, "Play " + Nm$ + " ?", "yesno", "question", 1)
If R = 1 Then
    ' a bare file name is looked for in the folder this program was started in
    If InStr(PFile$, "/") = 0 And InStr(PFile$, "\") = 0 Then PFile$ = _CWD$ + Slash$ + PFile$
    PCMD$ = Q$ + PlayerPath$ + Q$ + " -PLAY " + Q$ + PFile$ + Q$
    $If WINDOWS Then
        Shell _DontWait _Hide PCMD$
    $Else
        Shell _DontWait PCMD$ + " &"
    $End If
    _Delay .5
End If
System

Sub BadCommandLine
    Dim R As Long
    R = _MessageBox("NOT FOR INDEPENDENT USE", "ASKPLAY is for internal use only" + Chr$(10) + Chr$(10) + "by the X16 Movie Maker !", "ok", "warning", 1)
    System
End Sub
