/// <summary>
/// Codeunit Add to Cart (ID 50101).
/// </summary>
codeunit 50101 "Add to Cart"
{
    TableNo = Item;

    trigger OnRun()
    var
        CartEntry: Record "Cart Entry";
    begin
        CartEntry.Init();
        CartEntry."Entry No." := 0;
        CartEntry.Insert(true);
        CartEntry.Validate("Item No.", Rec."No.");
        CartEntry.Modify(true);
        Message('Item %1 is added to your cart', Rec.Description);

    end;

}
