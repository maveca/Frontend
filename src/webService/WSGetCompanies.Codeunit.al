/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50103 WSGetCompanies
{
    trigger OnRun()
    var
        TempItem: Record Item temporary;
        CompanyId: Text;
        UrlLbl: Label '%1/companies(%2)/items', Comment = '%1: base url, %2: company id.';
    begin
        CompanyId := GetCompanyId('CRONUS International Ltd.');
        GetItems(StrSubstNo(UrlLbl, GetBaseURL(), CompanyId), TempItem);
        Page.Run(0, TempItem);
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

    local procedure GetBaseURL(): Text
    begin
        exit('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0');
    end;

    local procedure GetFieldAsText(var JsonObject: JsonObject; FieldName: Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get(FieldName, JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsText());
    end;

    local procedure GetCompanyId(CompName: Text): Text
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
        i: integer;
    begin
        url := GetBaseURL() + '/companies';

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

            TempCompany.Init();
            TempCompany."Name" := CopyStr(GetFieldAsText(JsonObjectCompany, 'name'), 1, 30);
            TempCompany."Display Name" := CopyStr(GetFieldAsText(JsonObjectCompany, 'id'), 1, 250);
            TempCompany.Insert();
        end;

        TempCompany.SetRange(Name, CompName);
        TempCompany.FindFirst();
        exit(TempCompany."Display Name");
    end;

    local procedure GetItems(url: Text; var TempItem: Record Item temporary)
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutputString: Text;
        JsonObjectDocument: JsonObject;
        JsonValueToken: JsonToken;
        JsonArrayCompanies: JsonArray;
        JsonTokenCompany: JsonToken;
        JsonObjectCompany: JsonObject;
        i: integer;
    begin
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

            TempItem.Init();
            TempItem."No." := CopyStr(GetFieldAsText(JsonObjectCompany, 'number'), 1, 20);
            TempItem.Description := CopyStr(GetFieldAsText(JsonObjectCompany, 'displayName'), 1, 100);
            TempItem.Insert();
        end;
    end;
}
