/// <summary>
/// Page Cart Entries (ID 50103).
/// </summary>
page 50103 "Cart Entries"
{
    ApplicationArea = All;
    Caption = 'Cart Entries';
    PageType = List;
    SourceTable = "Cart Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }
            }
            grid(Total)
            {
                GridLayout = Columns;
                group(col1)
                {
                    field(TotalAmount1; GetTotalAmount())
                    {
                        Caption = 'Total Amount';
                        ToolTip = 'Specifies the value of the Total Amount field.';
                        ApplicationArea = All;
                    }
                }
                group(col2)
                {
                    field(TotalAmount; GetTotalAmount())
                    {
                        Caption = 'Total Amount';
                        ToolTip = 'Specifies the value of the Total Amount field.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Buy)
            {
                ApplicationArea = All;
                Caption = 'Buy';
                Image = Invoice;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = codeunit "WSSendOrder";
                ToolTip = 'Executes the Buy action.';
            }
        }
    }

    local procedure GetTotalAmount(): Decimal
    var
        CartEntry: Record "Cart Entry";
    begin
        CartEntry.CalcSums(Amount);
        exit(CartEntry.Amount)
    end;
}
