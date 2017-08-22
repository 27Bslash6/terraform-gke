# terraform-gke
_Building a Google Container Cluster on Google Compute using Terraform_

## Prerequisites
*   terraform > version 0.6.14
*   gcloud commandline tool
*   kubectl > version 1.2.2

## Getting Started

Create a [Terraform variables file](https://www.terraform.io/intro/getting-started/variables.html#from-a-file) (eg `production.auto.tfvars`) in the parent directory with the following content to supply the required parameters.
```bash
gcp_credentials = "[location of Google Compute credentials]"
gcp_project = "[Google Compute project name]"
cluster_name = "[Name of the Google Container cluster]"
```

Alternately, establish environment variables with the requisite content and [Terraform will pick them up automatically](https://www.terraform.io/intro/getting-started/variables.html#from-environment-variables), for example:
```bash
export TF_VARS_gcp_credentials=~/.config/gcloud/terraform.json
export TF_VARS_gcp_project=$(gcloud config get-value project)
export TF_VARS_cluster_name="production-app-cluster1"
```
See the section below on how to obtain the Google Compute credentials file.

Next create a `secrets.tfvars` variables file with the following content to supply HTTP authentication username and password for the Kubernetes master endpoint

```bash
gcp_master_username = "admin"
gcp_master_password = "password"
```


### Start it up

To create a Google Container cluster run `terraform plan` with any variables files, eg:
```bash
terraform plan \
  -var-file=secrets.tfvars \
  -var-file=production.tfvars
```

If it the plan looks good, bring it up with:
```bash
terraform apply \
  -var-file=secrets.tfvars \
  -var-file=production.tfvars
```

Run `kubectl cluster-info` to view available services running on your cluster. You should see output similar to below.
```bash
Kubernetes master is running at https://130.211.204.57
GLBCDefaultBackend is running at https://130.211.204.57/api/v1/proxy/namespaces/kube-system/services/default-http-backend
Heapster is running at https://130.211.204.57/api/v1/proxy/namespaces/kube-system/services/heapster
KubeDNS is running at https://130.211.204.57/api/v1/proxy/namespaces/kube-system/services/kube-dns
kubernetes-dashboard is running at https://130.211.204.57/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard
```

### Tear it down

To destroy the Google Container cluster that was just created.
```bash
terraform destroy
```

### Google Credentials

Follow these instructions to create a new Service Actor and install the credentials file from Google Compute:

```bash
gcloud iam service-accounts create terraform --display-name “Terraform Container Admin
gcloud iam service-accounts list
gcloud iam service-accounts keys create ~/.config/gcloud/terraform-admin.json
export TF_VARS_gcp_credentials=~/.config/gcloud/terraform-admin.json
```
```bash
GCP_PROJECT=$(gcloud config get-value project) \
gcloud projects add-iam-policy-binding ${GCP_PROJECT} \
  --member serviceAccount:terraform@${GCP_PROJECT}.iam.gserviceaccount.com \
  --role roles/container.admin
```
