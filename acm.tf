resource "tls_private_key" "quadzig" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "quadzig-ssl" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.quadzig.private_key_pem

  subject {
    common_name  = "quadzig.dev.internal"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

#Import newly created SSL to ACM.
resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.quadzig.private_key_pem
  certificate_body = tls_self_signed_cert.quadzig-ssl.cert_pem
}

#If we'd rather just import the existing cert
#import {
#  to = aws_acm_certificate.cert
#  id = "arn:aws:acm:eu-central-1:123456789012:certificate/7e7a28d2-163f-4b8f-b9cd-822f96c08d6a"
#}
