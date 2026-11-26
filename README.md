# X16 Movie Maker

**Make videos for the Commander X16 (and MS-DOS and Amiga) from ordinary video files.**
Version 2.0 · MIT-0 licensed · by Anthony W. Henry

The X16 Movie Maker (`MakeX16Movie`) converts MP4, AVI, MOV, MKV, WebM and other common
video files into **SPV** videos that play on the Commander X16, plus MS-DOS, Amiga and
desktop-only variants. It is written in [QB64-PE](https://github.com/QB64-Phoenix-Edition/QB64pe),
with a graphical window built with InForm-PE.

Its companion, the desktop **X16 Movie Player** (`PLAYMOVIES-VID`), which plays SPV videos
and ordinary video files, is in its own repository:
[SPV-VIDEOPLAYER](https://github.com/ahenry3068/SPV-VIDEOPLAYER).

Movie Maker comes in two builds that share one code base: the full **IF edition**
(`MakeX16Movie`) and a smaller **Desktop edition** (`MovieMakerDesk`) that makes only
desktop and palettized videos.

The SPV format itself, and the X16 side library that plays it (**VIDKIT**), are
documented in <https://github.com/ahenry3068/VIDKIT>. This README only summarizes the format.

## The SPV format in brief

An SPV file starts with a header (ID `SPRV`, video type, bits per pixel, frame rate,
sizes, frame count, screen hint and other fields), followed by the frames. Each
frame holds the picture (sprite or bitmap data), usually a palette, and an audio chunk
sized so that audio and video stay in step. The video type number says what the
file is: X16 sprite or bitmap video (standard or sector aligned "high bandwidth"),
desktop video, MS-DOS video, Amiga video. A screen hint (4:3, 16:9, tall, or an exact
aspect ratio) tells a player how to shape the picture. The full definition, with
all video types, the header layout and the audio rate formulas, is in the VIDKIT repository.

## X16 Movie Maker

One main window with every option on it. Pick a source video (or a folder of
existing frames), choose an output type and press **CONVERT**. A preview and progress bar
run while it works, and when it finishes you can **Play** the result.

### Output types

| Output type | For |
|---|---|
| X16 Sprite video (standard) | Commander X16, played with VIDKIT / the X16 movie player |
| X16 Bitmap video (standard) | Commander X16 |
| X16 High bandwidth sprite / bitmap (sector aligned) | Commander X16, SD card only (not HostFS). Higher frame sizes and data rates |
| Desktop video | Desktop-only extras (NO_LIMITS): larger frames, 24 bit palette, JPEG (MJPG) or WebP frames. Does not play on the X16 |
| VGA / MS-DOS video | MS-DOS, VGA Mode 13h and Mode X (and 16 color). Played with the [PLAYSPV](https://github.com/ahenry3068/MSDOS-SPV-PLAYER) DOS player |
| Commodore Amiga video | Amiga |

Desktop, VGA and Amiga are behind check boxes in the **Unlocks** frame, so a normal
X16 conversion stays simple.

### What you can control

- **Picture:** resolution (preset sizes or custom), 1, 2, 4 or 8 bits per pixel,
  number of colors, dithering, a static palette for the whole video or per-frame
  palettes, palette shifting, a 24 bit palette (desktop), 1 bit foreground and background colors.
- **Aspect ratio:** crop options, **Keep original aspect** (stores the exact aspect so players
  show the picture undistorted), and **Mark as TALL video** for 9:16 sources.
- **Audio:** sample rate, 8 or 16 bit, mono or stereo, audio embedded in the video file or
  kept separate, and a pause so you can edit the extracted audio before it is used.
- **Frame rate:** with the audio frame size worked out for you.
- **Conversion engine:** ImageMagick (default), a faster optional encoder (BADMAI's
  `cximg2bin`), fast frame loading, a slow FFmpeg color smoothing pass, and YOLO color
  optimization. Extra ImageMagick or encoder parameters and an external image pre-filter are available for experts.
- **Big videos:** split the output into parts (a part size can be set, for FAT32 SD cards),
  with an optional preview of each part when it completes. Part files are named `-PART-xx`
  and are played in order by the parts player.
- **Compression (desktop videos):** MJPG (JPEG) or WebP frames, each with its own quality setting.
- **Convenience:** test play when finished, snapshot of the preview, delete temporary files
  when done, command line presets (`-NODEPS`, `-NOLIMITS`, `-VGA`, `-AMIGA`, `-ALL`, or a video file or folder).
- Controls that do not apply to the current choice are grayed out or hidden, and a status line
  shows what the current settings add up to, or what is wrong.

The Maker also writes the X16 player programs (`PLAYMOVIES`-style `.PRG` templates, and the
parts player `PLAYPARTS.PRG`) next to videos that need them.

### Requirements

- [QB64-PE](https://github.com/QB64-Phoenix-Edition/QB64pe) 4.5 or newer, to build.
- [FFmpeg](https://ffmpeg.org/) and `ffprobe` on the PATH.
- [ImageMagick](https://imagemagick.org/) (`magick`) on the PATH.
- Optional: `cximg2bin` (the Badmai encoder; the Windows build `cximg2bin.exe` is included,
  with the author's permission) beside the program, and the `MMFASTFRAME`
  helper (built from `MMFASTFRAME.bas`) for fast frame loading.
- The MS-DOS player `PLAYSPV.EXE` and the X16 player templates are included for embedding.

### Build

1. Open `MakeX16Movie.bas` (IF edition) or `MovieMakerDesk.bas` (Desktop edition) in the QB64-PE IDE and compile.
2. Build the helpers `MMFASTFRAME.bas`, `ASKPLAY.bas` and `WRITE_AMPLAYER.bas` (`.exe` on
   Windows) and put them, `cximg2bin` and the player (`PLAYMOVIES-VID`, from
   [SPV-VIDEOPLAYER](https://github.com/ahenry3068/SPV-VIDEOPLAYER)) beside the Maker.
3. Use the `InForm/` folder from this repository: it holds a small patch to `InForm.ui` and
   should not be replaced by a stock InForm.

Or from the command line: `qb64pe -x MakeX16Movie.bas`.

## Related repositories

- **[VIDKIT](https://github.com/ahenry3068/VIDKIT):** the X16 library that plays SPV videos, and the full SPV format documentation.
- **[SPV-VIDEOPLAYER](https://github.com/ahenry3068/SPV-VIDEOPLAYER):** the desktop X16 Movie Player for SPV videos (and ordinary videos through VLC).
- **[MSDOS-SPV-PLAYER](https://github.com/ahenry3068/MSDOS-SPV-PLAYER):** PLAYSPV, the MS-DOS player for VGA / Mode X videos made by the Maker.

## Status

Developed and compile-checked on Linux with QB64-PE. Windows builds use the same code but
have not been tested yet.

## License

MIT-0 (MIT No Attribution) for the code in this repository. Third-party components keep their
own licenses. See `LICENSE.md`.
