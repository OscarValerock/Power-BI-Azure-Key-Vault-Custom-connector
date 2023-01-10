// Use this file to write queries to test your data connector
let
    result = Azure_Key_Vault.Secrets("https://bibbpbikeyvault.vault.azure.net/")
    //result = Azure_Key_Vault.Secrets("https://bibbpbikeyvault.vault.azure.net/", "Clockify")
in
    result