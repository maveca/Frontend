/// <summary>
/// Page Resource Event Matrix (ID 50113).
/// </summary>
page 50113 "Resource Event Matrix"
{
    ApplicationArea = All;
    Caption = 'Resource Event Matrix';
    PageType = List;
    SourceTable = Resource;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies a number for the resource.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies a description of the resource.';
                    ApplicationArea = All;
                }
                /////////////////////////////////////////////////////////////////////////////////
                field(Day1; dayQuantity[1])
                {
                    Caption = '1';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the 1 field.';
                    BlankZero = true;
                    StyleExpr = day1SourceExp;
                    CaptionClass = '1,5,,' + DayCaption01;

                    trigger OnValidate()
                    begin
                        InsertResourceEvent(1);
                    end;
                }
                field(Day2; dayQuantity[2])
                {
                    Caption = '2';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the 2 field.';
                    BlankZero = true;
                    StyleExpr = day2SourceExp;
                    CaptionClass = '1,5,,' + DayCaption02;

                    trigger OnValidate()
                    begin
                        InsertResourceEvent(2);
                    end;
                }
                field(Day3; dayQuantity[3])
                {
                    Caption = '3';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the 3 field.';
                    BlankZero = true;
                    StyleExpr = day3SourceExp;
                    CaptionClass = '1,5,,' + DayCaption03;

                    trigger OnValidate()
                    begin
                        InsertResourceEvent(3);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumnCaption();
    end;

    trigger OnAfterGetRecord()
    var
        i: Integer;
    begin
        for i := 1 to 31 do
            dayQuantity[i] := GetDay(i);

        SetSourceExp();
    end;

    var
        dayQuantity: array[31] of Decimal;
        day1SourceExp, day2SourceExp, day3SourceExp : Text;
        DayCaption01, DayCaption02, DayCaption03 : Text;

    local procedure GetDay(day: Integer): Decimal
    var
        ResourceEvent: Record "Resource Event";
    begin
        ResourceEvent.SetRange("Resource No.", Rec."No.");
        ResourceEvent.SetRange("Posting Date", DMY2Date(day, Date2DMY(Today(), 2), Date2DMY(Today(), 3)));
        ResourceEvent.CalcSums(Quantity);
        exit(ResourceEvent.Quantity);
    end;

    local procedure InsertResourceEvent(day: Integer)
    var
        ResourceEvent: Record "Resource Event";
        PreQty: Decimal;
    begin
        PreQty := GetDay(day);

        ResourceEvent.Init();
        ResourceEvent."Entry No." := 0;
        ResourceEvent.Insert(true);

        ResourceEvent.Validate("Resource No.", Rec."No.");
        ResourceEvent.Validate("Posting Date", DMY2Date(day, Date2DMY(Today(), 2), Date2DMY(Today(), 3)));
        ResourceEvent.Validate(Quantity, dayQuantity[day] - PreQty);
        ResourceEvent.Modify(true);
    end;

    local procedure GetStyleExpr(day: Integer): Text
    var
        qty: Decimal;
    begin
        qty := GetDay(day);
        case true of
            qty < 0:
                exit('Attention');
            qty > 10:
                exit('Favorable');
            else
                exit('None')
        end;
    end;

    local procedure SetSourceExp()
    begin
        day1SourceExp := GetStyleExpr(1);
        day2SourceExp := GetStyleExpr(2);
        day3SourceExp := GetStyleExpr(3);
    end;

    local procedure SetColumnCaption()
    var
        newLine: Text;
    begin
        newLine := ' - ';
        DayCaption01 := format(1) + newLine + GetDayName(DMY2Date(1, Date2DMY(Today(), 2), Date2DMY(Today(), 3)));
        DayCaption02 := format(2) + newLine + GetDayName(DMY2Date(2, Date2DMY(Today(), 2), Date2DMY(Today(), 3)));
        DayCaption03 := format(3) + newLine + GetDayName(DMY2Date(3, Date2DMY(Today(), 2), Date2DMY(Today(), 3)));
    end;

    local procedure GetDayName(day: Date): Text
    var
        DateRec: Record Date;
    begin
        DateRec.SetRange(DateRec."Period Type", DateRec."Period Type"::Date);
        DateRec.SetRange(DateRec."Period Start", day);
        if DateRec.FindFirst() then
            exit(DateRec."Period Name")
        else
            exit('');
    end;
}
