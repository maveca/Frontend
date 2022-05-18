/// <summary>
/// Page UserActivity (ID 50101).
/// </summary>
page 50116 "LoginActivity"
{
    Caption = 'Card Info';
    PageType = CardPart;
    SourceTable = UserActivity;
    RefreshOnActivate = true;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                // cuegroup(Group)
                // {
                //     ShowCaption = false;
                //     Visible = IsLoggedIn;
                //     field(Field1; Rec."No. of Cart Entries")
                //     {
                //         Caption = 'No. of Items';
                //         ApplicationArea = All;
                //         Image = Checklist;
                //         Style = Favorable;
                //         ToolTip = 'Specifies the value of the No. of Cart Entries field.';
                //     }
                // }
                cuegroup(Totals)
                {
                    CuegroupLayout = Wide;
                    Visible = IsLoggedIn;
                    ShowCaption = false;
                    field(TotalAmount; Rec."Total Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Total Amount field.';
                        ShowCaption = false;
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
        IsLoggedIn := GetCurrentUser() <> '';
    end;

    local procedure GetCurrentUser(): Text[250]
    var
        LoginManagement: Codeunit "Login Management";
    begin
        exit(LoginManagement.GetCurrentUser());
    end;

    var
        IsLoggedIn: Boolean;
}
