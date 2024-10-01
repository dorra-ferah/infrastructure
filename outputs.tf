output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.oidc_provider.name
}

output "service_account_email" {
  value = google_service_account.sa.email
}
