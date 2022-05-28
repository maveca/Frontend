/// <summary>
/// Table Web Service Setup (ID 50102).
/// </summary>
table 50102 "Web Service Setup"
{
    Caption = 'Web Service Setup';
    DataClassification = SystemMetadata;

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
        field(8; "Default System Version"; Text[10])
        {
            Caption = 'Default System Version';
            DataClassification = SystemMetadata;
        }
        field(20; "Custom API Publisher"; Text[20])
        {
            Caption = 'API Publisher';
            DataClassification = SystemMetadata;
        }
        field(21; "Custom API Group"; Text[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'API Group';
        }
        field(22; "Custom API Version"; Text[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'API Version';
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
