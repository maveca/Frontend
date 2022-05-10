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
        CartEntry.SetRange("Item No.", Rec."No.");

        if CartEntry.FindFirst() then begin
            CartEntry.Validate(Quantity, CartEntry.Quantity + 1);
            CartEntry.Modify(true);
        end else
            AddNewEntry(Rec);
        Message('Item %1 is added to your cart', Rec.Description);
    end;

    local procedure AddNewEntry(var Rec: Record Item)
    var
        CartEntry: Record "Cart Entry";
    begin
        CartEntry.Init();
        CartEntry."Entry No." := 0;
        CartEntry.Insert(true);
        CartEntry.Validate("Item No.", Rec."No.");
        CartEntry.Modify(true);
    end;

}
