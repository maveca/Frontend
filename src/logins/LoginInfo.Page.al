/// <summary>
/// Page Login Info (ID 50110).
/// </summary>
page 50110 "Login Info"
{
    Caption = 'Login Info';
    PageType = CardPart;
    Editable = false;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field("Name"; LoginManagement.GetCurrentLogin().Name)
                {
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the User Name field.';
                    ApplicationArea = All;
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
                    LoginMgt: Codeunit "Login Management";
                begin
                    TempLogin.Init();
                    TempLogin.Insert(true);
                    if Page.RunModal(Page::"Login User", TempLogin) = Action::LookupOk then
                        LoginMgt.SetCurrentUser(TempLogin."User Name");
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
                    PasswordCodeunit: Codeunit "Login Management";
                begin
                    PasswordCodeunit.SetCurrentUser('');
                end;
            }
            action(RegisterNewUser)
            {
                ApplicationArea = All;
                Caption = 'Register as New User';
                Promoted = true;
                PromotedOnly = true;
                Image = NewCustomer;
                ToolTip = 'Executes the Register New User action.';

                trigger OnAction()
                var
                    TempLogin: Record Login temporary;
                    Login: Record Login;
                begin
                    TempLogin.Init();
                    TempLogin.Insert();
                    if Page.RunModal(Page::"Register User", TempLogin) = Action::LookupOK then begin
                        Login.Init();
                        Login.TransferFields(TempLogin);
                        Login.Insert(true);
                    end;
                end;
            }
            group(Admin)
            {
                Caption = 'Administrator';
                Enabled = IsAdmin;

                action(UserList)
                {
                    Caption = 'User List';
                    ApplicationArea = All;
                    RunObject = Page "Login List";
                    ToolTip = 'Executes the User List action.';
                    Image = List;
                    Visible = IsAdmin;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsAdmin := LoginManagement.GetCurrentLogin().Admin;
    end;

    var
        LoginManagement: Codeunit "Login Management";
        IsAdmin: Boolean;
}
