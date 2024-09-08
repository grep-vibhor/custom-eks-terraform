locals {
  tags = merge({
    Environment = var.env_name
  }, { for k, v in var.tags : k => v if k != "Name" })

  # Get distinct list of domains and SANs
  distinct_domain_names = distinct(
    [for s in concat([var.domain_name], var.subject_alternative_names) : replace(s, "*.", "")]
  )
}

resource "aws_acm_certificate" "this" {

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  ##About Certificate transparency
  ## Certificate Transparency logging guards against SSL/TLS certificates issued by mistake or by a compromised certificate authority. Most modern browsers require that public certificates issued for your domain be recorded in a certificate transparency log.
  ##some browsers require that public certificates issued for your domain be recorded in a certificate transparency log.

  options {
    certificate_transparency_logging_preference = var.certificate_transparency_logging_preference ? "ENABLED" : "DISABLED"
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
