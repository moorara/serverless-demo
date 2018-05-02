path := $(shell pwd)
report_path := $(path)/coverage


clean:
	@ rm -rf files $(report_path)
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
.PHONY: nsp lint test 
.PHONY: init plan apply destroy
