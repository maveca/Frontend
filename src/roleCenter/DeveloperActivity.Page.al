/// <summary>
/// Page UserActivity (ID 50101).
/// </summary>
page 50117 "DeveloperActivity"
{
    Caption = 'Developer Activity';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                cuegroup(Group2)
                {
                    ShowCaption = false;
                    actions
                    {

                        action(ActionName)
                        {
                            Image = TileBrickNew;
                            Caption = 'Create Sales Invoice';
                            ToolTip = 'This action will create new sales invoice and then hopefully also post it.';
                            RunObject = Codeunit "CreateSalesDoc";
                        }

                        action(ActionYellow)
                        {
                            Image = TileYellow;
                            ToolTip = 'Yellow action';
                            Caption = 'Payment';
                            RunObject = Codeunit Pay;
                        }
                        action(ActionAPI)
                        {
                            Image = TileCyan;
                            ToolTip = 'Call API';
                            Caption = 'Get Items';
                            RunObject = Codeunit WSGetItems;
                        }
                        action(ActionLogin)
                        {
                            Image = TileGreen;
                            ToolTip = 'Demonstrate Password';
                            Caption = 'Password';
                            RunObject = Codeunit "Login Management";
                        }

                        action(ActionAPIPut)
                        {
                            Image = TileGreen;
                            ToolTip = 'Demonstrate Put Method';
                            Caption = 'Update Customer';
                            RunObject = Codeunit "Update Customer";
                        }

                    }
                }
            }
        }
    }

}
