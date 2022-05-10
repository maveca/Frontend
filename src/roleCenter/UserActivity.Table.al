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
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}
