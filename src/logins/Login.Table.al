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
            Caption = 'Shop Member';
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
        field(6; Admin; Boolean)
        {
            Caption = 'Administrator';
            DataClassification = AccountData;
        }
        field(7; Name; Text[100])
        {
            Caption = 'Name';
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

    /// <summary>
    /// SetUser.
    /// </summary>
    /// <param name="UserName">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SetUser(UserName: Text): Boolean
    begin
        SetRange("User Name", UserName);
        exit(FindFirst());
    end;
}
