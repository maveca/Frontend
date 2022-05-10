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
            group(MyGroup)
            {
                Caption = 'RoleCenter Group';
                part(UserActivity; UserActivity)
                {
                    Caption = 'UserActivity';
                }
                part(CustomerListPart; CustomerListPart)
                {
                    Caption = 'Customer List Part';
                    Provider = CustomerListPart2;
                }
                part(CustomerListPart2; CustomerListPart)
                {
                    Caption = 'Customer List Part';
                }
            }
        }
    }
}
