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
                cuegroup(Group)
                {
                    Caption = 'Group Name';
                    field(Field1; Rec."No. of Cart Entries")
                    {
                        ApplicationArea = All;
                        ToolTip = 'No. of Cart Entries';
                        Image = Checklist;
                        Style = Favorable;
                    }
                    field(Field2; Rec."No . of Chairs")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Chairs';
                        ToolTip = 'My Field 2';
                        Image = Checklist;
                        Style = Favorable;
                    }
                    field(Field3; Rec."No . of Bikes")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Bikes';
                        ToolTip = 'My Field 3';
                        Image = Checklist;
                        Style = Favorable;
                    }
                    field(Field4; Rec."Total Quantity")
                    {
                        ApplicationArea = All;

                        ToolTip = 'My Field 3';
                        Image = Checklist;
                        Style = Favorable;
                    }
                }
            }
            cuegroup(Group2)
            {
                actions
                {

                    action(ActionName)
                    {
                        Image = TileBrickNew;
                        Caption = 'Create Sales Invoice';
                        ToolTip = 'This action will create new sales invoice and then hopefully also post it.';
                        RunObject = Codeunit Buy;
                    }

                    action(ActionYellow)
                    {
                        Image = TileYellow;
                        ToolTip = 'Yellow action';

                        trigger OnAction()
                        begin
                            Message('Goodbye!');
                        end;
                    }
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        If not Rec.FindFirst() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
