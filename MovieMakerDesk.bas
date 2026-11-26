$ExeIcon:'./FILMREEL.ICO'
$Console
$Let CHECK_ERRORS = FALSE

$Let RELEASE = TRUE
' Desktop video edition (stripped form) is built from MovieMakerDesk.bas, which sets this TRUE
$Let DESK_EDITION = TRUE
' Comment out the below line if Using QB64PE Release 4.4 or earlier
' It will still work, but frankly the Videos produced will
' look TERRIBLE.   8 bit image dithering was much improved
' in QB64PE version 4.5
$Let USEFASTMODE = TRUE

'---------------------------------------------------------------------------------
' Movie Maker  -  Desktop video edition (InForm)
' Same engine and UI code as the full X16 Movie Maker, a smaller form with only the
' Desktop video and Palettized video output types.  Form: MovieMakerDesk.frm (gen_form_desk.py)
' One main window with every option on it.  Build with QB64-PE (InForm-PE needs 3.x or newer).
'---------------------------------------------------------------------------------
Option _Explicit

': Controls' IDs and the shared state of the new front end ------------------------
'$Include:'MM_IDS_DESK.BI'
'$Include:'MM_MODEL.BI'
'$Include:'MM_SHIM.BI'
'$Include:'MM_DESKLAY.BI'

': Pieces of the original program ------------------------------------------------
'$Include:'TPRINT_IF.BI'
'$Include:'FILEPATHS.BM'
'$Include:'XTERMS.QLB'
'$Include:'MOVIEMAKER_EMBEDS.BI'

Declare Library "comptime"
    Function GetCompDate$ ()
    Function GetCompTime$ ()
End Declare

Declare Library "cpucores"
    Function cpu_cores& ()
End Declare

'$Include:'MM_GLOBALS.BI'

': External modules: ---------------------------------------------------------------
'$Include:'InForm/InForm.bi'
'$Include:'MovieMakerDesk.frm'

': The program ----------------------------------------------------------------------
'$Include:'MM_SHIM.BM'
'$Include:'MM_CBMF.BM'
'$Include:'MM_ASPECT.BM'
'$Include:'MM_ENGINE.BM'
'$Include:'MM_SHOWIT.BM'
'$Include:'MM_FRONT.BM'
'$Include:'MM_CALC.BM'
'$Include:'MM_UI.BM'
'$Include:'MM_RUN.BM'
'$Include:'MM_EVENTS.BM'

'$Include:'InForm/InForm.ui'
