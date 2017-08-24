# https://www.terraform.io/docs/providers/google/r/container_cluster.html#argument-reference

variable "cluster_name" {
  description = "Google Container Cluster name to use for the cluster"
}

variable "gcp_primary_zone" {
  description = "Google Computer zone to use for the cluster"
  default     = "us-west1-a"
}

variable "gcp_additional_zones" {
  description = "Additional Google Compute zones for a multi-zone cluster"
  default     = []
}

variable "initial_node_count" {
  description = "Number of nodes to bring up in each zone"
  default     = "3"
}

// Node configuration
variable "machine_type" {
  description = "The name of a Google Compute Engine machine type. Defaults to n1-standard-1."
  default     = "n1-standard-1"
}

// Container image to run on each node: options include cos (default), ubuntu and container-vm (deprecated)
// https://cloud.google.com/container-engine/docs/node-images
variable "image_type" {
  description = "Container image to run on each node: options include cos (default), ubuntu and container-vm (deprecated)"
  default     = "COS"
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100"
  default     = "20"
}

variable "local_ssd_count" {
  description = "(Optional) The amount of local SSD disks that will be attached to each cluster node. Defaults to 0."
  default     = "0"
}

variable "gcp_master_username" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint"
}

variable "gcp_master_password" {
  description = "The password to use for HTTP basic authentication when accessing the Kubernetes master endpoint"
}

variable "custom_provisioner" {
  description = "Additional local-exec provisioner commands"
  default     = ""
}
