/// <summary>
/// Helper for building urls.
/// </summary>
codeunit 50112 "Url Builder"
{
    var
        CurrentUrl: Text;

    trigger OnRun()
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        Message(UrlBuilder.SystemApi().Entity('items').AsString());
    end;

    /// <summary>
    /// Returns system API Url as Text.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure BaseUrl(): Text
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        exit(UrlBuilder.Api().ApiVersion().AsString());
    end;

    /// <summary>
    /// Returns basic Url as URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure Api(): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(WebServiceSetup()."Base Url");
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Returns system API Url as URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure SystemApi(): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(UrlBuilder.Api().ApiPublisher().ApiGroup().ApiVersion().Company().AsString());
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Returns custom API Url as URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure CustomApi(): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(UrlBuilder.Api().ApiPublisher().ApiGroup().ApiVersion().Company().AsString());
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds default version part to Url and returns URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiVersion(): Codeunit "Url Builder"
    begin
        if IsStandardAPI() then
            exit(ApiVersion(WebServiceSetup()."Default System Version"))
        else
            exit(ApiVersion(WebServiceSetup()."Custom API Version"));
    end;

    /// <summary>
    /// Adds version part to Url and returns URL Builder.
    /// </summary>
    /// <param name="VersionName">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiVersion(VersionName: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + Separator() + Part(VersionName));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds default company part to Url and returns URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure Company(): Codeunit "Url Builder"
    begin
        exit(Company(WebServiceSetup()."Default Company"));
    end;

    /// <summary>
    /// Adds company part to Url and returns URL Builder.
    /// </summary>
    /// <param name="CompName">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure Company(CompName: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
        BackendAPI: Codeunit "Backend API";
        CompanyId: Text;
    begin
        CompanyId := BackendAPI.GetCompanyId(CompName);
        UrlBuilder.Set(AsString() + Separator() + Part('companies', CompanyId));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds default Api publisher part to Url and returns URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiPublisher(): Codeunit "Url Builder"
    begin
        exit(ApiPublisher(WebServiceSetup()."Custom API Publisher"));
    end;

    /// <summary>
    /// Adds Api publisher part to Url and returns URL Builder.
    /// </summary>
    /// <param name="PublisherName">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiPublisher(PublisherName: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + Separator() + Part(PublisherName));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds default Api group part to Url and returns URL Builder.
    /// </summary>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiGroup(): Codeunit "Url Builder"
    begin
        exit(ApiGroup(WebServiceSetup()."Custom API Group"));
    end;

    /// <summary>
    /// Adds Api group part to Url and returns URL Builder.
    /// </summary>
    /// <param name="GroupName">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure ApiGroup(GroupName: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + Separator() + Part(GroupName));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds default entity part to Url and returns URL Builder.
    /// </summary>
    /// <param name="EntityName">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure Entity(EntityName: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + Separator() + Part(EntityName));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds entity part to Url and returns URL Builder.
    /// </summary>
    /// <param name="EntityName">Text.</param>
    /// <param name="EntityId">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure Entity(EntityName: Text; EntityId: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + Separator() + Part(EntityName, EntityId));
        exit(UrlBuilder);
    end;

    /// <summary>
    /// Adds query string part to Url and returns URL Builder.
    /// </summary>
    /// <param name="QueryString">Text.</param>
    /// <returns>Return value of type Codeunit "Url Builder".</returns>
    procedure QueryString(QueryString: Text): Codeunit "Url Builder"
    var
        UrlBuilder: Codeunit "Url Builder";
    begin
        UrlBuilder.Set(AsString() + QuerySeparator() + Part(QueryString));
        exit(UrlBuilder);
    end;

    internal procedure Set(NewUrl: Text)
    begin
        CurrentUrl := NewUrl;
    end;

    internal procedure AsString(): Text;
    begin
        exit(CurrentUrl);
    end;

    local procedure Part(ServiceName: Text): Text
    var
        UrlTok: Label '%1', Locked = true;
    begin
        exit(StrSubstNo(UrlTok, ServiceName));
    end;

    local procedure Part(ServiceName: Text; EntityId: Text): Text
    var
        UrlTok: Label '%1(%2)', Locked = true;
    begin
        exit(StrSubstNo(UrlTok, ServiceName, EntityId));
    end;

    local procedure Separator(): Text
    begin
        exit('/');
    end;

    local procedure QuerySeparator(): Text
    begin
        exit('?');
    end;

    local procedure IsStandardAPI(): Boolean
    begin
        exit((AsString().Contains('/api/v')) or (AsString().EndsWith('api')));
    end;

    local procedure WebServiceSetup() Result: Record "Web Service Setup"
    begin
        Result.Get();
    end;
}
