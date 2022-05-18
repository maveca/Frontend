/// <summary>
/// Page UserRoleCenter (ID 50100).
/// </summary>
page 50100 UserRoleCenter
{
    Caption = 'UserRoleCenter';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(HeadlineRC; "Headline RC User")
            {
                ApplicationArea = All;
            }
            group(MyGroup)
            {
                Caption = 'RoleCenter Group';
                part(UserActivity; UserActivity)
                {
                    Caption = 'UserActivity';
                }

                part(ResourcePart; "Resource Picture")
                {
                    SubPageLink = "No." = const('LINA');
                }

                part(CustomerListPart2; CustomerListPart)
                {
                    Caption = 'Customer List Part';
                }
            }
            group(Right)
            {
                part(LoginPart; "Login Info")
                {
                    Caption = 'Login Info';
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(PostedInvoices)
            {
                Caption = 'Posted Invoices';
                Image = RegisteredDocs;
                action(PostedServiceInvoices)
                {
                    Caption = 'Posted Service Invoices';
                    RunObject = Page "Posted Service Invoices";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Posted Service Invoices action.';
                }

                action(PostedSalesInvoices)
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Posted Sales Invoices action.';
                }

                group(SalesDocuments)
                {
                    Caption = 'Sales Documents';
                    action("Sales Document Entity")
                    {
                        ApplicationArea = All;
                        RunObject = page "Sales Document Entity";
                        ToolTip = 'Executes the Sales Document Entity action.';
                    }
                    action("Sales Document Line Entity")
                    {
                        ApplicationArea = All;
                        RunObject = page "Sales Document Line Entity";
                        ToolTip = 'Executes the Sales Document Line Entity action.';
                    }
                }
            }
        }

        area(Embedding)
        {

            action(Sales)
            {
                Caption = 'Sales lists';
                RunObject = Page "Sales list";
                ApplicationArea = All;
                ToolTip = 'Executes the Sales lists action.';
            }

            action(Services)
            {
                Caption = 'Service lists';
                RunObject = Page "Service list";
                ApplicationArea = All;
                ToolTip = 'Executes the Service lists action.';

            }


        }

        area(Processing)
        {
            action(SeeSalesInvoices)
            {
                Caption = 'See Sales Invoices';
                RunObject = Page "Posted Sales Invoices";
                ToolTip = 'Executes the See Sales Invoices action.';
            }

        }

        area(Creation)
        {
            action(AddSalesInvoice)
            {
                Caption = 'Add Sales Invoice';
                Image = NewInvoice;
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
                ToolTip = 'Executes the Add Sales Invoice action.';
            }
        }

        area(Reporting)
        {
            action(SalesInvoicesReport)
            {
                Caption = 'Sales Invoices Report';
                Image = "Report";
                RunObject = Report "Sales - Shipment";
                ToolTip = 'Executes the Sales Invoices Report action.';
            }
        }
    }
}
