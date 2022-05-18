/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50104 WSGetItems
{
    trigger OnRun()
    var
        TempItem: Record Item temporary;
        WSGetCompanies: Codeunit WSGetCompanies;
        CompanyId: Text;
        UrlLbl: Label '%1/companies(%2)/items?$filter=itemCategoryCode eq ''FM''', Comment = '%1: base url, %2: company id.';
    begin
        CompanyId := WSGetCompanies.GetCompanyId('Kristina');
        GetItems(StrSubstNo(UrlLbl, WSGetCompanies.GetBaseURL(), CompanyId), TempItem);
        Page.Run(0, TempItem);
    end;

    local procedure GetItems(url: Text; var TempItem: Record Item temporary)
    var
        WSGetCompanies: Codeunit WSGetCompanies;
        JsonValueToken: JsonToken;
        JsonArrayItems: JsonArray;
        JsonTokenItem: JsonToken;
        JsonObjectItem: JsonObject;
        i: integer;
    begin
        WSGetCompanies.ConnectToAPI(url, JsonValueToken);
        JsonArrayItems := JsonValueToken.AsArray();
        for i := 0 to JsonArrayItems.Count() - 1 do begin
            JsonArrayItems.Get(i, JsonTokenItem);
            JsonObjectItem := JsonTokenItem.AsObject();

            TempItem.Init();
            TempItem."No." := CopyStr(WSGetCompanies.GetFieldAsText(JsonObjectItem, 'number'), 1, 20);
            TempItem.Description := CopyStr(WSGetCompanies.GetFieldAsText(JsonObjectItem, 'displayName'), 1, 100);
            TempItem."Unit Price" := WSGetCompanies.GetFieldAsDecimal(JsonObjectItem, 'unitPrice');
            TempItem.Insert();
        end;
    end;
}
