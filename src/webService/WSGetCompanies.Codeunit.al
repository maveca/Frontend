/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50103 WSGetCompanies
{
    trigger OnRun()
    begin
        Message(GetCompanyId('CRONUS International Ltd.'));
    end;

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

    /// <summary>
    /// GetBaseURL.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetBaseURL(): Text
    var
        WebServiceSetup: Record "Web Service Setup";
    begin
        WebServiceSetup.Get();
        exit(WebServiceSetup."Base Url");
    end;

    /// <summary>
    /// GetFieldAsText.
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
    /// GetFieldAsDecimal.
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

    /// <summary>
    /// GetCompanyId.
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
        ConnectToAPI(GetBaseURL() + '/companies', JsonValueToken);
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
    /// ConnectToAPI.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="JsonValueToken">VAR JsonToken.</param>
    procedure ConnectToAPI(url: Text; var JsonValueToken: JsonToken)
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
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

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
    procedure PostMethod(url: Text; content: Text; var JsonObjectDocument: JsonObject)
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
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
    end;

}
