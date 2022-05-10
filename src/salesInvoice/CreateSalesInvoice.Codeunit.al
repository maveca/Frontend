/// <summary>
/// Codeunit CreateSalesInvoice for creating new sales invoice.
/// </summary>
codeunit 50100 CreateSalesInvoice
{
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        LineNo: Integer;
    begin
        CreateSalesHeader(SalesHeader, "Sales Document Type"::Invoice, '01121212');

        CreateSalesLine(SalesHeader, "Sales Line Type"::Item, '1000', 1, LineNo);
        CreateSalesLine(SalesHeader, "Sales Line Type"::Item, '1001', 1, LineNo);
        CreateSalesLine(SalesHeader, "Sales Line Type"::Resource, 'LIFT', 2, LineNo);

        OpenSalesDocument(SalesHeader);
    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; DocType: Enum "Sales Document Type"; CustomerNo: Code[20])
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := DocType;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; LineType: Enum "Sales Line Type"; No: Code[20]; Qty: Decimal; var LineNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        LineNo := LineNo + 10000;

        SalesLine.Init();
        SalesLine."Line No." := LineNo;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine.Insert(true);
        SalesLine.Validate(Type, LineType);
        SalesLine.Validate("No.", No);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Modify(true);
    end;

    local procedure OpenSalesDocument(var SalesHeader: Record "Sales Header")
    var
        LabelErr: Label '%1 document is not supported for preview', Comment = '%1: Document Type';
    begin
        Case SalesHeader."Document Type" of
            "Sales Document Type"::Invoice:
                Page.Run(Page::"Sales Invoice", SalesHeader);
            "Sales Document Type"::"Credit Memo":
                Page.Run(Page::"Sales Credit Memo", SalesHeader);
            "Sales Document Type"::Order:
                Page.Run(Page::"Sales Order", SalesHeader);
            else
                Error(LabelErr, SalesHeader."Document Type");
        End;
    end;
}
