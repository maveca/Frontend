/// <summary>
/// Codeunit CreateSalesInvoice for creating new sales invoice.
/// </summary>
codeunit 50100 CreateSalesInvoice
{
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateSalesHeader(SalesHeader, '01121212');

        CreateSalesLine(SalesHeader, '1000', 10000);
        CreateSalesLine(SalesHeader, '1001', 20000);

        Page.Run(Page::"Sales Invoice", SalesHeader);
    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := "Sales Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; ItemNumber: Code[20]; LineNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Line No." := LineNo;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Document Type" := "Sales Document Type"::Invoice;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, "Sales Line Type"::Item);
        SalesLine.Validate("No.", ItemNumber);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify(true);
    end;
}
