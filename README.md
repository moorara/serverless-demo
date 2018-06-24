[![Build Status][circleci-image]][circleci-url]

# Serverless
This is a simple web application and API server built using serverless architecture.

## Prerequisites
In your local development environment, you need the following tools available in your path:

  * [Yarn](https://yarnpkg.com) (`yarn`)
  * [AWS CLI](https://aws.amazon.com/cli) (`aws`)
  * [Terraform](https://www.terraform.io) (`terraform`)
  * [Serverless Framework](https://serverless.com) (`serverless`)

## Terraform
You can deploy a fully functional web application with serverless APIs and distributed using [CloudFront](https://aws.amazon.com/cloudfront).

## Serverless Framework
You can deploy the serverless APIs and client application using [Serverless](https://serverless.com) framework.

### Options

| Option        | Default   | Description       |
|---------------|-----------|-------------------|
| `profile`     |           | aws cli profile   |
| `environment` | dev       | environment name  |
| `region`      | us-east-1 | deployment region |

### Commands:
You can deploy the resources as follows:

```bash
yarn run client
serverless deploy --environment <name> --region <region>
serverless client deploy --environment <name> --region <region>
```

You can also remove the resources as follows:

```bash
serverless remove --environment <name> --region <region>
serverless client remove --environment <name> --region <region>
```


[circleci-url]: https://circleci.com/gh/moorara/serverless-demo/tree/master
[circleci-image]: https://circleci.com/gh/moorara/serverless-demo/tree/master.svg?style=shield
