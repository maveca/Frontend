/// <summary>
/// Page Login Card (ID 50106).
/// </summary>
page 50109 "Login User"
{
    Caption = 'Login User';
    PageType = Card;
    SourceTable = Login;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableTemporary = true;

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
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    var

        PasswordCodeunit: Codeunit Password;
    begin
        if CloseAction = Action::Cancel then
            exit(true);

        if not PasswordCodeunit.CheckPassword(Rec."User Name", Rec.Password) then
            Error('Your password does not match to user.');

        Rec.Password := '';
        Rec.Modify();
        exit(true);
    end;
}
