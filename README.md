[![Build Status][circleci-image]][circleci-url]

# Serverless
This is a simple web application and API server built using serverless architecture.

## Prerequisites
In your local development environment, you need the following tools available in your path:

  * [Yarn](https://yarnpkg.com) (`yarn`)
  * [AWS CLI](https://aws.amazon.com/cli) (`aws`)
  * [Terraform](https://www.terraform.io) (`terraform`)
  * [Serverless Framework](https://serverless.com) (`serverless`)

In your AWS account, you need the following resources in place:

  * A **Route53 Hosted Zone** for your domain name
  * A **S3 Bucket** with your domain name

## Deployment

### Terraform
In `terraform` directory, create a file named `terraform.tfvars` and set the following variables in it.

```toml
access_key   =  "..."
secret_key   =  "..."
domain       =  "..."
environment  =  "..."
region       =  "..."
```

#### Infrastructure

```bash
cd terraform/infrastructure
make init plan
make apply
```

#### Scaffold

```bash
cd terraform/scaffold
make init plan
make apply
```

#### Serverless

```bash
cd terraform/serverless
make init plan
make apply
```

### Serverless Framework

#### Options

| Option        | Default | Description                 |
|---------------|---------|-----------------------------|
| `profile`     |         | aws cli profile to use      |
| `environment` |         | deployment environment name |
| `region`      |         | deployment region           |
| `stage`       |         | api gateway stage name      |

#### Commands:

```bash
serverless deploy --environment dev --region us-east-1
serverless client deploy --environment dev --region us-east-1
```


[circleci-url]: https://circleci.com/gh/moorara/serverless-demo/tree/master
[circleci-image]: https://circleci.com/gh/moorara/serverless-demo/tree/master.svg?style=shield
