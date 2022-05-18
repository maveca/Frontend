/// <summary>
/// Page Headline RC User (ID 50106).
/// </summary>
page 50106 "Headline RC User"
{
    Caption = 'Headline RC User';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

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
    var
        PasswordCodeunit: Codeunit Password;
    begin
        Exit(StrSubstNo('Hello dear %1', PasswordCodeunit.GetCurrentUser()));
    end;

    local procedure GetHeadingText2(): Text
    begin
        Exit('<qualifier>Title</qualifier><payload>This is the <emphasize>Headline</emphasize>.</payload>');
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";

}
