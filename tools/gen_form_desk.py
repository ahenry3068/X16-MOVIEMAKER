# Generates the DESKTOP EDITION form:  MovieMakerDesk.frm, MM_IDS_DESK.BI, MM_DESKLAY.BI
# Same control NAMES as the full Maker (gen_form.py) so the shared code compiles unchanged.
# Controls the desktop edition never shows are created hidden and parked (group 'X'),
# so the shared UI logic can still read/write them without special cases.
import re, sys
HERE = __file__.rsplit('/',1)[0]
OUT  = sys.argv[1] if len(sys.argv) > 1 else HERE + '/proj'

# ---- original control list (names, types, parents, groups) taken from gen_form.py
src = open(HERE + '/gen_form.py').read()
ORIG = []
for m in re.finditer(r"^add\('(\w+)','(\w+)',(-?\d+),(-?\d+),(\d+),(\d+),'(\w*)',(?:'(.*?)'|\"(.*?)\"),'(\w)'(?:,(\{.*\}))?\)", src, re.M):
    t, n, x, y, w, h, p, cap1, cap2, g, ex = m.groups()
    cap = cap1 if cap1 is not None else cap2
    ORIG.append((t, n, p, cap, g, eval(ex) if ex else {}))
orig_names = [o[1] for o in ORIG]

FS   = 14            # base font (the full Maker uses 12)
FSB  = 14            # bold heading font (EncDim label, hidden here)
FSC  = 18            # conversion info font (full Maker: 15)
FW, FH = 1090, 690
CW   = (350, 350, 360)                   # column widths
CX   = (10, 10+350+10, 10+350+10+350+10) # column x
TOP  = 48
GAP  = 8

L = {}   # name -> (x,y,w,h,caption,extra)   visible controls, coordinates relative to parent
def put(n, x, y, w, h, cap=None, ex=None): L[n] = (x, y, w, h, cap, ex or {})
def cap_of(n):
    for o in ORIG:
        if o[1] == n: return o[3]
    return ''

# ---------------------------------------------------------------- top bar
put('AboutBtn',   FW-10-90-100-6, 8, 90, 32)
put('LicenseBtn', FW-10-100,      8, 100, 32)

# ---------------------------------------------------------------- column 1
y = TOP
SRC_H = 168
put('SrcFR', CX[0], y, CW[0], SRC_H)
put('SrcBtn', 10, 26, 165, 32); put('FramesBtn', 175, 26, 165, 32)
put('SrcNameLB', 10, 64, 330, 26); put('SrcInfoLB', 10, 92, 330, 26)
put('ProjLB', 10, 124, 80, 28); put('ProjTB', 92, 124, 248, 28)
y += SRC_H + GAP
TYPE_H = 100
put('TypeFR', CX[0], y, CW[0], TYPE_H)
put('TypeRB4', 10, 26, 330, 28, 'Desktop video  (full color, JPG or WebP)')
put('TypeRB2', 10, 58, 330, 28, 'Palettized video  (1, 2, 4 or 8 bit)')
y += TYPE_H + GAP
OUT_H = FH - 62 - y
put('OutFR', CX[0], y, CW[0], OUT_H)
put('OutLB', 10, 26, 70, 28); put('OutTB', 82, 26, 258, 28)
rows = 62
for n in ('DeleteCB','PreviewCB','TestPlayCB','PauseCB','SplitCB'):
    put(n, 10, rows, 330, 26); rows += 28
put('SplitCB', 10, 62+28*4, 330, 26, 'Split into parts if too big for FAT32')
put('PartSizeLB', 28, rows+4, 100, 26); put('PartSizeDD', 130, rows+2, 210, 28)
rows += 34
put('PartsPrevCB', 28, rows, 312, 26); rows += 30
put('TargetLB', 10, rows, 330, 26)
COL1_BOTTOM = y + OUT_H

# ---------------------------------------------------------------- column 2
y = TOP
RES_H = 284
put('ResFR', CX[1], y, CW[1], RES_H)
# W/H and the items the code moves at run time (MM_PlaceCmp) -> constants below
put('WLB', 10, 29, 56, 26); put('WTB', 68, 27, 70, 28)
put('HLB', 158, 29, 60, 26); put('HTB', 220, 27, 70, 28)
put('PromoteCB', 10, 62, 330, 26); put('Pal24CB', 10, 92, 330, 26)
put('CmpLB', 10, 128, 330, 24); put('MjpgCB', 10, 156, 152, 26); put('JpgQTB', 164, 155, 44, 28); put('JpgQLB', 214, 157, 128, 26)
put('WebpCB', 10, 186, 152, 26); put('WebpQTB', 164, 185, 44, 28); put('WebpQLB', 214, 187, 128, 26)
put('CmpNoteLB', 10, 216, 330, 24)
put('TallCB', 10, 244, 330, 26)
y += RES_H + GAP
COL_H = (FH - 62) - y
put('ColFR', CX[1], y, CW[1], COL_H)
put('BitsLB', 10, 29, 98, 26)
put('BitRB1', 102, 28, 58, 28); put('BitRB2', 162, 28, 58, 28); put('BitRB3', 222, 28, 58, 28); put('BitRB4', 282, 28, 58, 28)
put('PalLB', 10, 66, 90, 26, 'Palette'); put('PalDD', 110, 64, 230, 28)
put('C1FgBtn', 10, 102, 165, 32); put('C1BgBtn', 175, 102, 165, 32)
put('C1PB', 83, 142, 184, COL_H-142-34)
COL2_BOTTOM = y + COL_H

# ---------------------------------------------------------------- column 3
y = TOP
AUD_H = 262
put('AudFR', CX[2], y, CW[2], AUD_H)
put('CustomFpsCB', 10, 26, 150, 26); put('FpsTB', 162, 25, 70, 28); put('FpsInfoLB', 240, 27, 112, 26)
put('InterleaveCB', 10, 60, 340, 26)
put('Audio16CB', 10, 88, 160, 26); put('AudioStereoCB', 180, 88, 170, 26)
put('AudioRateLB', 10, 122, 140, 26); put('AudioRateTB', 152, 121, 90, 28)
put('CropLB', 10, 158, 60, 26); put('CropDD', 72, 156, 278, 28)
put('RateInfoLB', 10, 190, 340, 60)
y += AUD_H + GAP
ENG_H = (FH - 62) - y
put('EngFR', CX[2], y, CW[2], ENG_H)
put('FastCB', 10, 26, 340, 26)
put('ImagickCB', 10, 54, 150, 26); put('ThreadsLB', 176, 56, 96, 26); put('ThreadsTB', 274, 54, 60, 28)
put('BadmaiCB', 10, 82, 150, 26); put('YoloCB', 160, 82, 190, 26)
put('DitherLB', 10, 118, 60, 26); put('DitherDD', 72, 116, 278, 28); put('DitherTB', 72, 148, 278, 28)
put('MagickLB', 10, 184, 330, 24); put('MagickTB', 10, 208, 340, 28)
# BADMAI parameters and the ImageMagick/dither controls are never on screen together (shared rows)
put('BadmaiXLB', 10, 118, 330, 24); put('BadmaiXTB', 10, 144, 340, 28)
put('PreFilterCB', 10, 246, 340, 26); put('PreFilterTB', 10, 274, 340, 28)
ENG_H = max(ENG_H, 0)
COL3_BOTTOM = y + ENG_H

# ---------------------------------------------------------------- bottom bar
put('StatusLB', 10, FH-48, FW-20-200-10-90-10, 30)
put('ConvertBtn', FW-10-90-10-200, FH-52, 200, 40)
put('QuitBtn', FW-10-90, FH-52, 90, 40)

# ---------------------------------------------------------------- conversion page
RPX = FW-10-320       # right panel x
put('PreviewPB', 10, 28, RPX-20, FH-28-40)
put('ConvTitleLB', RPX, 36, 320, 28)
put('ConvPB', RPX, 70, 320, 30)
put('ConvInfoLB', RPX, 110, 320, 330)
put('CancelBtn', RPX, 456, 155, 40); put('SnapBtn', RPX+165, 456, 155, 40)
put('PlayBtn', RPX, 504, 155, 40); put('OpenBtn', RPX+165, 504, 155, 40)
put('BackBtn', RPX, 552, 320, 40)

# captions changed for the desktop edition
CAPS = {'ThreadsLB':'Threads', 'ProjLB':'Project:', 'SplitCB':'Split into parts if too big for FAT32', 'YoloCB':'YOLO optimization (slow)'}
# headings of the section frames: the original draws the top border 2 px lower (HDR_DY)
HDR_DY = {'ColFR':4,'EngFR':4}
FRAMES = [o[1] for o in ORIG if o[0]=='Frame' and o[1]!='UnlockFR']

# ---- assemble the full control list in the original order (parents first)
FONT='segoeui.ttf?arial.ttf?Arial.ttf?Helvetica.ttc?Geneva.ttf?truetype/liberation/LiberationSans-Regular.ttf?TTF/arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf?Courier.ttc'
FONTB='segoeuib.ttf?arialbd.ttf?Arial Bold.ttf?Helvetica.ttc?Geneva.ttf?truetype/liberation/LiberationSans-Bold.ttf?TTF/arial.ttf?TTF/arialbd.ttf?truetype/dejavu/DejaVuSans-Bold.ttf?InForm/resources/NotoMono-Regular.ttf?courbd.ttf?Courier.ttc'
CONVNAMES = {'PreviewPB','ConvTitleLB','ConvPB','ConvInfoLB','CancelBtn','SnapBtn','PlayBtn','OpenBtn','BackBtn'}
o = []
o.append("': This form was generated by\n': InForm-PE - GUI library for QB64-PE - v1.6\n': https://github.com/QB64-Phoenix-Edition/InForm-PE\n'-----------------------------------------------------------")
o.append('SUB __UI_LoadForm\n\n    DIM __UI_NewID AS LONG, __UI_RegisterResult AS LONG\n')
o.append(f'    __UI_NewID = __UI_NewControl(__UI_Type_Form, "MovieMakerIF", {FW}, {FH}, 0, 0, 0)\n    __UI_RegisterResult = 0\n    SetTheme "light"\n    SetCaption __UI_NewID, "Movie Maker - Desktop video"\n    Control(__UI_NewID).Font = SetFont("{FONT}", {FS})\n    Control(__UI_NewID).CenteredWindow = True\n')
groups = {}
for (t, n, p, cap, g, ex) in ORIG:
    vis = n in L
    if vis:
        x, yy, w, h, c2, ex2 = L[n]
        if c2 is not None: cap = c2
        if n in CAPS: cap = CAPS[n]
        grp = 'C' if n in CONVNAMES else ('B' if n in ('StatusLB','QuitBtn') else 'S')
        # frame header shift
        if n in FRAMES:
            d = HDR_DY.get(n, 2); yy += d; h -= d
        elif p in FRAMES:
            yy -= HDR_DY.get(p, 2)
        # a control in a frame that is not shown is itself not shown
    else:
        x, yy, w, h = 0, 0, 10, 10
        grp = 'X'
    groups[n] = grp
    par = '0' if not p else f'__UI_GetID("{p}")'
    T = t
    o.append(f'    __UI_NewID = __UI_NewControl(__UI_Type_{T}, "{n}", {w}, {h}, {x}, {yy}, {par})\n    __UI_RegisterResult = 0')
    if cap != '': o.append(f'    SetCaption __UI_NewID, "{cap}"')
    if t in ('Button','CheckBox','RadioButton','TextBox','DropdownList'): o.append('    Control(__UI_NewID).CanHaveFocus = True')
    if t in ('TextBox','DropdownList'): o.append('    Control(__UI_NewID).HasBorder = True\n    Control(__UI_NewID).BorderSize = 1')
    if t == 'Label' and ex.get('VA'): o.append('    Control(__UI_NewID).VAlign = __UI_Middle')
    if ex.get('WRAP'): o.append('    Control(__UI_NewID).WordWrap = True')
    if ex.get('FONTB'): o.append('    Control(__UI_NewID).Font = SetFont("'+FONTB+'", %d)' % FSB)
    if ex.get('FONT'): o.append('    Control(__UI_NewID).Font = SetFont("'+FONT+'", %d)' % FSC)
    if t == 'ProgressBar': o.append('    Control(__UI_NewID).Max = 100\n    Control(__UI_NewID).ShowPercentage = True')
    if t == 'PictureBox': o.append('    Control(__UI_NewID).HasBorder = True\n    Control(__UI_NewID).BorderSize = 1\n    Control(__UI_NewID).Align = __UI_Center\n    Control(__UI_NewID).VAlign = __UI_Middle')
    if g == 'C' or grp == 'C' or grp == 'X': o.append('    Control(__UI_NewID).Hidden = True')
    o.append('')
o.append('END SUB\n\nSUB __UI_AssignIDs\n    MovieMakerIF = __UI_GetID("MovieMakerIF")')
for n in orig_names: o.append(f'    {n} = __UI_GetID("{n}")')
o.append('END SUB\n')
open(OUT + '/MovieMakerDesk.frm', 'w').write('\n'.join(o))

ids = ['DIM SHARED MovieMakerIF AS LONG'] + [f'DIM SHARED {n} AS LONG' for n in orig_names]
setup = [n for n in orig_names if groups[n] in ('S', 'B')]
conv  = [n for n in orig_names if groups[n] == 'C']
ids.append("\n' Control groups used to switch between the setup page and the conversion page")
ids.append(f'CONST MM_NSETUP = {len(setup)}\nCONST MM_NCONV = {len(conv)}')
ids.append('DIM SHARED MM_SetupIDs(1 TO MM_NSETUP) AS LONG\nDIM SHARED MM_ConvIDs(1 TO MM_NCONV) AS LONG')
ids.append('SUB MM_FillGroups')
for i, n in enumerate(setup, 1): ids.append(f'    MM_SetupIDs({i}) = {n}')
for i, n in enumerate(conv, 1):  ids.append(f'    MM_ConvIDs({i}) = {n}')
ids.append('END SUB')
open(OUT + '/MM_IDS_DESK.BI', 'w').write('\n'.join(ids) + '\n')

# layout numbers the shared code needs at run time (MM_PlaceCmp)
lay = ["' Generated by gen_form_desk.py -- positions MM_PlaceCmp uses in the desktop edition",
       "' (tops are relative to the Resolution frame contents, after the frame header shift)"]
d = HDR_DY.get('ResFR', 2)
def top(n): return L[n][1] - d
lay += [f"Const DK_WH_TOP = {top('WTB')}", f"Const DK_WH_LBL = {top('WLB')}",
        f"Const DK_PROMOTE_TOP = {top('PromoteCB')}", f"Const DK_PAL24_PAL = {top('Pal24CB')}",
        f"Const DK_PAL24_DESK = {top('PromoteCB')}",
        f"Const DK_B_DESK = {top('CmpLB') - (top('Pal24CB')-top('PromoteCB'))}",
        f"Const DK_B_PAL = {top('CmpLB')}",
        f"Const DK_TALL_GAP = {top('TallCB')-top('CmpLB')}"]
open(OUT + '/MM_DESKLAY.BI', 'w').write('\n'.join(lay) + '\n')
print('columns bottom', COL1_BOTTOM, COL2_BOTTOM, COL3_BOTTOM, 'form', FW, FH)
print(len(orig_names), 'controls;', len([g for g in groups.values() if g=='X']), 'parked;', len(setup), 'setup', len(conv), 'conv')
