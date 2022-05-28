/// <summary>
/// Codeunit Json Parser (ID 50111).
/// </summary>
codeunit 50111 "Json Builder"
{
    var
        DocumentToken: JsonToken;

    trigger OnRun()
    var
        JsonBuilder: Codeunit "Json Builder";
    begin
        JsonBuilder.NewArray();
        JsonBuilder.Add(BuildJson('a'));
        JsonBuilder.Add(BuildJson('b'));
        Message(JsonBuilder.AsString());
    end;

    local procedure BuildJson(Token: Text): JsonToken
    var
        JsonBuilder: Codeunit "Json Builder";
    begin
        JsonBuilder.Add('key1', Token + '1');
        JsonBuilder.Add('key2', Token + '2');
        exit(JsonBuilder.AsToken());
    end;


    /// <summary>
    /// Creates new json object.
    /// </summary>
    procedure New()
    var
        JsonObject: JsonObject;
    begin
        DocumentToken := JsonObject.AsToken();
    end;

    /// <summary>
    /// Creates new json object from token.
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    procedure New(JsonToken: JsonToken)
    begin
        DocumentToken := JsonToken;
    end;

    /// <summary>
    /// Creates new json object from object.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    procedure New(JsonObject: JsonObject)
    begin
        DocumentToken := JsonObject.AsToken();
    end;

    /// <summary>
    /// Creates new json array.
    /// </summary>
    procedure NewArray()
    var
        JsonArray: JsonArray;
    begin
        DocumentToken := JsonArray.AsToken();
    end;

    /// <summary>
    /// Creates new json array from Array token.
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    procedure NewArray(JsonToken: JsonToken)
    begin
        DocumentToken := JsonToken;
    end;

    /// <summary>
    /// Creates new json array from Array.
    /// </summary>
    /// <param name="JsonArray">JsonArray.</param>
    procedure NewArray(JsonArray: JsonArray)
    begin
        DocumentToken := JsonArray.AsToken();
    end;

    /// <summary>
    /// Adds new key/value pair to an json object.
    /// </summary>
    /// <param name="NodeKey">Text.</param>
    /// <param name="NodeValue">Text.</param>
    procedure Add(NodeKey: Text; NodeValue: Text)
    begin
        If IsNull() then
            New();
        If not DocumentToken.IsObject() then
            Error('Pair %1/%2 can not be added to Json %3.', NodeKey, NodeValue, GetType());
        DocumentToken.AsObject().Add(NodeKey, NodeValue);
    end;

    /// <summary>
    /// Adds new object to an array.
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    procedure Add(JsonToken: JsonToken)
    var
        JsonBuilder: Codeunit "Json Builder";
    begin
        JsonBuilder.New(JsonToken);
        If IsNull() then
            NewArray();
        If not DocumentToken.IsArray() then
            Error('Json %1 can not be added to Json %2.', JsonBuilder.AsString(), GetType());
        DocumentToken.AsArray().Add(JsonToken);
    end;

    /// <summary>
    /// Returns string from document.
    /// </summary>
    /// <returns>Return variable Result of type Text.</returns>
    procedure AsString() Result: Text
    begin
        DocumentToken.WriteTo(Result);
    end;

    /// <summary>
    /// Returns Json token from document.
    /// </summary>
    /// <returns>Return value of type JsonToken.</returns>
    procedure AsToken(): JsonToken
    begin
        exit(DocumentToken);
    end;

    /// <summary>
    /// Tests if document is empty or null.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsNull(): Boolean;
    begin
        exit(AsString() = 'null');
    end;

    /// <summary>
    /// Returns type of document.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetType(): Text;
    begin
        case true of
            DocumentToken.IsArray:
                exit('Array');
            DocumentToken.IsObject:
                exit('Object');
            DocumentToken.IsValue:
                exit('Value');
            else
                exit('Unknown');
        end;
    end;

    /// <summary>
    /// Field returns value of field as JsonValue.
    /// </summary>
    /// <param name="FieldName">Name of the field to retrieve.</param>
    /// <returns>Return value of type JsonFiles. Add AsText or such function to then end of this call.</returns>
    procedure Field(FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        DocumentToken.AsObject().Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;
}