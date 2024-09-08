output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "acm_cname_records" {
  description = "List of cname record of certificate"
  value       = aws_acm_certificate.this.domain_validation_options

}



