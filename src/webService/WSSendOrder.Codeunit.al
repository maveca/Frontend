/// <summary>
/// Codeunit WSSendOrder (ID 50105).
/// </summary>
codeunit 50105 WSSendOrder
{
    trigger OnRun()
    var
        WSGetCompanies: Codeunit WSGetCompanies;
        CompanyId: Text;
        OrderId: Text;
        UrlHeaderLbl: Label '%1/companies(%2)/salesOrders', Comment = '%1: base url, %2: company id.';
        UrlLineLbl: Label '%1/companies(%2)/salesOrders(%3)/salesOrderLines', Comment = '%1: base url, %2: company id., %3: order id';
    begin
        CompanyId := WSGetCompanies.GetCompanyId('CRONUS International Ltd.');
        OrderId := PostSales(StrSubstNo(UrlHeaderLbl, WSGetCompanies.GetBaseURL(), CompanyId), HeaderContent());
        PostSales(StrSubstNo(UrlLineLbl, WSGetCompanies.GetBaseURL(), CompanyId, OrderId), LineContent());
        Message('Prijenos je završen!');
    end;


    local procedure PostSales(url: Text; content: Text): Text
    var
        WSGetCompanies: Codeunit WSGetCompanies;
        JsonObjectDocument: JsonObject;
        JsonToken: JsonToken;
    begin
        WSGetCompanies.PostMethod(url, content, JsonObjectDocument);
        JsonObjectDocument.Get('id', JsonToken);
        exit(JsonToken.AsValue().AsText());
    end;

    local procedure HeaderContent() Result: Text
    var
        JsonDocument: JsonObject;
    begin
        JsonDocument.Add('postingDate', Today());
        JsonDocument.Add('customerNumber', '30000');
        JsonDocument.WriteTo(Result);
    end;

    local procedure LineContent() Result: Text
    var
        JsonDocument: JsonObject;
    begin
        JsonDocument.Add('lineType', 'Item');
        JsonDocument.Add('lineObjectNumber', '1953-W');
        JsonDocument.Add('quantity', 2);
        JsonDocument.WriteTo(Result);
    end;
}