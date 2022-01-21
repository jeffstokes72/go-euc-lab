resource "random_integer" "azurefiles" {
  min = 1000000
  max = 9999999
}

resource "azurerm_storage_account" "azurefiles" {
  name                     = "sa${local.environment_abbreviations[terraform.workspace]}${random_integer.azurefiles.result}"
  resource_group_name      = azurerm_resource_group.AzureFiles.name
  location                 = azurerm_resource_group.AzureFiles.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "azurefiles" {
  name                 = "share"
  storage_account_name = azurerm_storage_account.azurefiles.name
  quota                = 50

#  acl {
#    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
#
#    access_policy {
#      permissions = "rwdl"
#      start       = "2022-01-01T09:38:21.0000000Z"
#      expiry      = "2022-07-02T10:38:21.0000000Z"
#    }
#  }
}

resource "azurerm_storage_share_directory" "software" {
  name                 = "software"
  share_name           = azurerm_storage_share.azurefiles.name
  storage_account_name = azurerm_storage_account.azurefiles.name
}

resource "azurerm_storage_share_file" "dummyfile" {
  path             = azurerm_storage_share_directory.software.name
  name             = "azurefiles.txt"
  storage_share_id = azurerm_storage_share.azurefiles.id
}