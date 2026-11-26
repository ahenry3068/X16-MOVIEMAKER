# License

## This project: MIT No Attribution (MIT-0)

Copyright 2026 Anthony W. Henry

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

This covers the X16 Movie Maker source code, the X16 player templates and the build
helpers. It also covers the original artwork made for the project (`ffhdr.png`, `mjpeg2.png`, `webp2.png`, `test1bpp.bmp`), which was created by Anthony W. Henry with the help of Claude. It does not cover the third-party components below.

## Third-party components

| Component | Where | License |
|---|---|---|
| **InForm-PE** GUI library, Copyright (c) 2026 QB64 Phoenix Edition Team, (c) 2023 George McGinn, (c) 2022 Fellippe Heitor | `InForm/` (compiled into the programs) | MIT. Full text in `InForm/LICENSE-InForm-PE.txt`. Keep it with any copy of InForm. The repository's `InForm.ui` has a small local patch |
| **Source Code Pro** (`SPL.TTF`, renamed, unmodified), (c) 2010 - 2020 Adobe Systems Incorporated (<http://www.adobe.com/>), with Reserved Font Name "Source" | Embedded in the Maker | SIL Open Font License 1.1. Text in `SIL Open Font License 1.1.txt` |
| **IBM 3270 Condensed** (`3270con.ttf`, renamed, unmodified), Copyright 2011-2021 The 3270font Project Authors (<https://github.com/rbanffy/3270font>) | Embedded in the Maker | SIL Open Font License 1.1. Text in `SIL Open Font License 1.1.txt` |
| **QB64-PE runtime** | Inside every compiled program | MIT style. The compiler writes the text to `<program>.license.txt`; ship it with released builds |
| **tinyfiledialogs** | Inside the QB64-PE runtime | zlib. Same license file as above |
| **`cximg2bin`** by **Badmai** | Optional encoder; the Windows build `cximg2bin.exe` and its notes (`cx16img2bin.README-WINDOWS.md`) are in this repository | Third party, binary only, used and distributed with the author's permission. Not covered by this project's license |
| **`SB_UNIT.PAS`** (Sound Blaster unit, version 1.0, January 1993, author not named) | Built into `PLAYSPV.EXE` (source in [MSDOS-SPV-PLAYER](https://github.com/ahenry3068/MSDOS-SPV-PLAYER)) | Public domain, per its header ("This package is public domain. Use it, distribute it, and modify it.") |
| **Sound effects** (`beep1.ogg`, `co_done.mp3`, `error3.mp3`, `piccap.mp3`) | Embedded in the Maker. The files are in the repository only as build inputs, to be compiled into the programs | Pixabay Content License (<https://pixabay.com/service/license-summary/>). Free to use and modify without attribution; not to be redistributed as stand-alone files. The sounds are used here as part of a combined work (compiled into the programs together with the code, images and text), which Pixabay's license describes as "not Standalone use, so long as the combined effect is to make a 'new' creative work". `beep1.ogg` source: <https://pixabay.com/sound-effects/film-special-effects-beep-329314/> |
| **Film reel icon** (`FILMREEL.PNG`, `FILMREEL.ICO`), cut from <https://pixabay.com/illustrations/cinema-movies-popcorn-ticket-5434742/> and edited | Window icon | Pixabay Content License, modified |
| **FFmpeg, ImageMagick, VLC** | Not included. Installed by the user | Each under its own license |

The MS-DOS player (`PLAYSPV.EXE`) is built with Borland Turbo Pascal 7.0.

Cassette-tape, film and other artwork used in the VIDKIT sample programs is credited in the
VIDKIT repository (`ASSETS-CREDITS.md`).
