{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE @ Overbyte.be
Creation:     Jan 4, 2023
Description:  Use OpenAI API to query ChatGPT using ICS
              You need an API key.
              Get your key from https://beta.openai.com/account/api-keys
              To run this example, you need to place OpenSSL DLL in same
              directory as the executable.
              The two DLL are libcrypto-1_1.dll and libssl-1_1.dll. They
              are available from wiki.overbyte.be or other websites.
Version:      1.00
EMail:        francois.piette@overbyte.be         http://www.overbyte.be
Support:      https://en.delphipraxis.net/forum/37-ics-internet-component-suite/
Legal issues: Copyright (C) 2023 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.
History:


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit ChatGptDemoMain;

interface

uses
    Winapi.Windows, Winapi.Messages, Winapi.ShlObj,
    System.SysUtils, System.Variants, System.Classes, System.IniFiles,
    System.Types, System.StrUtils,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
    Vcl.StdCtrls, Vcl.ExtCtrls,
    OverbyteIcsWndControl, OverbyteIcsHttpProt, OverbyteIcsWSocket,
    OverbyteIcsSuperObject;

const
    WM_APP_STARTUP         = WM_USER + 1;
    MAX_DISPLAY_LINES      = 4000;
var
    CompanyFolder : String = 'OverByte';
const
    ProgName               = 'ChatGptDemo';
    ProgVer                = '1.00';

type
    TChatGptDemoMainForm = class(TForm)
        TopPanel: TPanel;
        DisplaySplitter: TSplitter;
        DisplayMemo: TMemo;
        AskButton: TButton;
        SslContext1: TSslContext;
        SslHttpCli1: TSslHttpCli;
        Label1: TLabel;
        QuestionMemo: TMemo;
        ShowHttpDetailsCheckBox: TCheckBox;
        Label2: TLabel;
        AnswerMemo: TMemo;
        ClearAnswerMemoButton: TButton;
        procedure AskButtonClick(Sender: TObject);
        procedure SslHttpCli1RequestDone(Sender: TObject; RqType: THttpRequest;
          ErrCode: Word);
        procedure SslHttpCli1Command(Sender: TObject; var S: string);
        procedure SslHttpCli1HeaderData(Sender: TObject);
        procedure ClearAnswerMemoButtonClick(Sender: TObject);
    protected
        FLocalAppData           : String;
        FAppName                : String;
        FIniFileName            : String;
        FInitialized            : Boolean;
        FIniSection             : String;
        FIniSectionData         : String;
        FFullScreen             : Boolean;
        FFullScreenFlag         : Boolean;
        FApiKey                 : String;
        FQuestion               : String;
        procedure WMAppStartup(var Msg: TMessage); message WM_APP_STARTUP;
        procedure DoShow; override;
        procedure DoClose(var Action: TCloseAction); override;
        procedure Display(const Msg : String); overload;
        procedure Display(const Msg : String; Args : array of const); overload;
        procedure DisplayAnswer(Msg : String);
    public
        constructor Create(AOwner : TComponent); override;
        property IniFileName            : String     read  FIniFileName
                                                     write FIniFileName;
        property IniSection             : String     read  FIniSection
                                                     write FIniSection;
        property IniSectionData         : String     read  FIniSectionData
                                                     write FIniSectionData;
        property LocalAppData           : String     read  FLocalAppData
                                                     write FLocalAppData;
        property AppName                : String     read  FAppName
                                                     write FAppName;
    end;

var
    ChatGptDemoMainForm : TChatGptDemoMainForm;

implementation

{$R *.dfm}

const
    SectionWindow      = 'Window';
    SectionData        = 'Data';
    KeyTop             = 'Top';
    KeyLeft            = 'Left';
    KeyWidth           = 'Width';
    KeyHeight          = 'Height';
    KeyDisplayMemo     = 'DisplayHeight';
    KeyApiKey          = 'ApiKey';

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ TChatGptDemoMainForm }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TChatGptDemoMainForm.Create(AOwner: TComponent);
var
    Path : array [0..MAX_PATH] of Char;
begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @Path[0]);
    FIniSection     := SectionWindow;
    FIniSectionData := SectionData;
    FAppName        := ChangeFileExt(ExtractFileName(Application.ExeName), '');
    FLocalAppData   := IncludeTrailingPathDelimiter(Path) +
                       CompanyFolder + '\' + FAppName + '\';
    FIniFileName    := FLocalAppData + FAppName + '.ini';
    FFullScreen     := FALSE;
    inherited Create(AOwner);
    DisplayMemo.Clear;
    QuestionMemo.Clear;
    AnswerMemo.Clear;
    Caption := ProgName + ' V' + ProgVer;
{$IF DEFINED(WIN32)}
    Display(Caption + ' (32 bit)');
{$ELSEIF DEFINED(WIN64)}
    Display(Caption + ' (64 bit)');
{$ELSE}
    Display(Caption);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.DoShow;
var
    IniFile : TIniFile;
    I       : Integer;
begin
    if not FInitialized then begin
        FInitialized := TRUE;

        ForceDirectories(ExtractFilePath(FIniFileName));
        IniFile := TIniFile.Create(FIniFileName);
        try
            Width  := IniFile.ReadInteger(FIniSection, KeyWidth,  Width);
            Height := IniFile.ReadInteger(FIniSection, KeyHeight, Height);
            Top    := IniFile.ReadInteger(FIniSection, KeyTop,
                                          (Screen.Height - Height) div 2);
            Left   := IniFile.ReadInteger(FIniSection, KeyLeft,
                                          (Screen.Width  - Width)  div 2);
            DisplayMemo.Height      := IniFile.ReadInteger(
                                                      FIniSectionData,
                                                      KeyDisplayMemo,
                                                      DisplayMemo.Height);
            FApiKey := Trim(IniFile.ReadString(FIniSectionData, KeyApiKey, ''));
        finally
            IniFile.Destroy;
        end;

        // Check if form is on an existing monitor
        I := 0;
        while I < Screen.MonitorCount do begin
            if (Top >= Screen.Monitors[I].Top) and
               (Top <= (Screen.Monitors[I].Top +
                             Screen.Monitors[I].Height)) and
               (Left >= Screen.Monitors[I].Left) and
               (Left <= (Screen.Monitors[I].Left +
                              Screen.Monitors[I].Width)) then
                break;
            Inc(I);
        end;
        if I >= Screen.MonitorCount then begin
            // Form is outside of any monitor. Move to center of main monitor
            Top  := (Screen.Height - Height) div 2;
            Left := (Screen.Width  - Width)  div 2;
        end;

        PostMessage(Handle, WM_APP_STARTUP, 0, 0);
    end;
    inherited DoShow;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.DoClose(var Action: TCloseAction);
var
    IniFile : TIniFile;
begin
    try
        IniFile := TIniFile.Create(FIniFileName);
        try
            IniFile.WriteInteger(FIniSection, KeyTop,    Top);
            IniFile.WriteInteger(FIniSection, KeyLeft,   Left);
            IniFile.WriteInteger(FIniSection, KeyWidth,  Width);
            IniFile.WriteInteger(FIniSection, KeyHeight, Height);
            IniFile.WriteInteger(
                           FIniSectionData, KeyDisplayMemo,
                           DisplayMemo.Height);
            IniFile.WriteString(FIniSectionData, KeyApiKey, FApiKey);
        finally
            IniFile.Destroy;
        end;
    except
        // Ignore any exception when saving window size and position
    end;
    inherited DoClose(Action);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.Display(const Msg: String);
begin
    if csDestroying in ComponentState then
        Exit;
    DisplayMemo.Lines.BeginUpdate;
    try
        if DisplayMemo.Lines.Count > MAX_DISPLAY_LINES then begin
            while DisplayMemo.Lines.Count > MAX_DISPLAY_LINES do
                DisplayMemo.Lines.Delete(0);
        end;
        DisplayMemo.Lines.Add(FormatDateTime('YYYMMDD HHNNSS ', Now) + Msg);
    finally
        DisplayMemo.Lines.EndUpdate;
        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.Display(
    const Msg : String;
    Args      : array of const);
begin
    Display(Format(Msg, Args));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.DisplayAnswer(Msg: String);
var
    Lines : TStringDynArray;
    Line  : String;
begin
    AnswerMemo.Lines.BeginUpdate;
    try
        // First display question
        AnswerMemo.Lines.Add('Q: ' + FQuestion);
        // Then display answer line by line
        AnswerMemo.Lines.Add('A:');
        Msg   := StringReplace(Msg, '\n', #10, [rfReplaceAll]);
        Lines := SplitString(Msg, #10);
        for Line in Lines do
            AnswerMemo.Lines.Add(Line);
        AnswerMemo.Lines.Add('----');
    finally
        AnswerMemo.Lines.EndUpdate;
        SendMessage(AnswerMemo.Handle, EM_SCROLLCARET, 0, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.WMAppStartup(var Msg: TMessage);
begin
    //
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.AskButtonClick(Sender: TObject);
var
    QObj     : ISuperObject;
    QString  : UTF8String;
begin
    if FApiKey = '' then begin
        FApiKey := Trim(InputBox('You need an API key', 'Your key', ''));
        if FApiKey = '' then
            Exit;
    end;

    // Build the JSON request to post to the API
    // See the documentation: https://beta.openai.com/docs/introduction
    FQuestion := Trim(QuestionMemo.Text);
    QObj := SO(['model',       'text-davinci-003',
                'prompt',      FQuestion,
                'max_tokens',  2048,
                'temperature', 0]);
    QString := QObj.AsJson;

    SslHttpCli1.URL        := 'https://api.openai.com/v1/completions';
    SslHttpCli1.RcvdStream := TMemoryStream.Create;  // For answer
    SslHttpCli1.SendStream := TMemoryStream.Create;  // For post data
    QObj.SaveTo(SslHttpCli1.SendStream);             // Set post data
    SslHttpCli1.SendStream.Position := 0;            // Send from start!
    SslHttpCli1.ExtraHeaders.Clear;
    SslHttpCli1.ExtraHeaders.Add('Authorization: Bearer ' + FApiKey);
    SslHttpCli1.ExtraHeaders.Add('Content-Type: application/json');
    SslHttpCli1.ContentTypePost := 'application/json';
    SslHttpCli1.PostAsync;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.SslHttpCli1Command(Sender: TObject;
  var S: string);
begin
    if ShowHttpDetailsCheckBox.Checked then
        Display('cmd> ' + S);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.SslHttpCli1HeaderData(Sender: TObject);
begin
    if ShowHttpDetailsCheckBox.Checked then
        Display(SslHttpCli1.LastResponse);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.SslHttpCli1RequestDone(
    Sender: TObject;
    RqType: THttpRequest;
    ErrCode: Word);
var
    Buf           : UTF8String;
    Ans           : ISuperObject;
    AnsObject     : String;
    AnsChoices    : ISuperObject;
    AnsChoice     : ISuperObject;
    AnsChoiceText : String;

begin
    if ErrCode <> 0 then
        Display('Error %d', [ErrCode])
    else if SslHttpCli1.StatusCode <> 200 then begin
        Display('HTTP error %d', [SslHttpCli1.StatusCode]);
        if SslHttpCli1.StatusCode = 401 then
            Display('Authentication error, check your API key (In INI file).');
    end
    else begin
        SetLength(Buf, SslHttpCli1.RcvdStream.Size);
        Move((SslHttpCli1.RcvdStream as TMemoryStream).Memory^, Buf[1], SslHttpCli1.RcvdStream.Size);
//        if ShowHttpDetailsCheckBox.Checked then
            Display('%s', [Buf]);
        Ans        := SO(String(Buf));
        AnsObject  := Ans.AsObject.S['object'];
        AnsChoices := Ans.AsObject.O['choices'];
        for AnsChoice in AnsChoices do begin
            AnsChoiceText := AnsChoice.AsObject.S['text'];
            DisplayAnswer(AnsChoiceText);
        end;
    end;

    SslHttpCli1.RcvdStream.Free;
    SslHttpCli1.RcvdStream := nil;
    SslHttpCli1.SendStream.Free;
    SslHttpCli1.SendStream := nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TChatGptDemoMainForm.ClearAnswerMemoButtonClick(Sender: TObject);
begin
    AnswerMemo.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
