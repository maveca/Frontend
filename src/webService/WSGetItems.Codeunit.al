/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50104 WSGetItems
{
    trigger OnRun()
    var
        Item: Record Item;
        WSGetCompanies: Codeunit BackendAPI;
        CompanyId: Text;
        UrlLbl: Label '%1/companies(%2)/items?$filter=itemCategoryCode eq ''FM''', Comment = '%1: base url, %2: company id.';
    begin
        CompanyId := WSGetCompanies.GetCompanyId('Kristina');
        GetItems(StrSubstNo(UrlLbl, WSGetCompanies.GetBaseURL(), CompanyId), CompanyId, Item);
        Page.Run(0, Item);
    end;

    local procedure GetItems(url: Text; CompanyId: Text; var Item: Record Item)
    var
        WSGetCompanies: Codeunit BackendAPI;
        WSGetCompaniesPicture: Codeunit BackendAPI;
        //Base64: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        JsonValueToken: JsonToken;
        JsonArrayItems: JsonArray;
        JsonTokenItem: JsonToken;
        JsonObjectItem: JsonObject;
        JsonTokenPicture: JsonToken;
        i: integer;
        itemId: Text;
        urlLbl: Label '%1/companies(%2)/items(%3)/picture/pictureContent', Comment = '%1 = Baseurl, %2 = company Id, %3 = picture';
    begin
        // Option a)
        Item.DeleteAll();

        WSGetCompanies.ConnectToAPI(url, JsonValueToken);
        JsonArrayItems := JsonValueToken.AsArray();
        for i := 0 to JsonArrayItems.Count() - 1 do begin
            JsonArrayItems.Get(i, JsonTokenItem);
            JsonObjectItem := JsonTokenItem.AsObject();

            Item.Init();
            Item."No." := CopyStr(WSGetCompanies.GetFieldAsText(JsonObjectItem, 'number'), 1, 20);
            if not Item.Insert(true) then;
            Item.Validate(Description, CopyStr(WSGetCompanies.GetFieldAsText(JsonObjectItem, 'displayName'), 1, 100));
            Item.Validate("Unit Price", WSGetCompanies.GetFieldAsDecimal(JsonObjectItem, 'unitPrice'));
            Item.Modify(true);

            if Item.Picture.Count() > 0 then
                for i := 0 to Item.Picture.Count() - 1 do
                    Item.Picture.Remove(Item.Picture.Item(i));

            itemId := WSGetCompaniesPicture.GetFieldAsText(JsonObjectItem, 'id');
            WSGetCompaniesPicture.ConnectToAPI(StrSubstNo(urlLbl, WSGetCompanies.GetBaseURL(), CompanyId, itemId), JsonTokenPicture);
            // not base64
            JsonTokenPicture.WriteTo(TempBlob.CreateOutStream());
            Item.Picture.ImportStream(TempBlob.CreateInStream(), '', 'image/png');
            Item.Modify(true);

            // is base64
            /*
            Base64.FromBase64(JsonTokenPicture.AsValue().AsText(), TempBlob.CreateOutStream());
            TempItem.Picture.ImportStream(TempBlob.CreateInStream(), '', 'image/png');
            TempItem.Modify(true);
            */
        end;
    end;
}
