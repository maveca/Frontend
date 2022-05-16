/// <summary>
/// Page Login Card (ID 50106).
/// </summary>
page 50107 "Register User"
{
    Caption = 'Register User';
    PageType = Card;
    SourceTable = Login;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field(Mail; Rec.Mail)
                {
                    ToolTip = 'Specifies the value of the E-mail field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Init();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PasswordCodeunit: Codeunit Password;
    begin
        Rec.TestField("User Name");
        Rec.TestField(Password);
        if StrLen(Rec.Password) < 5 then
            Error('Your password must be at least 5 characters long.');
        PasswordCodeunit.StorePassword(Rec."User Name", Rec.Password);
        Rec.Password := '';
        Rec.Modify(true);
    end;
}
