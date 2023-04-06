variable "resource_group" {
  default     = "cognata-test"
  type        = string
  description = "Name of the resource group"
}

variable "project" {
  default     = "cognata"
  type        = string
  description = "Name of the project"
}

variable "location" {
  default     = "uksouth"
  type        = string
  description = "Name of the region"
}