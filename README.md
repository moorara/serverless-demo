[![Build Status][circleci-image]][circleci-url]

# Serverless
This is a simple web application and API server built using serverless architecture.

## Deployment
In `terraform` directory, create a file named `terraform.tfvars` and set the following variables in it.

```toml
access_key = "..."
secret_key = "..."
region     = "..."
```

You can then run the following commands for deploying the serverless application:

```bash
make init   # Initializes Terraform project
make plan   # Generates an execution plan for Terraform
make apply  # Creates/Updates infrastructure using Terraform
```


[circleci-url]: https://circleci.com/gh/moorara/serverless-demo/tree/master
[circleci-image]: https://circleci.com/gh/moorara/serverless-demo/tree/master.svg?style=shield
