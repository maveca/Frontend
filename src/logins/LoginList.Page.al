/// <summary>
/// Page Login List (ID 50108).
/// </summary>
page 50108 "Login List"
{
    ApplicationArea = All;
    Caption = 'Login List';
    PageType = List;
    SourceTable = Login;
    UsageCategory = Administration;
    CardPageId = "Register User";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                    ApplicationArea = All;
                }
                field(Mail; Rec.Mail)
                {
                    ToolTip = 'Specifies the value of the E-mail field.';
                    ApplicationArea = All;
                }
                field(Member; Rec.Member)
                {
                    ToolTip = 'Specifies the value of the Member field.';
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ApplicationArea = All;
                }

            }
        }
    }
}
