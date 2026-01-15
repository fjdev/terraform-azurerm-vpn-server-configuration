variable "name" {
  type        = string
  description = "(Required) The Name which should be used for this VPN Server Configuration. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The Name of the Resource Group in which this VPN Server Configuration should be created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where this VPN Server Configuration should be created. Changing this forces a new resource to be created."
  default     = "westeurope"
}

variable "vpn_authentication_types" {
  type        = list(string)
  description = "(Required) A list of Authentication Types applicable for this VPN Server Configuration. Possible values are AAD (Azure Active Directory), Certificate and Radius."
}

variable "ipsec_policy" {
  type = object({
    dh_group              = string
    ike_encryption        = string
    ike_integrity         = string
    ipsec_encryption      = string
    ipsec_integrity       = string
    pfs_group             = string
    sa_lifetime_seconds   = number
    sa_dat_size_kilobytes = number
  })
  description = "(Optional) A ipsec_policy block as defined above."
  default     = null
}

variable "vpn_protocols" {
  type        = list(string)
  description = "(Optional) A list of VPN Protocols to use for this Server Configuration. Possible values are IkeV2 and OpenVPN."
  default     = []
}

variable "tags" {
  type        = any
  description = "(Optional) A mapping of tags to assign to the resources"
  default     = null
}

variable "azure_active_directory_authentication" {
  type = object({
    audience = string
    issuer   = string
    tenant   = string
  })
  description = "(Optional) A azure_active_directory_authentication block as defined above."
  default     = null
}

variable "client_root_certificate" {
  type = map(object({
    public_cert_data = string
  }))
  description = "(Optional) One or more client_root_certificate blocks as defined above."
  default     = null
}

variable "client_revoked_certificate" {
  type = map(object({
    thumbprint = string
  }))
  description = "(Optional) One or more client_revoked_certificate blocks as defined above."
  default     = null
}

variable "radius" {
  type = object({
    server = map(object({
      address = string
      secret  = string
      score   = number
    }))
    client_root_certificate = optional(map(object({
      thumbprint = string
    })))
    server_root_certificate = optional(map(object({
      public_cert_data = string
    })))
  })
  description = "(Optional) A radius block as defined above."
  default     = null
}

variable "deploy_resource_group" {
  type        = bool
  description = "(Optional) Specifies whether to deploy the resource group or not. Defaults to true."
  default     = true
}

variable "managed_by" {
  type        = string
  default     = null
  description = "(Optional) The ID of the resource or application that manages this Resource Group."
}

variable "policy_groups" {
  type = map(object({
    policies = map(object({
      type  = string
      value = string
    }))
    is_default = optional(bool)
    priority   = optional(number)
  }))
  description = "(Optional) One or more policy_groups blocks as defined above."
  default     = null
}