/// <summary>
/// Codeunit Password (ID 50106).
/// </summary>
codeunit 50106 "Login Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
        StorePassword('admin', 'Pa$$word');
        if HasUser('admin') then
            Message('%1', GetPassword('admin'))
        else
            Message('admin user does not exists');
    end;

    local procedure HasUser(User: Text): boolean
    begin
        exit(IsolatedStorage.Contains(User));
    end;

    /// <summary>
    /// StorePassword.
    /// </summary>
    /// <param name="User">Text.</param>
    /// <param name="Pwd">Text.</param>
    /// <returns>Return value of type boolean.</returns>
    procedure StorePassword(User: Text; Pwd: Text): boolean
    begin
        // https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-encrypting-data
        if EncryptionEnabled() then
            exit(IsolatedStorage.SetEncrypted(User, Pwd))
        else
            exit(IsolatedStorage.Set(User, Pwd));
    end;

    local procedure GetPassword(User: Text) Pwd: Text
    begin
        IsolatedStorage.Get(User, Pwd);
        exit(Pwd);
    end;

    /// <summary>
    /// CheckPassword.
    /// </summary>
    /// <param name="User">Text.</param>
    /// <param name="Pwd">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckPassword(User: Text; Pwd: Text): Boolean
    var
        Login: Record Login;
    begin
        Login.SetRange("User Name", User);
        if Login.IsEmpty() then
            Error('User %1 is not registered yet.', User);

        exit(GetPassword(User) = Pwd);
    end;

    /// <summary>
    /// GetCurrentUser.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetCurrentUser(): Text;
    begin
        exit(CurrentUser);
    end;

    /// <summary>
    /// GetCurrentLogin.
    /// </summary>
    /// <returns>Return variable Login of type Record Login.</returns>
    procedure GetCurrentLogin() Login: Record Login;
    begin
        Login.SetRange("User Name", CurrentUser);
        if not Login.FindFirst() then
            Clear(Login);
    end;


    /// <summary>
    /// SetCurrentUser.
    /// </summary>
    /// <param name="NewUser">Text.</param>
    procedure SetCurrentUser(NewUser: Text);
    begin
        CurrentUser := NewUser;
    end;

    var
        CurrentUser: Text;
}