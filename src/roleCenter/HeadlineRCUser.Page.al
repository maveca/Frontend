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
                        DrillDownURLTxt: Label 'https://betsandbox.westeurope.cloudapp.azure.com/E1/', Locked = True;
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
        LoginManagement: Codeunit "Login Management";
        FrontLbl: Label '<qualifier>Frontend</qualifier><payload>Hello dear <emphasize>%1</emphasize>, welcome to our shop.</payload>', Comment = '%1 = Username';
        BackLbl: Label '<qualifier>Frontend</qualifier><payload>Please login or register as user.</payload>';
    begin
        if LoginManagement.GetCurrentUser() = '' then
            exit(BackLbl)
        else
            exit(StrSubstNo(FrontLbl, LoginManagement.GetCurrentLogin().Name));
    end;

    local procedure GetHeadingText2(): Text
    begin
        Exit('<qualifier>Backend</qualifier><payload>Open backend of <emphasize>Business Central</emphasize>.</payload>');
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";

}
