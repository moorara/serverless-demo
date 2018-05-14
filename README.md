[![Build Status][circleci-image]][circleci-url]

# Serverless
This is a simple web application and API server built using serverless architecture.

## Prerequisites
In your local development environment, you need the following tools available in your path:

  * Yarn (`yarn`)
  * AWS CLI (`aws`)

In your AWS account, you need the following resources in place:

  * A **Route53 Hosted Zone** for your domain name
  * A **S3 Bucket** with your domain name

## Deployment
In `terraform` directory, create a file named `terraform.tfvars` and set the following variables in it.

```toml
access_key   =  "..."
secret_key   =  "..."
domain       =  "..."
environment  =  "..."
region       =  "..."
```

You can then run the following commands for deploying the serverless application:

```bash
make init   # Initializes Terraform project
make plan   # Generates an execution plan for Terraform
make apply  # Creates/Updates infrastructure using Terraform
```


[circleci-url]: https://circleci.com/gh/moorara/serverless-demo/tree/master
[circleci-image]: https://circleci.com/gh/moorara/serverless-demo/tree/master.svg?style=shield
