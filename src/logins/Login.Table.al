/// <summary>
/// Table Login (ID 50103).
/// </summary>
table 50103 Login
{
    Caption = 'Login';
    DataClassification = ToBeClassified;

    fields
    {

        field(4; Id; Integer)
        {
            DataClassification = AccountData;
            AutoIncrement = true;
        }
        field(1; "User Name"; Text[250])
        {
            Caption = 'User Name';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                Rec.TestField("User Name");
            end;
        }
        field(2; Member; Boolean)
        {
            Caption = 'Member';
            DataClassification = CustomerContent;
        }
        field(3; "Mail"; Text[100])
        {
            Caption = 'E-mail';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = EndUserIdentifiableInformation;
        }
    }
    keys
    {
        key(PK; "Id")
        {
            Clustered = true;
        }
    }
}
