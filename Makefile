domain := $(shell awk -F= '/domain/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform/terraform.tfvars)
environment := $(shell awk -F= '/environment/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform/terraform.tfvars)
region := $(shell awk -F= '/region/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform/terraform.tfvars)


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
	  terraform init \
	    -backend-config="bucket=$(domain)" \
	    -backend-config="key=$(environment)/terraform.tfstate" \
	    -backend-config="region=$(region)"

validate:
	cd terraform && \
	terraform validate

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
.PHONY: init validate plan apply destroy
