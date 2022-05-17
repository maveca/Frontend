/// <summary>
/// Table Resource Event (ID 50104).
/// </summary>
table 50104 "Resource Event"
{
    Caption = 'Resource Event';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            DataClassification = AccountData;
            TableRelation = Resource."No.";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = AccountData;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = AccountData;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
