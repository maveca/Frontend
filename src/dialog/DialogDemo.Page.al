/// <summary>
/// Page DialogDemo (ID 50112).
/// </summary>
page 50112 DialogDemo
{
    Caption = 'DialogDemo';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(Field1; Field1)
            {
                ApplicationArea = All;
                Caption = 'Question';
                ToolTip = 'Specifies the value of the Question field.';
            }
            field(GroupName; 'asdfasdfkačs dfčak sdčlfkačsdkfčaskdf časdkf asdfasdfkačs dfčak sdčlfkačsdkfčaskdf časdkf asdfasdfkačs dfčak sdčlfkačsdkfčaskdf časdkf')
            {
                Caption = 'Addition Text';
            }
        }
    }

    var
        Field1: Text;

    /// <summary>
    /// GetField1.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetField1(): Text
    begin
        exit(Field1);
    end;

    /// <summary>
    /// SetField1.
    /// </summary>
    /// <param name="arg">Text.</param>
    procedure SetField1(arg: Text)
    begin
        Field1 := arg;
    end;
}
