output "ses_domain_identity_arn" {
  value       = try(aws_sesv2_email_identity.ses_domain.arn, "")
  description = "The ARN of the SES domain identity"
}

output "ses_dkim_tokens" {
  value       = try(local.dkim_verification_records, "")
  description = "A list of DKIM validation records which, when added to the DNS Domain as CNAME records, allows for receivers to verify that emails were indeed authorized by the domain owner."
}

output "spf_record" {
  value       = try(aws_route53_record.amazonses_spf_record[0].fqdn, "")
  description = "The SPF record for the domain. This is a TXT record that should be added to the domain's DNS settings to allow SES to send emails on behalf of the domain."
}

output "custom_from_domain" {
  value       = try(join("", aws_sesv2_email_identity_mail_from_attributes.custom_mail_from[*].mail_from_domain))
  description = "The custom mail FROM domain"
}

output "dmarc" {
  value = aws_sesv2_email_identity.ses_domain.email_identity
}
