/// <summary>
/// Page Web Service Setup (ID 50105).
/// </summary>
page 50105 "Web Service Setup"
{
    Caption = 'Web Service Setup';
    PageType = Card;
    SourceTable = "Web Service Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                grid(Grid1)
                {
                    group(Column1)
                    {
                        ShowCaption = false;
                        field("Base Url"; Rec."Base Url")
                        {
                            ToolTip = 'Specifies the value of the Base Url field.';
                            ApplicationArea = All;
                        }
                        field("Default Tenant"; Rec."Default Tenant")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Default Tenant field.';
                        }
                        field("Default Company"; Rec."Default Company")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Default Company field.';
                        }
                        field(Authentication; Rec.Authentication)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Authentication field.';

                            trigger OnValidate()
                            begin
                                IsBasicAuth := Rec.Authentication = Rec.Authentication::Basic;
                            end;
                        }
                    }
                }
            }
            group(User)
            {
                Caption = 'Login Information';
                Visible = IsBasicAuth;
                grid(Grid2)
                {
                    group(Column2)
                    {
                        ShowCaption = false;
                        field(UserName; Rec.UserName)
                        {
                            ToolTip = 'Specifies the value of the UserName field.';
                            ApplicationArea = All;
                        }
                        field(Password; Rec.Password)
                        {
                            ToolTip = 'Specifies the value of the Password field.';
                            ApplicationArea = All;
                            ExtendedDatatype = Masked;
                        }
                    }
                }
            }
        }
    }

    var
        IsBasicAuth: Boolean;

    trigger OnOpenPage()
    begin
        If not Rec.FindFirst() then begin
            Rec.Init();
            Rec."Base Url" := GetBaseURL();
            Rec.Insert();
        end;

        if Rec."Default Company" = '' then begin
            Rec."Base Url" := GetBaseURL();
            Rec."Default Company" := CopyStr(CompanyName(), 1, 30);
            Rec."Default Tenant" := 'default';
            REc.Modify();
        end;

        IsBasicAuth := Rec.Authentication = Rec.Authentication::Basic;
    end;

    local procedure GetBaseURL(): Text[250]
    begin
        exit('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api');
    end;

}
