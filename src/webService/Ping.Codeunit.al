/// <summary>
/// Codeunit Ping (ID 50109).
/// </summary>
codeunit 50109 Ping
{
    /// <summary>
    /// Ping.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure Ping(): Text;
    begin
        exit('pong');
    end;
}