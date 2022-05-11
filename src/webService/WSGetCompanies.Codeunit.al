/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50103 WSGetCompanies
{
    trigger OnRun()
    var
        TempCompany: Record Company temporary;
        url: Text;
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutputString: Text;
        JsonObjectDocument: JsonObject;
        JsonValueToken: JsonToken;
        JsonArrayCompanies: JsonArray;
        JsonTokenCompany: JsonToken;
        JsonObjectCompany: JsonObject;
        JsonTokenCompanyName: JsonToken;
        JsonValueCompanyName: JsonValue;
        JsonTokenCompanyId: JsonToken;
        JsonValueCompanyId: JsonValue;
        i: integer;
    begin
        url := 'http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0/companies';

        AddDefaultHeaders(HttpClient, 'STUDENT', 'Torek557!');

        if not HttpClient.Get(url, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() = 200) then
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
        JsonObjectDocument.Get('value', JsonValueToken);
        JsonArrayCompanies := JsonValueToken.AsArray();
        for i := 0 to JsonArrayCompanies.Count() - 1 do begin
            JsonArrayCompanies.Get(i, JsonTokenCompany);
            JsonObjectCompany := JsonTokenCompany.AsObject();
            JsonObjectCompany.Get('name', JsonTokenCompanyName);
            JsonValueCompanyName := JsonTokenCompanyName.AsValue();
            JsonObjectCompany.Get('id', JsonTokenCompanyId);
            JsonValueCompanyId := JsonTokenCompanyId.AsValue();

            TempCompany.Init();
            TempCompany.Name := CopyStr(JsonValueCompanyName.AsText(), 1, 30);
            TempCompany."Display Name" := CopyStr(JsonValueCompanyId.AsText(), 1, 250);
            TempCompany.Insert();
        end;
        Page.Run(Page::"Companies", TempCompany);
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
}
