/// <summary>
/// PageExtension extends Page Resource Card to demonstrate big Text data.
/// </summary>
pageextension 50102 "Resource Card" extends "Resource Card"
{
    layout
    {
        addafter(Name)
        {
            usercontrol(UserControlDesc; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    IsReady := true;
                    ReadBlob();
                end;

                trigger Callback(data: Text)
                var
                    OutStream: OutStream;
                begin
                    Rec."Long Text".CreateOutStream(OutStream, TextEncoding::UTF8);
                    OutStream.Write(data);
                    Rec.Modify();
                end;
            }
        }
    }

    var
        IsReady: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        if IsReady then
            ReadBlob();
    end;

    local procedure ReadBlob()
    var
        data: Text;
        InStream: InStream;
    begin
        Clear(data);
        Rec.CalcFields("Long Text");
        if Rec."Long Text".HasValue() then begin
            Rec."Long Text".CreateInStream(InStream, TextEncoding::UTF8);
            InStream.Read(data);
        end;
        CurrPage.UserControlDesc.SetContent(ControlHtml(data));
    end;

    local procedure ControlHtml(data: Text): Text
    var
        readonly: Text;
        backgroundColor: Text;
        border: Text;
    begin
        if not CurrPage.Editable() then begin
            readonly := ' readonly ';
            backgroundColor := ' background-color: rgb(229, 231, 233) !important; ';
            border := ' border: 0px none white; ';
        end;
        exit(
            '<textarea Id="TextArea" maxlength="2024" ' +
                readonly +
                'style="width:100%; height:100%; padding: 5px; resize: none; color: rgb(33, 33, 33); ' +
                    backgroundColor + border +
                    'font-family:''Segoe UI'' !important; font-size: 14px !important;" ' +
                'OnChange="window.parent.WebPageViewerHelper.TriggerCallback(document.getElementById(''TextArea'').value)"' +
            '>' + data + '</textarea>'
        );
    end;
}
