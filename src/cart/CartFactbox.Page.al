page 50104 "Cart Factbox"
{
    Caption = 'Cart Factbox';
    PageType = CardPart;
    SourceTable = UserActivity;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                field("Total Quantity"; Rec."Total Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Quantity from Cart';
                }
            }
        }
    }
}
