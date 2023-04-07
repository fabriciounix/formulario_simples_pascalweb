unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb;

type

  { TFPWebModule1 }

  TFPWebModule1 = class(TFPWebModule)
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private

  public

  end;

var
  FPWebModule1: TFPWebModule1;

implementation

{$R *.lfm}

{ TFPWebModule1 }

procedure TFPWebModule1.DataModuleRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  LName: String;
begin
  LName := ARequest.ContentFields.Values['Name'];
  if LName = EmptyStr then
    with AResponse.Contents do
    begin
      Add('<form action="' + ARequest.URI + '" method="POST"');
      Add('<label for="name">Please tell me your name:</label>');
      Add('<input type="text" name="name" id="name" />');
      Add('<input type="submit" value="Send" />');
      Add('</form>');
    end
  else
    AResponse.Content := 'Hello, ' + LName + '!';
  Handled := true;
end;

initialization
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);
end.

