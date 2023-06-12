# this needs to be available for usage with the provider 'organization' property
# but it is (as created manually), but we keep it in tf to manage changes here
resource "tfe_organization" "this" {
  name                          = "cooperative"
  email                         = "elmar@athmer.org"
  collaborator_auth_policy      = "two_factor_mandatory"
  allow_force_delete_workspaces = true
}