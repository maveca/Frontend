/// <summary>
/// Page Login Card (ID 50106).
/// </summary>
page 50107 "Register User"
{
    Caption = 'Register User';
    PageType = StandardDialog;
    SourceTable = Login;
    ShowFilter = false;
    DataCaptionExpression = Rec.Name;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Mail; Rec.Mail)
                {
                    ToolTip = 'Specifies the value of the E-mail field.';
                    ApplicationArea = All;
                }
            }
            group(Login)
            {
                Caption = 'Login';
                Editable = IsLookupPage;
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
            }
            group(Setup)
            {
                Visible = IsAdmin;
                field(Member; Rec.Member)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shop Member property.';
                }
                field(Admin; Rec.Admin)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Administrator property.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        LoginManagement: Codeunit "Login Management";
    begin
        IsLookupPage := CurrPage.LookupMode();
        IsAdmin := LoginManagement.GetCurrentLogin().Admin;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LoginManagement: Codeunit "Login Management";
    begin
        if CurrPage.LookupMode() then begin
            TestData();
            LoginManagement.StorePassword(Rec."User Name", Rec.Password);
            Rec.Password := '';
        end;
    end;

    local procedure TestData()
    begin
        Rec.TestField("User Name");
        Rec.TestField(Password);
        if StrLen(Rec.Password) < 5 then
            Error('Your password must be at least 5 characters long.');
    end;

    var
        IsLookupPage: Boolean;
        IsAdmin: Boolean;
}
