variable "domain" {
  description = "The domain or email address to create the SES identity for."
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 parent zone ID. This is required if you want to create validation records in Route53"
  default     = ""
}

variable "verify_dkim" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for DKIM verification."
  default     = false
}

variable "create_spf_record" {
  type        = bool
  description = "If provided the module will create an Route53 SPF record for 'domain'."
  default     = false
}

variable "custom_from_subdomain" {
  type        = list(string)
  description = "If provided the module will create a custom subdomain for the 'From' address."
  default     = []

  validation {
    condition     = length(var.custom_from_subdomain) <= 1
    error_message = "Only one custom_from_subdomain is allowed."
  }

  validation {
    condition     = length(var.custom_from_subdomain) > 0 ? can(regex("^[a-zA-Z0-9-]+$", var.custom_from_subdomain[0])) : true
    error_message = "The custom_from_subdomain must be a valid subdomain."
  }
}

variable "custom_from_behavior_on_mx_failure" {
  type        = string
  description = "The behaviour of the custom_from_subdomain when the MX record is not found. Defaults to `UseDefaultValue`."
  default     = "USE_DEFAULT_VALUE"

  validation {
    condition     = contains(["USE_DEFAULT_VALUE", "REJECT_MESSAGE"], var.custom_from_behavior_on_mx_failure)
    error_message = "The custom_from_behavior_on_mx_failure must be `USE_DEFAULT_VALUE` or `REJECT_MESSAGE`."
  }
}

variable "configuration_set_name" {
  description = "Name of the configuration set to use for the identity"
  type        = string
  default     = null
}

variable "configure_dmarc" {
  type    = bool
  default = false
}

variable "dmarc_action" {
  type = string
  validation {
    condition     = contains(["none", "quarantine", "reject"], var.dmarc_action)
    error_message = "The DMARC action has to be one of ['none', 'quarantine', 'reject']"
  }
  default = "none"
}
