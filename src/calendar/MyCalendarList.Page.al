page 50111 "MyCalendarList"
{
    ApplicationArea = All;
    Caption = 'My Calendar List';
    PageType = List;
    SourceTable = "Date";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the name of the period shown in the line.';
                    ApplicationArea = All;
                    Caption = 'Week Day';
                }
                field("Period Start"; Rec."Period Start")
                {
                    ToolTip = 'Specifies the starting date of the period that you want to view.';
                    ApplicationArea = All;
                    Caption = 'Date';
                }
                field("Reservation For"; GetDayReservation(Rec."Period Start"))
                {
                    Caption = 'Reservation For';
                    ToolTip = 'Specifies the value of the Reservation for field.';
                    ApplicationArea = All;
                    Style = Favorable;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Period Start", Today() - 5, CalcDate('<+CY>', Today()));
        Rec.SetRange("Period Type", Rec."Period Type"::Date);
    end;

    local procedure GetDayReservation(OnDate: Date): Text
    begin
        if OnDate = 20220516D then
            exit('Dior')
        else
            exit('');
    end;
}
