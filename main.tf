locals {
  dkim_verification_records = { for dkim_token in aws_sesv2_email_identity.ses_domain.dkim_signing_attributes[0].tokens :
    "${dkim_token}._domainkey.${var.domain}" => "${dkim_token}.dkim.amazonses.com."
  }
}

resource "aws_sesv2_email_identity" "ses_domain" {
  email_identity         = var.domain
  configuration_set_name = var.configuration_set_name
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = var.verify_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_sesv2_email_identity.ses_domain.dkim_signing_attributes[0].tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${element(aws_sesv2_email_identity.ses_domain.dkim_signing_attributes[0].tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "amazonses_dmarc_record" {
  count = var.configure_dmarc ? 1 : 0

  zone_id = var.zone_id
  name    = "_dmarc.${aws_sesv2_email_identity.ses_domain.email_identity}"
  type    = "TXT"
  ttl     = "3600"
  records = ["v=DMARC1; p=${var.dmarc_action};"]
}

resource "aws_sesv2_email_identity_mail_from_attributes" "custom_mail_from" {
  count = length(var.custom_from_subdomain) > 0 ? 1 : 0

  email_identity         = aws_sesv2_email_identity.ses_domain.email_identity
  behavior_on_mx_failure = var.custom_from_behavior_on_mx_failure
  mail_from_domain       = "${one(var.custom_from_subdomain)}.${aws_sesv2_email_identity.ses_domain.email_identity}"
}

resource "aws_route53_record" "amazonses_spf_record" {
  count = var.create_spf_record ? 1 : 0

  zone_id = var.zone_id
  name    = length(var.custom_from_subdomain) > 0 ? join("", [aws_sesv2_email_identity_mail_from_attributes.custom_mail_from[0].mail_from_domain]) : aws_sesv2_email_identity.ses_domain.email_identity
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:amazonses.com -all"]
}

data "aws_region" "current" {
  count = length(var.custom_from_subdomain) > 0 ? 1 : 0
}

resource "aws_route53_record" "custom_mail_from_mx" {
  count = length(var.custom_from_subdomain) > 0 ? 1 : 0

  zone_id = var.zone_id
  name    = join("", aws_sesv2_email_identity_mail_from_attributes.custom_mail_from[*].mail_from_domain)
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${join("", data.aws_region.current[*].name)}.amazonses.com"]
}
