/*

https://www.terraform.io/docs/providers/google/r/container_cluster.html

*/

# Configure the Google Cloud provider
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

// Create the Google Container Cluster
resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "${var.gcp_primary_zone}"
  initial_node_count = "${var.initial_node_count}"

  additional_zones = "${var.gcp_additional_zones}"

  // HTTP basic authentication for accessing Kubernets master endpoint
  master_auth {
    username = "${var.gcp_master_username}"
    password = "${var.gcp_master_password}"
  }

  node_config {
    machine_type = "${var.machine_type}"
    disk_size_gb = "${var.disk_size_gb}"
    image_type   = "${var.image_type}"

    local_ssd_count = "${var.local_ssd_count}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  provisioner "local-exec" "get-credentials" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${google_container_cluster.primary.zone}"
  }

  provisioner "local-exec" "custom" {
    command = "${var.custom_provisioner}"
  }
}
