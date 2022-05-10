/// <summary>
/// Page UserActivity (ID 50101).
/// </summary>
page 50101 UserActivity
{
    Caption = 'UserActivity';
    PageType = CardPart;
    SourceTable = UserActivity;

    layout
    {
        area(content)
        {
            group(General)
            {
                cuegroup(Group)
                {
                    Caption = 'Group Name';
                    field(Field1; MyCueValue())
                    {
                        ApplicationArea = All;
                        Caption = 'My Field 1';
                        ToolTip = 'My Field 1';
                        Image = Heart;
                        Style = Favorable;

                        trigger OnDrillDown()
                        begin
                            Sleep(1000);
                        end;
                    }
                    field(Field2; Rec."No. of Customers")
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Customers';
                        ToolTip = 'My Field 2';
                        Style = Strong;
                    }
                    field(Field3; MyCueValue())
                    {
                        ApplicationArea = All;
                        Caption = 'My Field 3';
                        ToolTip = 'My Field 3';
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
                        RunObject = Codeunit CreateSalesInvoice;
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

    local procedure MyCueValue(): Integer
    begin
        exit(2);
    end;
}
