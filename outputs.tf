output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.ci_cd_provider.name
}

output "service_account_email" {
  value = google_service_account.ci_cd_service_account.email
}