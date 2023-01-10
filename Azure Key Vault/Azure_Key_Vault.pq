// This file contains your Data Connector logic
section Azure_Key_Vault;


[DataSource.Kind="Azure_Key_Vault", Publish="Azure_Key_Vault.Publish"]
shared Azure_Key_Vault.Secrets = (vaultBaseUrl as text) =>
    let
        Source = Json.Document(
            Web.Contents(
                vaultBaseUrl & "secrets/?api-version=7.3"
            ),
            65001)[value],
        #"Converted to table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expanded Column" = Table.ExpandRecordColumn(#"Converted to table", "Column1",{"id"},{"Secret URL"}),
        #"Inserted text after delimiter" = Table.AddColumn(#"Expanded Column", "Secret name", each Text.AfterDelimiter([Secret URL], "/", { 0, RelativePosition.FromEnd}), type text),
        #"Get secret value fx" = (SecretURL as text) => Json.Document(
            Web.Contents(SecretURL & "?api-version=7.3")       
        )[value],
        #"Get secret value"  = Table.AddColumn(
           #"Inserted text after delimiter",
           "Secret value",
           each #"Get secret value fx" ([Secret URL])
        )
    in
        #"Get secret value";

// Data Source Kind description
Azure_Key_Vault = [
    TestConnection = (dataSourcePath) => {"Azure_Key_Vault.Secrets", dataSourcePath},
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
