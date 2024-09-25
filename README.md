# Terraform AWS SES module

This module creates a SES Identity.  
It also supports further configuration like the usage of a configuration set for the identity, or adding a custom FROM domain.
Optionally it creates validation records for SPF, DKIM and DMARC in a given Route 53 Zone.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.37.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.amazonses_dkim_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.amazonses_dmarc_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.amazonses_spf_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.custom_mail_from_mx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_sesv2_email_identity.ses_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity) | resource |
| [aws_sesv2_email_identity_mail_from_attributes.custom_mail_from](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_mail_from_attributes) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_set_name"></a> [configuration\_set\_name](#input\_configuration\_set\_name) | Name of the configuration set to use for the identity | `string` | `null` | no |
| <a name="input_configure_dmarc"></a> [configure\_dmarc](#input\_configure\_dmarc) | n/a | `bool` | `false` | no |
| <a name="input_create_spf_record"></a> [create\_spf\_record](#input\_create\_spf\_record) | If provided the module will create an Route53 SPF record for 'domain'. | `bool` | `false` | no |
| <a name="input_custom_from_behavior_on_mx_failure"></a> [custom\_from\_behavior\_on\_mx\_failure](#input\_custom\_from\_behavior\_on\_mx\_failure) | The behaviour of the custom\_from\_subdomain when the MX record is not found. Defaults to `UseDefaultValue`. | `string` | `"USE_DEFAULT_VALUE"` | no |
| <a name="input_custom_from_subdomain"></a> [custom\_from\_subdomain](#input\_custom\_from\_subdomain) | If provided the module will create a custom subdomain for the 'From' address. | `list(string)` | `[]` | no |
| <a name="input_dmarc_action"></a> [dmarc\_action](#input\_dmarc\_action) | n/a | `string` | `"none"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain or email address to create the SES identity for. | `string` | n/a | yes |
| <a name="input_verify_dkim"></a> [verify\_dkim](#input\_verify\_dkim) | If provided the module will create Route53 DNS records used for DKIM verification. | `bool` | `false` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 parent zone ID. This is required if you want to create validation records in Route53 | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_from_domain"></a> [custom\_from\_domain](#output\_custom\_from\_domain) | The custom mail FROM domain |
| <a name="output_dmarc"></a> [dmarc](#output\_dmarc) | n/a |
| <a name="output_ses_dkim_tokens"></a> [ses\_dkim\_tokens](#output\_ses\_dkim\_tokens) | A list of DKIM validation records which, when added to the DNS Domain as CNAME records, allows for receivers to verify that emails were indeed authorized by the domain owner. |
| <a name="output_ses_domain_identity_arn"></a> [ses\_domain\_identity\_arn](#output\_ses\_domain\_identity\_arn) | The ARN of the SES domain identity |
| <a name="output_spf_record"></a> [spf\_record](#output\_spf\_record) | The SPF record for the domain. This is a TXT record that should be added to the domain's DNS settings to allow SES to send emails on behalf of the domain. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Contents

## package.json

The `package.json` is required for the [semantic-release](https://semantic-release.gitbook.io/semantic-release/). This is controlled via a Github Actions workflow.

## pre-commit-config.yaml

We rely on [pre-commit](https://pre-commit.com/) hooks to ensure the good code quality. This is also checked by a CI pipeline but recommended to use locally. It's also responsible for creating [terraform-docs](https://terraform-docs.io/).

## .github/workflows

We have several default workflows prepared.

### checkov

[checkov](https://www.checkov.io/) scans the terraform manifests for common misconfigurations. By default the root of the repository is scanned but if you have a repo with submodules (like for e.g. [makandra/terraform-aws-modules](https://github.com/makandra/terraform-aws-modules) you may want to alter the path of the GitHub action.

### conventional-commits

We want to enforce [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) to ensure our `semantic-release` works correctly.

### precommit

We want to ensure that all our rules in the `pre-commit` configuration are applied.

### semantic-release

Whenever new commits are merged into the `main` branch we want a new release to be created.

### tflint

Terraform linter for finding possible errors, old syntax, unused declarations etc. Also it enforces best practices. See [tflint](https://github.com/terraform-linters/tflint).
By default the root of the respository is scanned but if you have a repo with submodules (like e.g. [makandra/terraform-aws-modules](https://github.com/makandra/terraform-aws-modules)) you should add every submodule to the workflow matrix.

# Recommended Repo configuration

We recommend protecting the `main` branch and to allow new code pushes only via Pull Requests. This way it's ensured that all tests pass before a new release is pushed.
