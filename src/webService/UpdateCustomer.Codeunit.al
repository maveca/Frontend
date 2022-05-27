#pragma warning disable AA0217
/// <summary>
/// Codeunit Update Customer (ID 50110).
/// </summary>
codeunit 50110 "Update Customer"
{
    trigger OnRun()
    var
        BackendAPI: Codeunit "Backend API";
        Customers: JsonToken;
        FirstCustomer: JsonToken;
        FirstCustomerObject: JsonObject;
        ContentObject: JsonObject;
        UpdatedCustomer: JsonObject;
        UpdatedCustomerValue: Text;
        Url: Text;
        Id: Text;
        Content: Text;
    begin
        BackendAPI.Get(BackendAPI.Url('CRONUS International Ltd.', 'customers'), Customers);

        Customers.AsArray().Get(1, FirstCustomer);
        FirstCustomerObject := FirstCustomer.AsObject();

        Id := BackendAPI.GetFieldAsText(FirstCustomerObject, 'id');
        ContentObject.Add('addressLine2', 'Senhor square 15');
        ContentObject.WriteTo(Content);
        Url := BackendAPI.Url('CRONUS International Ltd.', StrSubstNo('customers(%1)', Id));

        UpdatedCustomer := BackendAPI.Put(Url, FirstCustomer, Content);
        UpdatedCustomer.WriteTo(UpdatedCustomerValue);
        Message(UpdatedCustomerValue);
    end;
}
#pragma warning restore AA0217