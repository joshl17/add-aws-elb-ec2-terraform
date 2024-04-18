# Cognito
resource "aws_cognito_user_pool" "main" {
  name = "quazdig-dev"

  # ATTRIBUTES
  alias_attributes = ["email", "preferred_username"]

  #remove for prod, auto verification should only be for Dev
  auto_verified_attributes = ["email"]

  # Require each user to supply a name
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "name"
    required            = true
  }

  # Require each user to supply an email
  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }

  # POLICY
  password_policy {
    minimum_length    = "8"
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # MFA & VERIFICATIONS
  mfa_configuration        = "OFF"

  # DEVICES
  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
    name = "client"
    user_pool_id = aws_cognito_user_pool.main.id
    generate_secret = true
    explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
    supported_identity_providers = ["COGNITO"]
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows = ["code"]
    allowed_oauth_scopes = ["email", "openid", "profile"]
    #not sure exactly which one of these worked, havent had a chance to verify individually
    callback_urls = ["http://localhost/auth/sign_in",
                     "https://localhost/auth/sign_in",
                     "http://localhost/auth/sign_in/",
                     "https://localhost/auth/sign_in/",
    ]
    #logout process not yet tested
    logout_urls = ["http://localhost"]
 }

  resource "aws_cognito_user_pool_domain" "main" {
    domain       = "quadzig-pool"
    user_pool_id = aws_cognito_user_pool.main.id
  }

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "quadzig-id-pool-dev"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = aws_cognito_user_pool.main.endpoint
    server_side_token_check = true
  }
 }


