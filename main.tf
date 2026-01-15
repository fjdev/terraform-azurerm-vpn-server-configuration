resource "azurerm_resource_group" "rg" {
  count = var.deploy_resource_group ? 1 : 0

  name       = var.resource_group_name
  location   = var.location
  managed_by = var.managed_by
  tags       = try(var.tags.resource_group, null)
}

resource "azurerm_vpn_server_configuration" "vpnsc" {
  name                     = var.name
  resource_group_name      = var.deploy_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
  location                 = var.location
  vpn_authentication_types = var.vpn_authentication_types

  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy != null ? [var.ipsec_policy] : []

    content {
      dh_group               = ipsec_policy.value.dh_group
      ike_encryption         = ipsec_policy.value.ike_encryption
      ike_integrity          = ipsec_policy.value.ike_integrity
      ipsec_encryption       = ipsec_policy.value.ipsec_encryption
      ipsec_integrity        = ipsec_policy.value.ipsec_integrity
      pfs_group              = ipsec_policy.value.pfs_group
      sa_lifetime_seconds    = ipsec_policy.value.sa_lifetime_seconds
      sa_data_size_kilobytes = ipsec_policy.value.sa_data_size_kilobytes
    }
  }

  vpn_protocols = var.vpn_protocols
  tags          = var.deploy_resource_group ? try(var.tags.vpn_server_configuration, null) : var.tags

  dynamic "azure_active_directory_authentication" {
    for_each = contains(var.vpn_authentication_types, "AAD") ? [var.azure_active_directory_authentication] : []

    content {
      audience = azure_active_directory_authentication.value.audience
      issuer   = azure_active_directory_authentication.value.issuer
      tenant   = azure_active_directory_authentication.value.tenant
    }
  }

  dynamic "client_root_certificate" {
    for_each = contains(var.vpn_authentication_types, "Certificate") ? var.client_root_certificate : {}

    content {
      name             = client_root_certificate.key
      public_cert_data = client_root_certificate.value.publipublic_cert_data
    }
  }

  dynamic "client_revoked_certificate" {
    for_each = contains(var.vpn_authentication_types, "Certificate") && var.client_revoked_certificate != null ? var.client_revoked_certificate : {}

    content {
      name       = client_revoked_certificate.key
      thumbprint = client_revoked_certificate.value.thumbprint
    }
  }

  dynamic "radius" {
    for_each = contains(var.vpn_authentication_types, "Radius") && var.radius != null ? [var.radius] : []

    content {
      dynamic "server" {
        for_each = radius.value.server

        content {
          address = server.value.address
          secret  = server.value.secret
          score   = server.value.score
        }
      }

      dynamic "client_root_certificate" {
        for_each = radius.value.client_root_certificate != null ? radius.value.client_root_certificate : {}

        content {
          name       = client_root_certificate.key
          thumbprint = client_root_certificate.value.thumbprint
        }
      }

      dynamic "server_root_certificate" {
        for_each = radius.value.server_root_certificate != null ? radius.value.server_root_certificate : {}

        content {
          name             = server_root_certificate.key
          public_cert_data = server_root_certificate.value.public_cert_data
        }
      }
    }
  }
}

resource "azurerm_vpn_server_configuration_policy_group" "vpnscpg" {
  for_each = var.policy_groups != null ? var.policy_groups : {}

  name                        = each.key
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpnsc.id

  dynamic "policy" {
    for_each = each.value.policies

    content {
      name  = policy.key
      type  = policy.value.type
      value = policy.value.value
    }
  }

  is_default = each.value.is_default
  priority   = each.value.priority
}