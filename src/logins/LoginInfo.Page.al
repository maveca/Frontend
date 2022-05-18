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
                    PasswordCodeunit: Codeunit Password;
                begin
                    TempLogin.Init();
                    TempLogin.Insert(true);
                    if Page.RunModal(Page::"Login User", TempLogin) = Action::Ok then begin
                        PasswordCodeunit.SetCurrentUser(TempLogin."User Name");
                        Rec.SetUser(TempLogin."User Name");
                    end;
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
                var
                    PasswordCodeunit: Codeunit "Password";
                begin
                    PasswordCodeunit.SetCurrentUser('');
                    Rec.SetUser('');
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
    var
        Password: Codeunit Password;
    begin
        if not Rec.SetUser(Password.GetCurrentUser()) then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
