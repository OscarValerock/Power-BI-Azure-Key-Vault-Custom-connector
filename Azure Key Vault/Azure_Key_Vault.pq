// This file contains your Data Connector logic
section Azure_Key_Vault;

[DataSource.Kind="Azure_Key_Vault", Publish="Azure_Key_Vault.Publish"]
shared Azure_Key_Vault.Contents = (vaultBaseUrl as text, secret as text) =>
    let
        Source = Web.Contents( vaultBaseUrl & "secrets/" & secret & "?api-version=7.3"),
        #"Imported JSON" = Json.Document(Source)[value]
    in
        #"Imported JSON";

// Data Source Kind description
Azure_Key_Vault = [
    Authentication = [
        Aad = [
            AuthorizationUri = "https://login.microsoftonline.com/common/oauth2/authorize",
            Resource = "https://vault.azure.net"
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
Azure_Key_Vault.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = Azure_Key_Vault.Icons,
    SourceTypeImage = Azure_Key_Vault.Icons
];

Azure_Key_Vault.Icons = [
    Icon16 = { Extension.Contents("Azure_Key_Vault16.png"), Extension.Contents("Azure_Key_Vault20.png"), Extension.Contents("Azure_Key_Vault24.png"), Extension.Contents("Azure_Key_Vault32.png") },
    Icon32 = { Extension.Contents("Azure_Key_Vault32.png"), Extension.Contents("Azure_Key_Vault40.png"), Extension.Contents("Azure_Key_Vault48.png"), Extension.Contents("Azure_Key_Vault64.png") }
];
