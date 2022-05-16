/// <summary>
/// Page Login Info (ID 50110).
/// </summary>
page 50110 "Login Info"
{
    Caption = 'Login Info';
    PageType = CardPart;
    SourceTable = Login;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Please write some text that we will have better Card Part.';
                field("User Name"; Rec."User Name")
                {
                    Caption = 'User';
                    ToolTip = 'Specifies the value of the User Name field.';
                    ApplicationArea = All;
                    Width = 50;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Login)
            {
                ApplicationArea = All;
                Caption = 'Login';
                Promoted = true;
                PromotedOnly = true;
                Image = User;
                ToolTip = 'Executes the Login action.';

                trigger OnAction()
                var
                    TempLogin: Record Login temporary;
                begin
                    TempLogin.Init();
                    TempLogin.Insert(true);
                    if Page.RunModal(Page::"Login User", TempLogin) = Action::Cancel then
                        Error('Login has been canceled by user.')
                end;
            }
            action(LogOut)
            {
                ApplicationArea = All;
                Caption = 'Logout';
                Promoted = true;
                PromotedOnly = true;
                Image = Absence;
                ToolTip = 'Executes the LogOut action.';

                trigger OnAction()
                begin
                    Rec.Init();
                end;
            }

            action(RegisterNewUser)
            {
                ApplicationArea = All;
                Caption = 'Register New User';
                Promoted = true;
                PromotedOnly = true;
                Image = NewCustomer;
                ToolTip = 'Executes the Register New User action.';

                trigger OnAction()
                begin
                    Rec.Init();
                    Page.RunModal(Page::"Register User", Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Init();
    end;
}
