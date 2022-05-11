/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50103 WSGetCompanies
{
    trigger OnRun()
    var
        url: Text;
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
    begin
        url := 'http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0/companies';

        AddDefaultHeaders(HttpClient, 'STUDENT', 'Torek557!');

        if not HttpClient.Get(url, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', url);

        if not (HttpResponseMessage.HttpStatusCode() = 200) then
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

        Message('%1', HttpResponseMessage.HttpStatusCode);
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
