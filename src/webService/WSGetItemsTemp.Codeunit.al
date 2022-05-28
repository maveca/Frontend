/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50108 WSGetItemsTemp
{
    trigger OnRun()
    var
        TempItem: Record Item temporary;
    begin
        GetItems('CRONUS International Ltd.', TempItem);
        Page.Run(0, TempItem);
    end;

    local procedure GetItems(FromCompany: Text; var TempItem: Record Item temporary)
    var
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        JsonBuilder: Codeunit "Json Builder";
        ResultValue: JsonToken;
        ItemArray: JsonArray;
        ItemToken: JsonToken;
        i: integer;
    begin
        TempItem.DeleteAll();

        BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company(FromCompany).Entity('items').AsString(),
            ResultValue);
        ItemArray := ResultValue.AsArray();
        for i := 0 to ItemArray.Count() - 1 do begin
            ItemArray.Get(i, ItemToken);
            JsonBuilder.New(ItemToken);

            TempItem.Init();
            TempItem."No." := CopyStr(JsonBuilder.Field('number').AsCode(), 1, 20);
            TempItem.Description := CopyStr(JsonBuilder.Field('displayName').AsText(), 1, 100);
            TempItem."Item Category Code" := CopyStr(JsonBuilder.Field('itemCategoryCode').AsCode(), 1, 20);
            TempItem."Unit Cost" := JsonBuilder.Field('unitCost').AsDecimal();
            TempItem."Unit Price" := JsonBuilder.Field('unitPrice').AsDecimal();
            TempItem.Insert();
        end;
    end;
}
