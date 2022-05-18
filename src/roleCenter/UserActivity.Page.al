/// <summary>
/// Page UserActivity (ID 50101).
/// </summary>
page 50101 UserActivity
{
    Caption = 'UserActivity';
    PageType = CardPart;
    SourceTable = UserActivity;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'What if this is very very long text?';

                cuegroup(Totals)
                {
                    CuegroupLayout = Wide;
                    field(TotalAmount; Rec."Total Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Total Amount field.';
                    }
                }
                cuegroup(Group)
                {
                    ShowCaption = false;
                    Visible = IsAdmin;
                    field(Field1; Rec."No. of Cart Entries")
                    {
                        ApplicationArea = All;
                        Image = Checklist;
                        Style = Favorable;
                        ToolTip = 'Specifies the value of the No. of Cart Entries field.';
                    }
                    field(Field2; Rec."No . of Chairs")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Chairs';
                        Image = Checklist;
                        Style = Favorable;
                        ToolTip = 'Specifies the value of the No. of Chairs field.';
                    }
                    field(Field3; Rec."No . of Bikes")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Bikes';
                        Image = Checklist;
                        Style = Favorable;
                        ToolTip = 'Specifies the value of the No. of Bikes field.';
                    }
                    field(Field4; Rec."Total Quantity")
                    {
                        ApplicationArea = All;
                        Image = Checklist;
                        Style = Favorable;
                        ToolTip = 'Total Quantity from Cart';
                    }
                }

            }
            cuegroup(Group2)
            {
                Caption = 'Test Actions';
                actions
                {

                    action(ActionName)
                    {
                        Image = TileBrickNew;
                        Caption = 'Create Sales Invoice';
                        ToolTip = 'This action will create new sales invoice and then hopefully also post it.';
                        RunObject = Codeunit "CreateSalesDoc";
                    }

                    action(ActionYellow)
                    {
                        Image = TileYellow;
                        ToolTip = 'Yellow action';
                        Caption = 'Payment';
                        RunObject = Codeunit Pay;
                    }
                    action(ActionAPI)
                    {
                        Image = TileCyan;
                        ToolTip = 'Call API';
                        Caption = 'Get Items';
                        RunObject = Codeunit WSGetItems;
                    }
                    action(ActionAPIPost)
                    {
                        Image = TileGreen;
                        ToolTip = 'Demonstrate Password';
                        Caption = 'Password';
                        RunObject = Codeunit "Login Management";
                    }

                    action(LoginAction)
                    {
                        Image = TileRed;
                        ToolTip = 'Login as a User';
                        Caption = 'Login';

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
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        If not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IsAdmin := IsAdministrator();
    end;

    local procedure IsAdministrator(): Boolean
    var
        LoginManagement: Codeunit "Login Management";
    begin
        exit(LoginManagement.GetCurrentLogin().Admin);
    end;

    var
        IsAdmin: Boolean;
}
