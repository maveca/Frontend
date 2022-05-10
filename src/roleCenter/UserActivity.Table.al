/// <summary>
/// Table UserActivity (ID 50100).
/// </summary>
table 50100 UserActivity
{
    Caption = 'UserActivity';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'PrimaryKey';
            DataClassification = SystemMetadata;
        }
        field(2; "No. of Customers"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Customer);
            Caption = 'No. of Customers';
        }
        field(3; "No. of Cart Entries"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Cart Entry");
            Caption = 'No. of Cart Entries';
        }
        field(4; "No . of Bikes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = const('BIKE')));

        }
        field(5; "No . of Chairs"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = const('CHAIR')));
        }
        field(6; "Total Quantity"; Decimal)
        {
            Caption = 'Total Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Cart Entry".Quantity);
        }
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}
