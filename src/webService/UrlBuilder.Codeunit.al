/// <summary>
/// Helper for building urls.
/// </summary>
codeunit 50112 "Url Builder"
{
    local procedure GetBaseUrl(): Text
    var
        WebServiceSetup: Record "Web Service Setup";
    begin
        WebServiceSetup.Get();
        exit(WebServiceSetup."Base Url");
    end;

    /// <summary>
    /// GetStandardURL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetStandardURL(): Text
    begin
        exit(GetStandardURL('v2.0'));
    end;

    /// <summary>
    /// GetBaseURL.
    /// </summary>
    /// <param name="ServiceVersion">Version of service.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetStandardURL(ServiceVersion: Text): Text
    var
        standardUrlTok: Label '%1/%2', Locked = true;
    begin
        exit(StrSubstNo(standardUrlTok, GetBaseUrl(), ServiceVersion));
    end;

    /// <summary>
    /// GetCustomURL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetCustomURL(): Text
    begin
        exit(GetStandardURL('v1.0'));
    end;


}
