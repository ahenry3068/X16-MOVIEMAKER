# CXIMG2BIN - Visual Studio 2022 - Step 9

Native Visual Studio 2022 solution for `cximg2bin`.

## Requirements

- Windows 10 or 11
- Visual Studio 2022
- Desktop development with C++ workload
- Windows 10/11 SDK

PNG/JPG/BMP loading uses Windows Imaging Component (WIC). No vcpkg, NuGet, libpng, or third-party image DLL is required on Windows.

## Build

1. Open `cximg2bin.sln`.
2. Select `Release` and `x64`.
3. Choose **Build -> Build Solution**.

Output:

```text
bin\x64\Release\cximg2bin.exe
```

Release uses the static MSVC runtime (`/MT`).

## Verify

```bat
bin\x64\Release\cximg2bin.exe --self-test
```

Expected:

```text
SELFTEST PASS
```

## Output type switch

Default X16 BIN/PAL:

```bat
bin\x64\Release\cximg2bin.exe image.png -w 320 -h 240 -bpp 8 --output-type binpal
```

Windows 8-bit BMP v3:

```bat
bin\x64\Release\cximg2bin.exe image.jpg -w 320 -h 240 -bpp 8 --output-type bmp8
```

4bpp conversion written as an 8-bit Windows BMP:

```bat
bin\x64\Release\cximg2bin.exe image.png -w 320 -h 240 -bpp 4 -stucki 50 --output-type bmp8
```

For 1bpp/2bpp/4bpp BMP output, the first active palette entries contain the converted colors and all unused BMP palette entries through 255 are black.

You can also set the exact BMP filename:

```bat
bin\x64\Release\cximg2bin.exe image.png -bpp 8 --bmp converted.bmp
```

## Ultra / YOLO

```bat
bin\x64\Release\cximg2bin.exe image.jpg -w 320 -h 240 -bpp 8 -yolo --threads 8 --output-type bmp8
```


Low-BPP BIN/PAL examples:

```bat
bin\x64\Release\cximg2bin.exe image.png -w 320 -h 240 -bpp 1 -floyd 100
bin\x64\Release\cximg2bin.exe image.png -w 320 -h 240 -bpp 2 -stucki 50
```
