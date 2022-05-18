/// <summary>
/// Page UserActivity (ID 50101).
/// </summary>
page 50101 UserActivity
{
    Caption = 'Public Activity';
    PageType = CardPart;
    SourceTable = UserActivity;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                cuegroup(Group)
                {
                    ShowCaption = false;
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
                    field(Field4; Rec."No . of Furniture")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Furniture';
                        Image = Checklist;
                        Style = Favorable;
                        ToolTip = 'Specifies the value of the No. of Furniture field.';
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
