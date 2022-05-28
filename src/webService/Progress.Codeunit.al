/// <summary>
/// Codeunit "Progress"Indicator (ID 50109).
/// </summary>
codeunit 50109 Progress
{
    trigger OnRun()
    var
        Progress: Codeunit Progress;
        i: Integer;
    begin
        Progress.Open('Downloading items', 1000);
        for i := 1 to 1000 do begin
            Sleep(1);
            Progress.Next();
        end;
        Progress.Close();
    end;

    /// <summary>
    /// Opens Progress dialog.
    /// </summary>
    /// <param name="WindowTitle">Text.</param>
    /// <param name="Count">Integer.</param>
    procedure Open(WindowTitle: Text; Count: Integer)
    begin
        ProgressIndex := 0;
        ProgressCount := Count;
        ProgressRatio := 0;
        WindowLine1 := WindowTitle;
        WindowLine3 := ' ';
        WindowDialog.Open(WindowTitleLbl, WindowLine1, WindowLine2, WindowLine3, WindowLine4);
        LastUpdated := CurrentDateTime();
        Update();
    end;

    /// <summary>
    /// Next step in the loop of counting.
    /// </summary>
    procedure Next()
    begin
        Next(1);
    end;

    /// <summary>
    /// Update window.
    /// </summary>
    procedure Update()
    begin
        Next(0);
    end;

    /// <summary>
    /// Update window with Title.
    /// </summary>
    /// <param name="WindowTitle">Title for Progress</param>
    procedure Update(WindowTitle: Text)
    begin
        WindowLine1 := WindowTitle;
    end;

    /// <summary>
    /// Next n steps in the loop of counting. 
    /// </summary>
    /// <param name="Step">Use Step as 0 for forcefully update window.</param>
    procedure Next(Step: Integer)
    begin
        ProgressIndex := ProgressIndex + Step;
        ProgressRatio := Round((ProgressIndex * 100) / ProgressCount, 1);
        WindowLine2 := StrSubstNo(WindowLine1Lbl, ProgressIndex, ProgressCount);
        WindowLine4 := String.PadLeft(ProgressRatio, '|') + String.PadLeft(100 - ProgressRatio, '.');
        WindowLine4 := WindowLine4.Substring(1, 50) + StrSubstNo(WindowLine2Lbl, ProgressRatio) + WindowLine4.Substring(51);
        if (CurrentDateTime() - LastUpdated > 1000) or (Step = 0) then begin
            WindowDialog.Update();
            LastUpdated := CurrentDateTime();
        end;
    end;

    /// <summary>
    /// Close Dialog and wait 1 second to see the results.
    /// </summary>
    procedure Close()
    begin
        Update();
        WindowDialog.Close();
    end;

    var
        WindowDialog: Dialog;
        ProgressIndex: Integer;
        ProgressCount: Integer;
        ProgressRatio: Integer;
        WindowLine1, WindowLine2, WindowLine3, WindowLine4 : Text;
        String: Text;
        WindowTitleLbl: Label '#1 #2 #3 #4', Locked = true;
        WindowLine1Lbl: Label '%1 of %2', Comment = '%1 = index, %2 = count.';
        WindowLine2Lbl: Label ' %1% ', Locked = true;
        LastUpdated: DateTime;
}
