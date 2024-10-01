provider "google" {
  project = var.project_id
}

resource "google_iam_workload_identity_pool" "pool" {
  provider = google
  workload_identity_pool_id = "orange-pool"
  display_name = "orange-pool"
}

resource "google_iam_workload_identity_pool_provider" "oidc_provider" {
  workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gitlab-tech-orange"  # Define the provider ID
  display_name = "gitlab-tech-orange"

  oidc {
    issuer_uri = "https://gitlab.tech.orange"
  }
}

resource "google_service_account" "sa" {
  account_id   = "986907473259-compute@developer.gserviceaccount.com  "
  display_name = "986907473259-compute@developer.gserviceaccount.com "
}

resource "google_service_account_iam_binding" "wif_sa_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.actor/${var.gitlab_pipeline_id}"
  ]
}
