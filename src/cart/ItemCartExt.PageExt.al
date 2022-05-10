/// <summary>
/// PageExtension Item Cart Ext. (ID 50100) extends Record Item Card.
/// </summary>
pageextension 50100 "Item Cart Ext." extends "Item Card"
{

    actions
    {
        addafter(ItemActionGroup)
        {
            action(AddToCart)
            {
                Caption = 'Add to Cart';

                ApplicationArea = All;
                ToolTip = 'Executes the Add to Cart action.';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;

                RunObject = codeunit "Add to Cart";
            }
        }
    }
}
