/// <summary>
/// Page CustomerListPart (ID 50102).
/// </summary>
page 50102 CustomerListPart
{
    Caption = 'CustomerListPart';
    PageType = ListPart;
    SourceTable = Customer;
    Editable = false;
    CardPageId = "Customer Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        Sleep(1000);
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the customer''s name.';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Filter)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    DialogDemo: Page DialogDemo;
                begin
                    DialogDemo.SetField1('Defailt');
                    if DialogDemo.RunModal() = Action::Yes then
                        Message(DialogDemo.GetField1());
                end;
            }
        }
    }
}
