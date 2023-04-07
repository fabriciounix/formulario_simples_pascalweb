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



public TUploadedFiles = Class(TCollection)
  Function First: TUploadedFile;
  Function Last: TUploadedFile;
  Function IndexOfFile(AName: String) : Integer;
  Function FileByName(AName: String) : TUploadedFile;
  Function FindFile(AName: String) : TUploadedFile;
  Property Files[Index: Integer] : TUploadedFile read GetFile Write SetFile; default;
end;

  TUploadedFile = Class(TCollectionItem)
...
Public
  Destructor Destroy; override;
  Property FieldName: String Read FFieldName Write FFieldName;
  Property FileName: String Read FFileName Write FFileName;
  Property Stream: TStream Read GetStream;
  Property Size: Int64 Read FSize Write FSize;
  Property ContentType: String Read FContentType Write FContentType;
  Property Disposition: String Read FDisposition Write FDisposition;
  Property LocalFileName: String Read FLocalFileName Write FLocalFileName;
  Property Description: String Read FDescription Write FDescription;
end;

procedure TFPWebModule1.DataModuleRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  n: Integer;
  f: TUploadedFile;
  i: Integer;
begin
  n := ARequest.Files.Count;
  if n = 0 then
    with AResponse.Contents do
    begin
      Add('<form id="form" action="' + ARequest.URI + '" method="POST" enctype="multipart/form-data">');
      Add('<label for="name">Drag n drop or click to add file:</label>');
      Add('<input type="file" name="input" />');
      Add('<input type="submit" value="Send" />');
      Add('</form>');
    end
  else
  begin
    f := ARequest.Files[0];
    AResponse.Contents.LoadFromStream(f.Stream);
  end;
  Handled := true;
end;

initialization
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);
end.

