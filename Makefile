clean:
	@ rm -rf packages
	@ rm -rf client/build
	@ rm -rf client/coverage
	@ rm -rf functions/coverage
	@ rm -rf terraform/.terraform terraform/terraform.tfstate*


nsp:
	@ cd functions && \
	  yarn run nsp

lint:
	@ cd functions && \
	  yarn run lint

test:
	@ cd functions && \
	  yarn run test

test-client:
	@ cd client && \
	  yarn run test -- --coverage


init:
	@ cd terraform && \
	  terraform init

plan:
	@ cd terraform && \
	  terraform plan

apply:
	@ cd terraform && \
	  terraform apply

destroy:
	@ cd terraform && \
	  terraform destroy


.PHONY: clean
.PHONY: nsp lint test test-client
.PHONY: init plan apply destroy
