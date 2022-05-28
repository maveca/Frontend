/// <summary>
/// Codeunit WSGetCompanies (ID 50103).
/// </summary>
codeunit 50104 WSGetItems
{
    trigger OnRun()
    var
        Item: Record Item;
    begin
        GetItems('CRONUS International Ltd.', Item);
        Page.Run(0, Item);
    end;

    local procedure GetItems(FromCompany: Text; var Item: Record Item)
    var
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        JsonBuilder: Codeunit "Json Builder";
        Progress: Codeunit Progress;
        ResultValue: JsonToken;
        ItemArray: JsonArray;
        ItemToken: JsonToken;
        ItemId: Text;
        i: integer;
    begin
        Progress.Open('Preparing to download', 2);
        Item.DeleteAll();
        Progress.Next();
        BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company(FromCompany).Entity('items').QueryString('filter=itemCategoryCode eq ''FM''').AsString(),
            ResultValue);
        Progress.Next();
        ItemArray := ResultValue.AsArray();
        Progress.Close();

        Progress.Open('Downloading items...', ItemArray.Count());
        for i := 0 to ItemArray.Count() - 1 do begin

            ItemArray.Get(i, ItemToken);
            JsonBuilder.New(ItemToken);

            Item.Init();
            Item."No." := CopyStr(JsonBuilder.Field('number').AsCode(), 1, 20);
            Item.Description := CopyStr(JsonBuilder.Field('displayName').AsText(), 1, 100);
            Item."Item Category Code" := CreateItemCategory(CopyStr(JsonBuilder.Field('itemCategoryCode').AsCode(), 1, 20));
            Item."Unit Cost" := JsonBuilder.Field('unitCost').AsDecimal();
            Item."Unit Price" := JsonBuilder.Field('unitPrice').AsDecimal();
            Item.Insert(true);

            ItemId := JsonBuilder.Field('id').AsText();
            GetItemPicture(FromCompany, ItemId, Item);
            Progress.Update('Downloading item ' + Item.Description);
            Progress.Next();
        end;
        Progress.Close();
    end;

    local procedure GetItemPicture(FromCompany: Text; ItemId: Text; var Item: Record Item)
    var
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        MimeType: Text;
        HttpResponseMessage: HttpResponseMessage;
        InStream: InStream;
        i: integer;
    begin
        MimeType := GetMimeType(FromCompany, ItemId);
        if MimeType = '' then
            exit;

        if Item.Picture.Count() > 0 then
            for i := 0 to Item.Picture.Count() - 1 do
                Item.Picture.Remove(Item.Picture.Item(i));

        HttpResponseMessage := BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company(FromCompany).Entity('items', ItemId).Entity('picture').Entity('pictureContent').AsString());
        HttpResponseMessage.Content().ReadAs(InStream);
        Item.Picture.ImportStream(InStream, '', MimeType);
        Item.Modify(true);
    end;

#pragma warning disable AA0228
    local procedure GetItemPictureFromBase64(FromCompany: Text; var Item: Record Item; var JsonObjectItem: JsonObject; var i: integer)
#pragma warning restore AA0228
    var
        BackendAPI: Codeunit "Backend API";
        JsonBuilder: Codeunit "Json Builder";
        TempBlob: Codeunit "Temp Blob";
        UrlBuilder: Codeunit "Url Builder";
        Base64Convert: Codeunit "Base64 Convert";
        JsonTokenPicture: JsonToken;
        MimeType: Text;
        ItemId: Text;
    begin
        JsonBuilder.New(JsonObjectItem);
        MimeType := GetMimeType(FromCompany, ItemId);
        if MimeType = '' then
            exit;

        if Item.Picture.Count() > 0 then
            for i := 0 to Item.Picture.Count() - 1 do
                Item.Picture.Remove(Item.Picture.Item(i));

        ItemId := JsonBuilder.Field('id').AsText();
        BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company(FromCompany).Entity('items', ItemId).Entity('picture').Entity('pictureContent').AsString(),
            JsonTokenPicture);
        Base64Convert.FromBase64(JsonTokenPicture.AsValue().AsText(), TempBlob.CreateOutStream());
        Item.Picture.ImportStream(TempBlob.CreateInStream(), '', MimeType);
        Item.Modify(true);
    end;

    local procedure GetItemPictureInfo(FromCompany: Text; ItemId: Text) PictureInfo: JsonObject
    var
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        ResultValue: JsonToken;
    begin
        BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company(FromCompany).Entity('items', ItemId).Entity('picture').AsString(),
            ResultValue);
        PictureInfo := ResultValue.AsObject();
    end;

    local procedure GetMimeType(FromCompany: Text; ItemId: Text): Text;
    var
        PictureInfo: JsonObject;
        ValueToken: JsonToken;
    begin
        PictureInfo := GetItemPictureInfo(FromCompany, ItemId);
        PictureInfo.Get('contentType', ValueToken);
        exit(ValueToken.AsValue().AsText());
    end;

    local procedure CreateItemCategory(ItemCategoryCode: Code[20]): Code[20]
    var
        ItemCategory: Record "Item Category";
    begin
        if ItemCategoryCode = '' then
            exit('');
        if not ItemCategory.Get(ItemCategoryCode) then begin
            ItemCategory.Init();
            ItemCategory.Code := ItemCategoryCode;
            ItemCategory.Insert(true);
        end;
        exit(ItemCategoryCode);
    end;
}
