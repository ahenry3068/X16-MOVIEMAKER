DIM SHARED MovieMakerIF AS LONG
DIM SHARED UnlockFR AS LONG
DIM SHARED NoLimitsCB AS LONG
DIM SHARED VgaCB AS LONG
DIM SHARED AmigaCB AS LONG
DIM SHARED AboutBtn AS LONG
DIM SHARED LicenseBtn AS LONG
DIM SHARED SrcFR AS LONG
DIM SHARED SrcBtn AS LONG
DIM SHARED FramesBtn AS LONG
DIM SHARED SrcNameLB AS LONG
DIM SHARED SrcInfoLB AS LONG
DIM SHARED ProjLB AS LONG
DIM SHARED ProjTB AS LONG
DIM SHARED TypeFR AS LONG
DIM SHARED TypeRB1 AS LONG
DIM SHARED TypeRBHS AS LONG
DIM SHARED TypeRB2 AS LONG
DIM SHARED TypeRB3 AS LONG
DIM SHARED TypeRB4 AS LONG
DIM SHARED TypeRB5 AS LONG
DIM SHARED TypeRB6 AS LONG
DIM SHARED OutFR AS LONG
DIM SHARED OutLB AS LONG
DIM SHARED OutTB AS LONG
DIM SHARED DeleteCB AS LONG
DIM SHARED PreviewCB AS LONG
DIM SHARED TestPlayCB AS LONG
DIM SHARED PauseCB AS LONG
DIM SHARED SplitCB AS LONG
DIM SHARED PartSizeLB AS LONG
DIM SHARED PartSizeDD AS LONG
DIM SHARED PartsPrevCB AS LONG
DIM SHARED TargetLB AS LONG
DIM SHARED ResFR AS LONG
DIM SHARED ResDD AS LONG
DIM SHARED WLB AS LONG
DIM SHARED WTB AS LONG
DIM SHARED HLB AS LONG
DIM SHARED HTB AS LONG
DIM SHARED SpiCB AS LONG
DIM SHARED SectCustomCB AS LONG
DIM SHARED EncDimLB AS LONG
DIM SHARED EncDimUL AS LONG
DIM SHARED VgaDD AS LONG
DIM SHARED AmiStdDD AS LONG
DIM SHARED AmiHLB AS LONG
DIM SHARED PromoteCB AS LONG
DIM SHARED Pal24CB AS LONG
DIM SHARED CmpLB AS LONG
DIM SHARED MjpgCB AS LONG
DIM SHARED JpgQTB AS LONG
DIM SHARED JpgQLB AS LONG
DIM SHARED WebpCB AS LONG
DIM SHARED WebpQTB AS LONG
DIM SHARED WebpQLB AS LONG
DIM SHARED CmpNoteLB AS LONG
DIM SHARED SprInfoLB AS LONG
DIM SHARED TallCB AS LONG
DIM SHARED AspectCB AS LONG
DIM SHARED ColFR AS LONG
DIM SHARED ColorDD AS LONG
DIM SHARED BitsLB AS LONG
DIM SHARED BitRB1 AS LONG
DIM SHARED BitRB2 AS LONG
DIM SHARED BitRB3 AS LONG
DIM SHARED BitRB4 AS LONG
DIM SHARED PalLB AS LONG
DIM SHARED PalDD AS LONG
DIM SHARED ColorsLB AS LONG
DIM SHARED ColorsTB AS LONG
DIM SHARED PalShiftCB AS LONG
DIM SHARED C1FgBtn AS LONG
DIM SHARED C1BgBtn AS LONG
DIM SHARED C1PB AS LONG
DIM SHARED ExtPalCB AS LONG
DIM SHARED ExtMethodDD AS LONG
DIM SHARED SaveMapCB AS LONG
DIM SHARED FfColorCB AS LONG
DIM SHARED AudFR AS LONG
DIM SHARED CustomFpsCB AS LONG
DIM SHARED FpsTB AS LONG
DIM SHARED FpsInfoLB AS LONG
DIM SHARED InterleaveCB AS LONG
DIM SHARED Audio16CB AS LONG
DIM SHARED AudioStereoCB AS LONG
DIM SHARED AudNoteLB AS LONG
DIM SHARED AudioRateLB AS LONG
DIM SHARED AudioRateTB AS LONG
DIM SHARED AudioSizeLB AS LONG
DIM SHARED AudioSizeDD AS LONG
DIM SHARED CropLB AS LONG
DIM SHARED CropDD AS LONG
DIM SHARED RateInfoLB AS LONG
DIM SHARED EngFR AS LONG
DIM SHARED FastCB AS LONG
DIM SHARED ImagickCB AS LONG
DIM SHARED BadmaiCB AS LONG
DIM SHARED YoloCB AS LONG
DIM SHARED ThreadsLB AS LONG
DIM SHARED ThreadsTB AS LONG
DIM SHARED DitherLB AS LONG
DIM SHARED DitherDD AS LONG
DIM SHARED DitherTB AS LONG
DIM SHARED MagickLB AS LONG
DIM SHARED MagickTB AS LONG
DIM SHARED BadmaiXLB AS LONG
DIM SHARED BadmaiXTB AS LONG
DIM SHARED PreFilterCB AS LONG
DIM SHARED PreFilterTB AS LONG
DIM SHARED StatusLB AS LONG
DIM SHARED ConvertBtn AS LONG
DIM SHARED QuitBtn AS LONG
DIM SHARED PreviewPB AS LONG
DIM SHARED ConvTitleLB AS LONG
DIM SHARED ConvPB AS LONG
DIM SHARED ConvInfoLB AS LONG
DIM SHARED CancelBtn AS LONG
DIM SHARED SnapBtn AS LONG
DIM SHARED PlayBtn AS LONG
DIM SHARED OpenBtn AS LONG
DIM SHARED BackBtn AS LONG

' Control groups used to switch between the setup page and the conversion page
CONST MM_NSETUP = 110
CONST MM_NCONV = 9
DIM SHARED MM_SetupIDs(1 TO MM_NSETUP) AS LONG
DIM SHARED MM_ConvIDs(1 TO MM_NCONV) AS LONG
SUB MM_FillGroups
    MM_SetupIDs(1) = UnlockFR
    MM_SetupIDs(2) = NoLimitsCB
    MM_SetupIDs(3) = VgaCB
    MM_SetupIDs(4) = AmigaCB
    MM_SetupIDs(5) = AboutBtn
    MM_SetupIDs(6) = LicenseBtn
    MM_SetupIDs(7) = SrcFR
    MM_SetupIDs(8) = SrcBtn
    MM_SetupIDs(9) = FramesBtn
    MM_SetupIDs(10) = SrcNameLB
    MM_SetupIDs(11) = SrcInfoLB
    MM_SetupIDs(12) = ProjLB
    MM_SetupIDs(13) = ProjTB
    MM_SetupIDs(14) = TypeFR
    MM_SetupIDs(15) = TypeRB1
    MM_SetupIDs(16) = TypeRBHS
    MM_SetupIDs(17) = TypeRB2
    MM_SetupIDs(18) = TypeRB3
    MM_SetupIDs(19) = TypeRB4
    MM_SetupIDs(20) = TypeRB5
    MM_SetupIDs(21) = TypeRB6
    MM_SetupIDs(22) = OutFR
    MM_SetupIDs(23) = OutLB
    MM_SetupIDs(24) = OutTB
    MM_SetupIDs(25) = DeleteCB
    MM_SetupIDs(26) = PreviewCB
    MM_SetupIDs(27) = TestPlayCB
    MM_SetupIDs(28) = PauseCB
    MM_SetupIDs(29) = SplitCB
    MM_SetupIDs(30) = PartSizeLB
    MM_SetupIDs(31) = PartSizeDD
    MM_SetupIDs(32) = PartsPrevCB
    MM_SetupIDs(33) = TargetLB
    MM_SetupIDs(34) = ResFR
    MM_SetupIDs(35) = ResDD
    MM_SetupIDs(36) = WLB
    MM_SetupIDs(37) = WTB
    MM_SetupIDs(38) = HLB
    MM_SetupIDs(39) = HTB
    MM_SetupIDs(40) = SpiCB
    MM_SetupIDs(41) = SectCustomCB
    MM_SetupIDs(42) = EncDimLB
    MM_SetupIDs(43) = EncDimUL
    MM_SetupIDs(44) = VgaDD
    MM_SetupIDs(45) = AmiStdDD
    MM_SetupIDs(46) = AmiHLB
    MM_SetupIDs(47) = PromoteCB
    MM_SetupIDs(48) = Pal24CB
    MM_SetupIDs(49) = CmpLB
    MM_SetupIDs(50) = MjpgCB
    MM_SetupIDs(51) = JpgQTB
    MM_SetupIDs(52) = JpgQLB
    MM_SetupIDs(53) = WebpCB
    MM_SetupIDs(54) = WebpQTB
    MM_SetupIDs(55) = WebpQLB
    MM_SetupIDs(56) = CmpNoteLB
    MM_SetupIDs(57) = SprInfoLB
    MM_SetupIDs(58) = TallCB
    MM_SetupIDs(59) = ColFR
    MM_SetupIDs(60) = ColorDD
    MM_SetupIDs(61) = BitsLB
    MM_SetupIDs(62) = BitRB1
    MM_SetupIDs(63) = BitRB2
    MM_SetupIDs(64) = BitRB3
    MM_SetupIDs(65) = BitRB4
    MM_SetupIDs(66) = PalLB
    MM_SetupIDs(67) = PalDD
    MM_SetupIDs(68) = ColorsLB
    MM_SetupIDs(69) = ColorsTB
    MM_SetupIDs(70) = PalShiftCB
    MM_SetupIDs(71) = C1FgBtn
    MM_SetupIDs(72) = C1BgBtn
    MM_SetupIDs(73) = C1PB
    MM_SetupIDs(74) = ExtPalCB
    MM_SetupIDs(75) = ExtMethodDD
    MM_SetupIDs(76) = SaveMapCB
    MM_SetupIDs(77) = FfColorCB
    MM_SetupIDs(78) = AudFR
    MM_SetupIDs(79) = CustomFpsCB
    MM_SetupIDs(80) = FpsTB
    MM_SetupIDs(81) = FpsInfoLB
    MM_SetupIDs(82) = InterleaveCB
    MM_SetupIDs(83) = Audio16CB
    MM_SetupIDs(84) = AudioStereoCB
    MM_SetupIDs(85) = AudNoteLB
    MM_SetupIDs(86) = AudioRateLB
    MM_SetupIDs(87) = AudioRateTB
    MM_SetupIDs(88) = AudioSizeLB
    MM_SetupIDs(89) = AudioSizeDD
    MM_SetupIDs(90) = CropLB
    MM_SetupIDs(91) = CropDD
    MM_SetupIDs(92) = RateInfoLB
    MM_SetupIDs(93) = EngFR
    MM_SetupIDs(94) = FastCB
    MM_SetupIDs(95) = ImagickCB
    MM_SetupIDs(96) = BadmaiCB
    MM_SetupIDs(97) = YoloCB
    MM_SetupIDs(98) = ThreadsLB
    MM_SetupIDs(99) = ThreadsTB
    MM_SetupIDs(100) = DitherLB
    MM_SetupIDs(101) = DitherDD
    MM_SetupIDs(102) = DitherTB
    MM_SetupIDs(103) = MagickLB
    MM_SetupIDs(104) = MagickTB
    MM_SetupIDs(105) = BadmaiXLB
    MM_SetupIDs(106) = BadmaiXTB
    MM_SetupIDs(107) = PreFilterCB
    MM_SetupIDs(108) = PreFilterTB
    MM_SetupIDs(109) = ConvertBtn
    MM_SetupIDs(110) = AspectCB
    MM_ConvIDs(1) = PreviewPB
    MM_ConvIDs(2) = ConvTitleLB
    MM_ConvIDs(3) = ConvPB
    MM_ConvIDs(4) = ConvInfoLB
    MM_ConvIDs(5) = CancelBtn
    MM_ConvIDs(6) = SnapBtn
    MM_ConvIDs(7) = PlayBtn
    MM_ConvIDs(8) = OpenBtn
    MM_ConvIDs(9) = BackBtn
END SUB
