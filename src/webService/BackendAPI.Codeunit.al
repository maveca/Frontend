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

    local procedure GetETag(JsonToken: JsonToken): Text
    var
        JsonBuilder: Codeunit "Json Builder";
    begin
        JsonBuilder.New(JsonToken);
        exit(JsonBuilder.Field('@odata.etag').AsText());
    end;

    /// <summary>
    /// GetCompanyId returns id of company that corresponds to Company Name from parameter.
    /// </summary>
    /// <param name="CompName">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetCompanyId(CompName: Text): Text
    var
        TempCompany: Record Company temporary;
        UrlBuilder: Codeunit "Url Builder";
        JsonBuilder: Codeunit "Json Builder";
        JsonValueToken: JsonToken;
        JsonArrayCompanies: JsonArray;
        JsonTokenCompany: JsonToken;
        i: integer;
    begin
        Get(UrlBuilder.Api().ApiVersion().Entity('companies').AsString(), JsonValueToken);
        JsonArrayCompanies := JsonValueToken.AsArray();
        for i := 0 to JsonArrayCompanies.Count() - 1 do begin
            JsonArrayCompanies.Get(i, JsonTokenCompany);
            JsonBuilder.New(JsonTokenCompany);

            TempCompany.Init();
            TempCompany."Name" := CopyStr(JsonBuilder.Field('name').AsText(), 1, 30);
            TempCompany."Display Name" := CopyStr(JsonBuilder.Field('id').AsText(), 1, 250);
            TempCompany.Insert();
        end;

        TempCompany.SetRange(Name, CompName);
        TempCompany.FindFirst();
        exit(TempCompany."Display Name");
    end;

    /// <summary>
    /// Calls web api service with GET method. This is for reading data.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="ResponseValue">VAR JsonToken.</param>
    procedure Get(url: Text; var ResponseValue: JsonToken)
    var
        HttpResponseMessage: HttpResponseMessage;
        Response: Text;
        Document: JsonObject;
    begin
        HttpResponseMessage := Get(url);
        HttpResponseMessage.Content().ReadAs(Response);
        Document.ReadFrom(Response);
        if not Document.Get('value', ResponseValue) then
            ResponseValue := Document.AsToken();
    end;

    /// <summary>
    /// Get.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <returns>Return variable Response of type Text.</returns>
    procedure Get(url: Text) HttpResponseMessage: HttpResponseMessage
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password);

        if not HttpClient.Get(url, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() = 200) then
            Error('Web service returned error %1: %2', HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase);
    end;

    /// <summary>
    /// Calls web api service with POST method. This is for inserting new data.
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
    /// Calls web api service with PUT method. This is for modifying data.
    /// </summary>
    /// <param name="url">Text.</param>
    /// <param name="ObjectToUpdate">JsonObject.</param>
    /// <param name="content">Text.</param>
    /// <returns>Returns response document of type JsonObject.</returns>
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
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password, GetETag(ObjectToUpdate));
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
