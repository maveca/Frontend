/// <summary>
/// Codeunit WSSendOrder (ID 50105).
/// </summary>
codeunit 50105 WSSendOrder
{
    trigger OnRun()
    var
        CartEntry: Record "Cart Entry";
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        CompanyId: Text;
        OrderId: Text;
        UrlHeaderLbl: Label '%1/companies(%2)/salesOrders', Comment = '%1: base url, %2: company id.';
        UrlLineLbl: Label '%1/companies(%2)/salesOrders(%3)/salesOrderLines', Comment = '%1: base url, %2: company id., %3: order id';
        CartLbl: Label 'Your cart has been sent.';
    begin
        CompanyId := BackendAPI.GetCompanyId('CRONUS International Ltd.');
        OrderId := PostSales(StrSubstNo(UrlHeaderLbl, UrlBuilder.BaseUrl(), CompanyId),
            HeaderContent(Today(), '30000'));
        if CartEntry.FindSet() then
            repeat
                PostSales(StrSubstNo(UrlLineLbl, UrlBuilder.BaseUrl(), CompanyId, OrderId),
                    LineContent('Item', CartEntry."Item No.", CartEntry.Quantity));
            until CartEntry.Next() = 0;
        Message(CartLbl);
    end;


    local procedure PostSales(url: Text; content: Text): Text
    var
        BackendAPI: Codeunit "Backend API";
        JsonObjectDocument: JsonObject;
        JsonToken: JsonToken;
    begin
        BackendAPI.Post(url, content, JsonObjectDocument);
        JsonObjectDocument.Get('id', JsonToken);
        exit(JsonToken.AsValue().AsText());
    end;

    local procedure HeaderContent(PostingDate: Date; CustomerNo: Code[20]) Result: Text
    var
        JsonDocument: JsonObject;
    begin
        JsonDocument.Add('postingDate', PostingDate);
        JsonDocument.Add('customerNumber', CustomerNo);
        JsonDocument.WriteTo(Result);
    end;

    local procedure LineContent(LineType: Text; LineNo: Code[20]; Qty: Decimal) Result: Text
    var
        JsonDocument: JsonObject;
    begin
        JsonDocument.Add('lineType', LineType);
        JsonDocument.Add('lineObjectNumber', LineNo);
        JsonDocument.Add('quantity', Qty);
        JsonDocument.WriteTo(Result);
    end;
}