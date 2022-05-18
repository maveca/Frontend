/// <summary>
/// Page Resource Part (ID 50118).
/// </summary>
page 50118 "Resource Part"
{
    Caption = 'Call Center';
    Editable = false;
    PageType = CardPart;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            group(p1)
            {
                ShowCaption = false;
                field(Image; Rec.Image)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies the picture that has been inserted for the resource.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies a description of the resource.';
                }
                field(Phone; '+381 1 98 84 774')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies a description of the resource.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FindFirst();
    end;
}
