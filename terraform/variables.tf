variable "minikube_version" {
  type        = string
  description = "The version of Minikube to install"
  default     = "v1.32.0"

  # Add validation for version format
  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.minikube_version))
    error_message = "The minikube_version must be a valid semantic version starting with 'v' (e.g., v1.32.0)."
  }

  # Add validation for minimum version
  validation {
    condition     = tonumber(replace(replace(var.minikube_version, "v", ""), ".", "")) >= 1320
    error_message = "The minikube_version must be v1.32.0 or higher."
  }

  # Add sensitive marker if version needs to be hidden in logs
  sensitive = false
}

# Add additional supporting variables
variable "minikube_cpu" {
  type        = number
  description = "Number of CPUs to allocate to Minikube"
  default     = 2

  validation {
    condition     = var.minikube_cpu >= 1 && var.minikube_cpu <= 8
    error_message = "CPU allocation must be between 1 and 8 cores."
  }
}

variable "minikube_memory" {
  type        = string
  description = "Amount of memory to allocate to Minikube"
  default     = "4096mb"

  validation {
    condition     = can(regex("^[0-9]+(mb|gb)$", var.minikube_memory))
    error_message = "Memory must be specified in mb or gb (e.g., 4096mb or 4gb)."
  }
}