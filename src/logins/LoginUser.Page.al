/// <summary>
/// Page Login Card (ID 50106).
/// </summary>
page 50109 "Login User"
{
    Caption = 'Login User';
    PageType = StandardDialog;
    SourceTable = Login;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableTemporary = true;
    DataCaptionExpression = Rec.Name;

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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        LoginManagement: Codeunit "Login Management";
    begin
        if CloseAction <> Action::LookupCancel then
            if not LoginManagement.CheckPassword(Rec."User Name", Rec.Password) then
                Error('Your password does not match to user.');

        Rec.Password := '';
        Rec.Modify();
        exit(true);
    end;
}
