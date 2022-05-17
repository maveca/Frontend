pageextension 50101 "Item List Ext" extends "Item List"
{
    actions
    {
        addlast(processing)
        {
            action(GetSelection)
            {
                ApplicationArea = All;

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
