/// <summary>
/// Page Headline RC User (ID 50106).
/// </summary>
page 50106 "Headline RC User"
{
    Caption = 'Headline RC User';
    PageType = HeadlinePart;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field(GreetingText; GetHeadingText())
                {
                    ApplicationArea = All;
                    Caption = 'Greeting headline';
                    Editable = true;
                }
                field(GreetingText2; GetHeadingText2())
                {
                    ApplicationArea = All;
                    Caption = 'Reklama';
                    Editable = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Business Manager");
    end;

    local procedure GetHeadingText(): Text
    begin
        Exit('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
    end;

    local procedure GetHeadingText2(): Text
    begin
        Exit('Blabla sdfasfdasdf asdfa sdf asdfasdfasfd.');
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";

}
