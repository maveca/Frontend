/// <summary>
/// Table Web Service Setup (ID 50102).
/// </summary>
table 50102 "Web Service Setup"
{
    Caption = 'Web Service Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'PrimaryKey';
            DataClassification = SystemMetadata;
        }
        field(2; "Base Url"; Text[250])
        {
            Caption = 'Base Url';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(3; UserName; Text[100])
        {
            Caption = 'User Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Default Company"; Text[30])
        {
            Caption = 'Default Company';
            DataClassification = SystemMetadata;
        }
        field(6; "Default Tenant"; Text[30])
        {
            Caption = 'Default Tenant';
            DataClassification = SystemMetadata;
        }
        field(7; "Authentication"; Enum WSAuthentication)
        {
            Caption = 'Authentication';
            DataClassification = SystemMetadata;
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
