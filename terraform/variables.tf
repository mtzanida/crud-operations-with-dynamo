variable "bus_name" {
  description = "The name of the event bus to create in EventBridge"
  type        = string
  default     = "marias-bus"
}

variable "create_log_group" {
  description = "If true, create a log group with appropriate permissions to write events from the bus"
  type        = bool
  default     = true
}
