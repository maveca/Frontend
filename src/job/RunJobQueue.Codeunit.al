/// <summary>
/// Codeunit RunJobQueue (ID 50107).
/// </summary>
codeunit 50107 RunJobQueue
{
    trigger OnRun()
    var
        LogEntry: Record "Log Entry";
    begin
        LogEntry.Init();
        LogEntry."Entry No." := 0;
        LogEntry.Insert(true);

        LogEntry."Created Date Time" := CurrentDateTime();
        LogEntry.Description := 'My message';
        LogEntry.Quantity := Random(10000) / 100;
        LogEntry.Modify(true);
    end;
}
