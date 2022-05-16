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

                part(CustomerListPart2; CustomerListPart)
                {
                    Caption = 'Customer List Part';
                }
                part(LoginPart; "Login Info")
                {
                    Caption = 'Login Info';
                }
            }
        }
    }
}
