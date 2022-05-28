#pragma warning disable AA0217
/// <summary>
/// Codeunit Update Customer (ID 50110).
/// </summary>
codeunit 50110 "WS Update Customer"
{
    trigger OnRun()
    var
        BackendAPI: Codeunit "Backend API";
        UrlBuilder: Codeunit "Url Builder";
        JsonBuilder: Codeunit "Json Builder";
        Customers: JsonToken;
        FirstCustomer: JsonToken;
        ContentObject: JsonObject;
        UpdatedCustomer: JsonObject;
        UpdatedCustomerValue: Text;
        Url: Text;
        Id: Text;
        Content: Text;
    begin
        BackendAPI.Get(UrlBuilder.Api().ApiVersion().Company().Entity('customers').AsString(), Customers);

        Customers.AsArray().Get(1, FirstCustomer);
        JsonBuilder.New(FirstCustomer);

        Id := JsonBuilder.Field('id').AsText();
        ContentObject.Add('addressLine2', 'Senhor square 15');
        ContentObject.WriteTo(Content);
        Url := UrlBuilder.Api().ApiVersion().Company().Entity('customers', Id).AsString();

        UpdatedCustomer := BackendAPI.Put(Url, FirstCustomer, Content);
        UpdatedCustomer.WriteTo(UpdatedCustomerValue);
        Message(UpdatedCustomerValue);
    end;
}
#pragma warning restore AA0217