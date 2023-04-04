variable "resource_group" {
  default     = "cognata-1"
  type        = string
  description = "Name of the resource group"
}

variable "project" {
  default     = "cognata"
  type        = string
  description = "Name of the project"
}

variable "location" {
  default     = "westeurope"
  type        = string
  description = "Name of the region"
}