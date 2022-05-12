/// <summary>
/// Table Cart Entry (ID 50101).
/// </summary>
table 50101 "Cart Entry"
{
    Caption = 'Cart Entry';
    DataClassification = AccountData;
    LookupPageId = "Cart Entries";
    DrillDownPageId = "Cart Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = AccountData;
            TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                If Item.Get("Item No.") then begin
                    If Quantity = 0 then
                        Validate(Quantity, 1);
                    Validate(Description, Item.Description);
                    Validate(Price, Item."Unit Price");
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = AccountData;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = AccountData;
            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(5; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = AccountData;
            Editable = false;

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = AccountData;
            Editable = false;

            trigger OnValidate()
            begin
                Amount := Quantity * Price;
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
            SumIndexFields = Quantity;
        }
    }
}
