/// <summary>
/// Codeunit BackendAPI is helper for calling all backend api services.
/// </summary>
codeunit 50103 "Backend API"
{

    local procedure AddDefaultHeaders(var HttpClient: HttpClient; UserName: Text; Password: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpHeaders: HttpHeaders;
        BasicTok: Label 'Basic ', Comment = '%1 = placeholder for username and password.';
        UserPwdTok: Label '%1:%2', Comment = '%1 = Username, %2 = Password.';
    begin
        HttpHeaders := HttpClient.DefaultRequestHeaders();
        HttpHeaders.Add('Authorization', BasicTok
            + Base64Convert.ToBase64(
                StrSubstNo(UserPwdTok, UserName, Password)));
    end;

    local procedure AddDefaultHeaders(var HttpClient: HttpClient; UserName: Text; Password: Text; Etag: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpHeaders: HttpHeaders;
        BasicTok: Label 'Basic ', Comment = '%1 = placeholder for username and password.';
        UserPwdTok: Label '%1:%2', Comment = '%1 = Username, %2 = Password.';
    begin
        HttpHeaders := HttpClient.DefaultRequestHeaders();
        HttpHeaders.Add('Authorization', BasicTok
            + Base64Convert.ToBase64(
                StrSubstNo(UserPwdTok, UserName, Password)));
        HttpHeaders.Add('If-Match', Etag);
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

    procedure GetCustomURL(): Text
    begin
        exit(GetStandardURL('v1.0'));
    end;


    /// <summary>
    /// GetFieldAsText returns text from a document.
    /// </summary>
    /// <param name="JsonObject">VAR JsonObject.</param>
    /// <param name="FieldName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetFieldAsText(var JsonObject: JsonObject; FieldName: Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get(FieldName, JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsText());
    end;

    /// <summary>
    /// GetFieldAsDecimal returns decimal from a document.
    /// </summary>
    /// <param name="JsonObject">VAR JsonObject.</param>
    /// <param name="FieldName">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetFieldAsDecimal(var JsonObject: JsonObject; FieldName: Text): Decimal
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get(FieldName, JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsDecimal());
    end;

    local procedure GetETag(JsonObject: JsonObject): Text
    begin
        exit(GetFieldAsText(JsonObject, '@odata.etag'));
    end;

    local procedure GetId(JsonObject: JsonObject): Text
    begin
        exit(GetFieldAsText(JsonObject, 'id'));
    end;

    /// <summary>
    /// GetCompanyId returns id of company that corresponds to Company Name from parameter.
    /// </summary>
    /// <param name="CompName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetCompanyId(CompName: Text): Text
    var
        TempCompany: Record Company temporary;
        JsonValueToken: JsonToken;
        JsonArrayCompanies: JsonArray;
        JsonTokenCompany: JsonToken;
        JsonObjectCompany: JsonObject;
        i: integer;
    begin
        Get(GetStandardURL() + '/companies', JsonValueToken);
        JsonArrayCompanies := JsonValueToken.AsArray();
        for i := 0 to JsonArrayCompanies.Count() - 1 do begin
            JsonArrayCompanies.Get(i, JsonTokenCompany);
            JsonObjectCompany := JsonTokenCompany.AsObject();

            TempCompany.Init();
            TempCompany."Name" := CopyStr(GetFieldAsText(JsonObjectCompany, 'name'), 1, 30);
            TempCompany."Display Name" := CopyStr(GetFieldAsText(JsonObjectCompany, 'id'), 1, 250);
            TempCompany.Insert();
        end;

        TempCompany.SetRange(Name, CompName);
        TempCompany.FindFirst();
        exit(TempCompany."Display Name");
    end;

    /// <summary>
    /// Url for most of then calls.
    /// </summary>
    /// <param name="CompanyName">Text.</param>
    /// <param name="ServiceName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure Url(CompanyName: Text; ServiceName: Text): Text
    var
        CompanyId: Text;
        UrlTok: Label '%1/companies(%2)/%3', Locked = true;
    begin
        CompanyId := GetCompanyId(CompanyName);
        exit(StrSubstNo(UrlTok, GetStandardURL(), CompanyId, ServiceName));
    end;

    /// <summary>
    /// ConnectToAPI.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="JsonValueToken">VAR JsonToken.</param>
    procedure Get(url: Text; var JsonValueToken: JsonToken)
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutputString: Text;
        JsonObjectDocument: JsonObject;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password);

        if not HttpClient.Get(url, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() = 200) then
            Error('Web service returned error %1: %2', HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase);

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
        JsonObjectDocument.Get('value', JsonValueToken);
    end;

    /// <summary>
    /// PostMethod.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="content">Text.</param>
    /// <param name="JsonObjectDocument">VAR JsonToken.</param>
    procedure Post(url: Text; content: Text; var JsonObjectDocument: JsonObject)
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        OutputString: Text;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password);

        HttpContent.WriteFrom(content);

        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        if not HttpClient.Post(url, HttpContent, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() in [200, 201]) then
            Error('Web service returned error %1: %2', HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase);

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
    end;


    /// <summary>
    /// Put Method
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="ObjectToUpdate">JsonObject.</param>
    /// <param name="content">Text.</param>
    /// <returns>Return variable Result of type JsonObject.</returns>
    procedure Put(url: Text; ObjectToUpdate: JsonToken; content: Text) Result: JsonObject
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        HttpHeaders: HttpHeaders;
        OutputString: Text;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password, GetETag(ObjectToUpdate.AsObject()));
        HttpContent.WriteFrom(content);

        HttpContent.GetHeaders(HttpHeaders);
        HttpHeaders.Remove('Content-Type');
        HttpHeaders.Add('Content-Type', 'application/json');

        if not HttpClient.Put(url, HttpContent, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() in [200, 201]) then
            Error('Web service returned error %1: %2', HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase);

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        Result.ReadFrom(OutputString);
    end;
}
