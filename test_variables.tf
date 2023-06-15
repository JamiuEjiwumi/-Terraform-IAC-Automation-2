variable "SPACES_ACCESS_ID" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "DO00DVPL7G2KH694LMTT"
}


variable "SPACES_SECRET_KEY" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "zxiRQgitV6EqToqafVcxrEDW7Ce29oEsCC+zvN0rEC0"

}

variable "digitalocean_token" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "dop_v1_e89cfae6c786ceed7de67c9fddd9ffabad5ae06a33ae7da899ad59e6d912385e"
}


variable "POSTGRES_ADMIN_PASSWORD" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "ca80d2210fd6049a1fbc728d"
}

variable "AMPLIFY_LAFIA_ADMIN_PASSWORD" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "AmplifyLafiaAdminUser"
}


variable "WEB_SERVER_SECRET_KEY" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "58eb10b0681e73ccca961b3195fed439"

}


variable "LAKEFS_AUTH_ENCRYPT_SECRET_KEY" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "350ef40213389988232e5e379e9093ec"
}


variable "cluster-name" {
  description = "Name of the kubernetes cluster"
  type        = string
  default     = "cloak-lafia"
}

variable "dns-name" {
  description = "Name of the DNS"
  type = string
  default = "cloakio.dev"
}


