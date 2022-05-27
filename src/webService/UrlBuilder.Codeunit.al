/// <summary>
/// Helper for building urls.
/// </summary>
codeunit 50112 "Url Builder"
{
    var
        Url: Text;

    trigger OnRun()
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        Message(UrlBuilder.Api().AsString());
    end;

    procedure Set(NewUrl: Text)
    begin
        Url := NewUrl;
    end;

    procedure AsString(): Text;
    begin
        exit(Url);
    end;

    procedure Api(): Codeunit "Url Builder";
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(GetBaseUrl());
        exit(UrlBuilder);
    end;

    procedure Company(): Codeunit "Url Builder";
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(GetBaseUrl());
        exit(UrlBuilder);
    end;

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
