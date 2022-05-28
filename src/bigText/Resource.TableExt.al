/// <summary>
/// Adding one big blog field.
/// </summary>
tableextension 50100 Resource extends Resource
{
    fields
    {
        field(50100; "Long Text"; Blob)
        {
            Caption = 'Long Text';
            DataClassification = CustomerContent;
        }
    }
}
