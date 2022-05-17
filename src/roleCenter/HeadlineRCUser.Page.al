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
                    Caption = 'Heading with Link';
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        DrillDownURLTxt: Label 'https://go.microsoft.com/fwlink/?linkid=867580', Locked = True;
                    begin
                        Hyperlink(DrillDownURLTxt)
                    end;
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
        Exit('The longer the text message is (the more SMS parts there are), the more it costs. Standard Character Set. The maximum message length is 918 characters.');
    end;

    local procedure GetHeadingText2(): Text
    begin
        Exit('<qualifier>Title</qualifier><payload>This is the <emphasize>Headline</emphasize>.</payload>');
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";

}
