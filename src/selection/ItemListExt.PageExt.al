/// <summary>
/// PageExtension Item List Ext (ID 50101) extends Record Item List.
/// </summary>
pageextension 50101 "Item List Ext" extends "Item List"
{
    actions
    {
        addlast(processing)
        {
            action(GetSelection)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the GetSelection action.';
                Image = Select;

                trigger OnAction()
                var
                    SelectedItem: Record Item;
                begin
                    CurrPage.SetSelectionFilter(SelectedItem);

                    if SelectedItem.FindSet() then
                        repeat
                            Message('%1', SelectedItem.Description);
                        until SelectedItem.Next() = 0;
                end;
            }
        }
    }
}
