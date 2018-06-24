[![Build Status][circleci-image]][circleci-url]

# Serverless
This is a simple web application and API server built using serverless architecture.

## Prerequisites
In your local development environment, you need the following tools available in your path:

  * [Yarn](https://yarnpkg.com) (`yarn`)
  * [AWS CLI](https://aws.amazon.com/cli) (`aws`)
  * [Terraform](https://www.terraform.io) (`terraform`)
  * [Serverless Framework](https://serverless.com) (`serverless`)

## Deployment

### Terraform
You can deploy a fully functional web application with serverless APIs and distributed using [CloudFront](https://aws.amazon.com/cloudfront).

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
