# Terraform module template

This is a template for terraform modules. It contains the required CI configuration and `.gitignore`.

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
By default the root of the respository is scanned but if you have a repo with submodules (like for e.g. [makandra/terraform-aws-modules](https://github.com/makandra/terraform-aws-modules) you should add every submodule to the workflow matrix.

# Recommended Repo configuration

We recommend protecting the `main` branch and to allow new code pushes only via Pull Requests. This way it's ensured that all tests pass before a new release is pushed.
