// Use this file to write queries to test your data connector
let
    result = Azure_Key_Vault.Contents("https://bibbpbikeyvault.vault.azure.net/", "Clockify")
in
    result