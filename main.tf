provider "google" {
  project     = var.DEVSHELL_PROJECT_ID
  credentials = file("C:/Users/dferah/Downloads/sbx-31371-8wo59d45lox6o935c5nc-afafdee7a544.json") # Remplacez par le chemin de votre clé
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

  attribute_mappings = {
    "google.subject" = "assertion.projet_id"  # Maps the 'sub' claim from the OIDC token to the Google 'subject'
    "attribute.project_path" = "assertion.project_path"  # Map GitLab's repository claim
  }

}


resource "google_service_account" "sa" {
  account_id   = "sa986907473259"  # Utilisez un nom valide
  display_name = "sa986907473259"
}

resource "google_service_account_iam_binding" "wif_sa_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.actor/${var.gitlab_pipeline_id}"
  ]
}
