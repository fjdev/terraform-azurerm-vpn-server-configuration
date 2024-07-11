<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_vpn_server_configuration.vpnsc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_server_configuration) | resource |
| [azurerm_vpn_server_configuration_policy_group.vpnscpg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_server_configuration_policy_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_active_directory_authentication"></a> [azure\_active\_directory\_authentication](#input\_azure\_active\_directory\_authentication) | (Optional) A azure\_active\_directory\_authentication block as defined above. | <pre>object({<br>    audience = string<br>    issuer   = string<br>    tenant   = string<br>  })</pre> | `null` | no |
| <a name="input_client_revoked_certificate"></a> [client\_revoked\_certificate](#input\_client\_revoked\_certificate) | (Optional) One or more client\_revoked\_certificate blocks as defined above. | <pre>map(object({<br>    thumbprint = string<br>  }))</pre> | `null` | no |
| <a name="input_client_root_certificate"></a> [client\_root\_certificate](#input\_client\_root\_certificate) | (Optional) One or more client\_root\_certificate blocks as defined above. | <pre>map(object({<br>    public_cert_data = string<br>  }))</pre> | `null` | no |
| <a name="input_deploy_resource_group"></a> [deploy\_resource\_group](#input\_deploy\_resource\_group) | (Optional) Specifies whether to deploy the resource group or not. Defaults to true. | `bool` | `true` | no |
| <a name="input_ipsec_policy"></a> [ipsec\_policy](#input\_ipsec\_policy) | (Optional) A ipsec\_policy block as defined above. | <pre>object({<br>    dh_group              = string<br>    ike_encryption        = string<br>    ike_integrity         = string<br>    ipsec_encryption      = string<br>    ipsec_integrity       = string<br>    pfs_group             = string<br>    sa_lifetime_seconds   = number<br>    sa_dat_size_kilobytes = number<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where this VPN Server Configuration should be created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_managed_by"></a> [managed\_by](#input\_managed\_by) | (Optional) The ID of the resource or application that manages this Resource Group. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The Name which should be used for this VPN Server Configuration. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_policy_groups"></a> [policy\_groups](#input\_policy\_groups) | (Optional) One or more policy\_groups blocks as defined above. | <pre>map(object({<br>    policies = map(object({<br>      type  = string<br>      value = string<br>    }))<br>    is_default = optional(bool)<br>    priority   = optional(number)<br>  }))</pre> | `null` | no |
| <a name="input_radius"></a> [radius](#input\_radius) | (Optional) A radius block as defined above. | <pre>object({<br>    server = map(object({<br>      address = string<br>      secret  = string<br>      score   = number<br>    }))<br>    client_root_certificate = optional(map(object({<br>      thumbprint = string<br>    })))<br>    server_root_certificate = optional(map(object({<br>      public_cert_data = string<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The Name of the Resource Group in which this VPN Server Configuration should be created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resources | `any` | `null` | no |
| <a name="input_vpn_authentication_types"></a> [vpn\_authentication\_types](#input\_vpn\_authentication\_types) | (Required) A list of Authentication Types applicable for this VPN Server Configuration. Possible values are AAD (Azure Active Directory), Certificate and Radius. | `list(string)` | n/a | yes |
| <a name="input_vpn_protocols"></a> [vpn\_protocols](#input\_vpn\_protocols) | (Optional) A list of VPN Protocols to use for this Server Configuration. Possible values are IkeV2 and OpenVPN. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPN Server Configuration. |
<!-- END_TF_DOCS -->

## Usage

```hcl
data "azurerm_client_config" "current" {
}

module "vpn_server_configuration" {
  source = "github.com/fjdev/terraform-azurerm-vpn-server-configuration"

  name                     = "example-vpnsc"
  deploy_resource_group    = false
  resource_group_name      = "example-rg"
  location                 = "West Europe"
  vpn_authentication_types = "AAD"
  vpn_protocols            = ["OpenVPN"]

  azure_active_directory_authentication = {
    audience = "9674bbcc-2cf5-45e8-946e-533ab37360fd"
    issuer   = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}"
    tenant   = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
  }
}
```