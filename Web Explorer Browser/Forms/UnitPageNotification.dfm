object PageNotificationFrame: TPageNotificationFrame
  Left = 0
  Top = 0
  Width = 1118
  Height = 716
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  OnResize = FrameResize
  object PanelCenter: TPanel
    Left = 188
    Top = 82
    Width = 800
    Height = 450
    BevelOuter = bvNone
    TabOrder = 0
    object ErrorMSG1: TLabel
      Left = 0
      Top = 206
      Width = 801
      Height = 80
      Alignment = taCenter
      AutoSize = False
      Caption = 'ErrorMSG1'
      EllipsisPosition = epEndEllipsis
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI Semilight'
      Font.Style = []
      ParentFont = False
    end
    object welogo_image: TImage
      Left = 310
      Top = 20
      Width = 180
      Height = 180
    end
    object ErrorMSG2: TLabel
      Left = 0
      Top = 290
      Width = 801
      Height = 63
      Alignment = taCenter
      AutoSize = False
      Caption = 'ErrorMSG2'
      EllipsisPosition = epEndEllipsis
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI Semilight'
      Font.Style = []
      ParentFont = False
    end
    object ErrorMSG3: TLabel
      Left = 0
      Top = 354
      Width = 801
      Height = 31
      Alignment = taCenter
      AutoSize = False
      Caption = 'ErrorMSG3'
      EllipsisPosition = epEndEllipsis
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -19
      Font.Name = 'Segoe UI Semilight'
      Font.Style = []
      ParentFont = False
    end
    object HTMLErrorPanelBTs: TPanel
      Left = 0
      Top = 400
      Width = 800
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      ExplicitTop = 390
      object ErrorBT1Popup: TAdvGlowButton
        Left = 406
        Top = 11
        Width = 160
        Height = 30
        Caption = 'Try Again'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        FocusType = ftNone
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        Rounded = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnClick = ErrorBT1PopupClick
        Appearance.BorderColorHot = clGray
        Appearance.BorderColorDown = clGray
        Appearance.BorderColorChecked = clBlack
        Appearance.BorderColorDisabled = 11316396
        Appearance.BorderColorFocused = clBlack
        Appearance.Color = clSilver
        Appearance.ColorTo = clNone
        Appearance.ColorChecked = 14327846
        Appearance.ColorCheckedTo = clNone
        Appearance.ColorDisabled = 16250871
        Appearance.ColorDisabledTo = clNone
        Appearance.ColorDown = clGray
        Appearance.ColorDownTo = clNone
        Appearance.ColorHot = clSilver
        Appearance.ColorHotTo = clNone
        Appearance.ColorMirrorTo = clNone
        Appearance.ColorMirrorHot = clSilver
        Appearance.ColorMirrorHotTo = clNone
        Appearance.ColorMirrorDown = clGray
        Appearance.ColorMirrorDownTo = clNone
        Appearance.ColorMirrorChecked = 14327846
        Appearance.ColorMirrorCheckedTo = clNone
        Appearance.ColorMirrorDisabled = 16250871
        Appearance.ColorMirrorDisabledTo = clWhite
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object ErrorBT2Popup: TAdvGlowButton
        Left = 240
        Top = 11
        Width = 160
        Height = 30
        Caption = 'Search for the page'
        Default = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        Rounded = False
        Trimming = StringTrimmingEllipsisCharacter
        TabOrder = 1
        OnClick = ErrorBT2PopupClick
        Appearance.BorderColorHot = clGray
        Appearance.BorderColorDown = clGray
        Appearance.BorderColorChecked = clBlack
        Appearance.BorderColorDisabled = 11316396
        Appearance.BorderColorFocused = clBlack
        Appearance.Color = clSilver
        Appearance.ColorTo = clNone
        Appearance.ColorChecked = 14327846
        Appearance.ColorCheckedTo = clNone
        Appearance.ColorDisabled = 16250871
        Appearance.ColorDisabledTo = clNone
        Appearance.ColorDown = clGray
        Appearance.ColorDownTo = clNone
        Appearance.ColorHot = clSilver
        Appearance.ColorHotTo = clNone
        Appearance.ColorMirrorTo = clNone
        Appearance.ColorMirrorHot = clSilver
        Appearance.ColorMirrorHotTo = clNone
        Appearance.ColorMirrorDown = clGray
        Appearance.ColorMirrorDownTo = clNone
        Appearance.ColorMirrorChecked = 14327846
        Appearance.ColorMirrorCheckedTo = clNone
        Appearance.ColorMirrorDisabled = 16250871
        Appearance.ColorMirrorDisabledTo = clWhite
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
        DropDownSplit = False
      end
    end
    object CertErrorPanelBTs: TPanel
      Left = 0
      Top = 350
      Width = 800
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      ExplicitTop = 359
      object CertErrorBT1: TAdvGlowButton
        Left = 406
        Top = 19
        Width = 160
        Height = 30
        Caption = 'Continue'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        FocusType = ftNone
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        Rounded = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnClick = CertErrorBT1Click
        Appearance.BorderColorHot = clGray
        Appearance.BorderColorDown = clGray
        Appearance.BorderColorChecked = clBlack
        Appearance.BorderColorDisabled = 11316396
        Appearance.BorderColorFocused = clBlack
        Appearance.Color = clSilver
        Appearance.ColorTo = clNone
        Appearance.ColorChecked = 14327846
        Appearance.ColorCheckedTo = clNone
        Appearance.ColorDisabled = 16250871
        Appearance.ColorDisabledTo = clNone
        Appearance.ColorDown = clGray
        Appearance.ColorDownTo = clNone
        Appearance.ColorHot = clSilver
        Appearance.ColorHotTo = clNone
        Appearance.ColorMirrorTo = clNone
        Appearance.ColorMirrorHot = clSilver
        Appearance.ColorMirrorHotTo = clNone
        Appearance.ColorMirrorDown = clGray
        Appearance.ColorMirrorDownTo = clNone
        Appearance.ColorMirrorChecked = 14327846
        Appearance.ColorMirrorCheckedTo = clNone
        Appearance.ColorMirrorDisabled = 16250871
        Appearance.ColorMirrorDisabledTo = clWhite
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object CertErrorBT2: TAdvGlowButton
        Left = 240
        Top = 19
        Width = 160
        Height = 30
        Caption = 'Close Page'
        Default = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        ParentFont = False
        Rounded = False
        Trimming = StringTrimmingEllipsisCharacter
        TabOrder = 1
        OnClick = CertErrorBT2Click
        Appearance.BorderColorHot = clGray
        Appearance.BorderColorDown = clGray
        Appearance.BorderColorChecked = clBlack
        Appearance.BorderColorDisabled = 11316396
        Appearance.BorderColorFocused = clBlack
        Appearance.Color = clSilver
        Appearance.ColorTo = clNone
        Appearance.ColorChecked = 14327846
        Appearance.ColorCheckedTo = clNone
        Appearance.ColorDisabled = 16250871
        Appearance.ColorDisabledTo = clNone
        Appearance.ColorDown = clGray
        Appearance.ColorDownTo = clNone
        Appearance.ColorHot = clSilver
        Appearance.ColorHotTo = clNone
        Appearance.ColorMirrorTo = clNone
        Appearance.ColorMirrorHot = clSilver
        Appearance.ColorMirrorHotTo = clNone
        Appearance.ColorMirrorDown = clGray
        Appearance.ColorMirrorDownTo = clNone
        Appearance.ColorMirrorChecked = 14327846
        Appearance.ColorMirrorCheckedTo = clNone
        Appearance.ColorMirrorDisabled = 16250871
        Appearance.ColorMirrorDisabledTo = clWhite
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
        DropDownSplit = False
      end
    end
  end
end
