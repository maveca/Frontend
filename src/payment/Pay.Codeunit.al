/// <summary>
/// Codeunit Pay (ID 50102).
/// </summary>
codeunit 50102 Pay
{
    trigger OnRun()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJournalLine.Init();

        GenJournalLine."Journal Template Name" := 'PAYMENT';
        GenJournalLine."Journal Batch Name" := 'BANK';
        GenJournalLine."Line No." := 20000;
        GenJournalLine.Insert(true);


        GenJournalLine.Validate("Posting Date", WorkDate());
        GenJournalLine.Validate("Document Type", GenJournalLine."Document Type"::Payment);
        GenJournalLine.Validate("Document No.", 'TEMP-001');
        GenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.Validate("Account No.", '10000');
        GenJournalLine.Validate(Description, 'Payment via Bank');
        GenJournalLine.Validate("Payment Method Code", 'BANK');

        GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.Validate("Bal. Account No.", 'GIRO');

        GenJournalLine.Validate(Amount, -10000);
        GenJournalLine.Validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
        GenJournalLine.Validate("Applies-to Doc. No.", '103015');

        GenJournalLine.Modify(true);

        // Post Gen. Journal Line:
        GenJnlPost.Run(GenJournalLine);
    end;
}
