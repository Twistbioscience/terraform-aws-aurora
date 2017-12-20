variable "name" {
  type        = "string"
  description = "Name given to DB subnet group"
}

variable "subnets" {
  type        = "list"
  description = "List of subnet IDs to use"
}

variable "create_rds" {
  type        = "string"
  description = "Environment type (eg,prod or nonprod)"
}

variable "replica_count" {
  type        = "string"
  default     = "0"
  description = "Number of reader nodes to create"
}

variable "instance_type" {
  type        = "string"
  default     = ""
  description = "Instance type to use"
}

variable "publicly_accessible" {
  type        = "string"
  default     = "false"
  description = "Whether the DB should have a public IP address"
}

variable "username" {
  default     = "root"
  description = "Master DB username"
}

variable "password" {
  type        = "string"
  description = "Master DB password"
}

variable "backup_retention_period" {
  type        = "string"
  default     = "7"
  description = "How long to keep backups for (in days)"
}

variable "preferred_backup_window" {
  type        = "string"
  default     = "02:00-03:00"
  description = "When to perform DB backups"
}

variable "preferred_maintenance_window" {
  type        = "string"
  default     = "sun:05:00-sun:06:00"
  description = "When to perform DB maintenance"
}

variable "port" {
  type        = "string"
  default     = ""
  description = "The port on which to accept connections"
}

variable "rds_vpc_id" {
    description = "VPC to connect to, used for a security group"
    type = "string"
}

variable "private_cidr" {
    description = "VPC private addressing, used for a security group"
    type = "list"
}

variable "apply_immediately" {
  type        = "string"
  default     = "false"
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = "string"
  default     = "true"
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
}

variable "db_parameter_group_name" {
  type        = "string"
  default     = ""
  description = "The name of a DB parameter group to use"
}

variable "db_cluster_parameter_group_name" {
  type        = "string"
  default     = ""
  description = "The name of a DB Cluster parameter group to use"
}

variable "snapshot_identifier" {
  type        = "string"
  default     = ""
  description = "DB snapshot to create this database from"
}

variable "storage_encrypted" {
  type        = "string"
  default     = "true"
  description = "Specifies whether the underlying storage layer should be encrypted"
}
