object ChatGptDemoMainForm: TChatGptDemoMainForm
  Left = 2111
  Top = 115
  Caption = 'ChatGptDemoMainForm'
  ClientHeight = 500
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object DisplaySplitter: TSplitter
    Left = 0
    Top = 385
    Width = 503
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 41
    ExplicitWidth = 354
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 385
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 499
    ExplicitHeight = 384
    DesignSize = (
      503
      385)
    object Label1: TLabel
      Left = 12
      Top = 19
      Width = 47
      Height = 13
      Caption = 'Question:'
    end
    object Label2: TLabel
      Left = 12
      Top = 127
      Width = 40
      Height = 13
      Caption = 'Answer:'
    end
    object AskButton: TButton
      Left = 416
      Top = 14
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ask'
      TabOrder = 0
      OnClick = AskButtonClick
      ExplicitLeft = 412
    end
    object QuestionMemo: TMemo
      Left = 68
      Top = 16
      Width = 342
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      Lines.Strings = (
        'QuestionMemo')
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitWidth = 338
    end
    object ShowHttpDetailsCheckBox: TCheckBox
      Left = 12
      Top = 362
      Width = 133
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Show HTTP details'
      TabOrder = 2
      ExplicitTop = 361
    end
    object AnswerMemo: TMemo
      Left = 68
      Top = 124
      Width = 342
      Height = 229
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'AnswerMemo')
      ScrollBars = ssVertical
      TabOrder = 3
      ExplicitWidth = 338
      ExplicitHeight = 228
    end
    object ClearAnswerMemoButton: TButton
      Left = 416
      Top = 124
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      TabOrder = 4
      OnClick = ClearAnswerMemoButtonClick
      ExplicitLeft = 412
    end
  end
  object DisplayMemo: TMemo
    Left = 0
    Top = 389
    Width = 503
    Height = 111
    Align = alBottom
    Constraints.MinHeight = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'DisplayMemo')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitTop = 388
    ExplicitWidth = 499
  end
  object SslContext1: TSslContext
    SslDHParamLines.Strings = (
      '-----BEGIN DH PARAMETERS-----'
      'MIICCAKCAgEA45KZVdTCptcakXZb7jJvSuuOdMlUbl1tpncHbQcYbFhRbcFmmefp'
      'bOmZsTowlWHQpoYRRTe6NEvYox8J+44i/X5cJkMTlIgMb0ZBty7t76U9f6qAId/O'
      '6elE0gnk2ThER9nmBcUA0ZKgSXn0XCBu6j5lzZ0FS+bx9OVNhlzvIFBclRPXbI58'
      '71dRoTjOjfO1SIzV69T3FoKJcqur58l8b+no/TOQzekMzz4XJTRDefqvePhj7ULP'
      'Z/Zg7vtEh11h8gHR0/rlF378S05nRMq5hbbJeLxIbj9kxQunETSbwwy9qx0SyQgH'
      'g+90+iUCrKCJ9Fb7WKqtQLkQuzJIkkXkXUyuxUuyBOeeP9XBUAOQu+eYnRPYSmTH'
      'GkhyRbIRTPCDiBWDFOskdyGYYDrxiK7LYJQanqHlEFtjDv9t1XmyzDm0k7W9oP/J'
      'p0ox1+WIpFgkfv6nvihqCPHtAP5wevqXNIQADhDk5EyrR3XWRFaySeKcmREM9tbc'
      'bOvmsEp5MWCC81ZsnaPAcVpO66aOPojNiYQZUbmm70fJsr8BDzXGpcQ44+wmL4Ds'
      'k3+ldVWAXEXs9s1vfl4nLNXefYl74cV8E5Mtki9hCjUrUQ4dzbmNA5fg1CyQM/v7'
      'JuP6PBYFK7baFDjG1F5YJiO0uHo8sQx+SWdJnGsq8piI3w0ON9JhUvMCAQI='
      '-----END DH PARAMETERS-----')
    SslVerifyPeer = False
    SslVerifyDepth = 9
    SslVerifyFlags = []
    SslCheckHostFlags = []
    SslSecLevel = sslSecLevel80bits
    SslOptions = []
    SslOptions2 = [sslOpt2_ALLOW_UNSAFE_LEGACY_RENEGOTIATION, SslOpt2_LEGACY_SERVER_CONNECT]
    SslVerifyPeerModes = [SslVerifyMode_PEER]
    SslSessionCacheModes = []
    SslCipherList = 'ALL:!ADH:RC4+RSA:+SSLv2:@STRENGTH'
    SslVersionMethod = sslBestVer
    SslMinVersion = sslVerSSL3
    SslMaxVersion = sslVerMax
    SslECDHMethod = sslECDHNone
    SslCryptoGroups = 'P-256:X25519:P-384:P-512'
    SslCliSecurity = sslCliSecIgnore
    SslOcspStatus = False
    SslSessionTimeout = 0
    SslSessionCacheSize = 20480
    AutoEnableBuiltinEngines = False
    Left = 120
    Top = 424
  end
  object SslHttpCli1: TSslHttpCli
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    ProxyPort = '80'
    Agent = 'Mozilla/4.0'
    Accept = 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*'
    NoCache = False
    ResponseNoException = False
    ContentTypePost = 'application/x-www-form-urlencoded'
    LmCompatLevel = 0
    RequestVer = '1.0'
    FollowRelocation = True
    LocationChangeMaxCount = 5
    ServerAuth = httpAuthNone
    ProxyAuth = httpAuthNone
    BandwidthLimit = 10000
    BandwidthSampling = 1000
    Options = []
    Timeout = 30
    OnHeaderData = SslHttpCli1HeaderData
    OnCommand = SslHttpCli1Command
    OnRequestDone = SslHttpCli1RequestDone
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    SocketFamily = sfIPv4
    SocketErrs = wsErrTech
    SslContext = SslContext1
    Left = 32
    Top = 424
  end
end
