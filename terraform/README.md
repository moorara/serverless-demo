# Terraform

Using this Terraform project, you can deploy a fully functional application with:

  - React client application served on **your domain** with **https**
  - APIs using **serverless** architecture available on **your domain** with **CORS**

## Preparation

In your AWS account, you need the following resources in place:

  - A **Route53 Hosted Zone** for your domain name
  - A **S3 Bucket** with your domain name

Create a file named `terraform.tfvars` in `terraform` directory and set the following variables in it.

```
access_key  = "..."
secret_key  = "..."
domain      = "..."
environment = "..."
region      = "..."
```

## Deployment

Before start deploying, run `yarn install` in the following directories:

  - `serverless-demo`
  - `serverless-demo/client`
  - `serverless-demo/functions`

### Infrastructure

This project creates a **TLS certificate** for enabling https.
It is recommended to deploy this projcet once and preserve it between different deployments.

```bash
cd infrastructure
make init plan
make apply
```

### Scaffold

This project creates a **S3 bucket**, a **CloudFront distribution**, and a **Route53 record** for serving the client application.

```bash
cd scaffold
make init plan
make apply
```

### Serverless

This project uploads the client application to S3 bucket, and deploys the **Lambda functions** alongside required **API Gateway** integrations.

```bash
cd serverless
make init plan
make apply
```

## Destroy

You may want to keep the **infrastructure** resources (**certificate**).
For removing other resources, remove all the objects in the **S3 Bucket** created for client application, and continue as follows:

```bash
cd serverless
make init destroy clean
cd ../scaffold
make init destroy clean
```

You may also need to remove the corresponding **CloudWatch Log Groups** manually since they're not managed by Terraform.
