domain = $(shell awk -F= '/domain/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform.tfvars)
environment = $(shell awk -F= '/environment/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform.tfvars)
region = $(shell awk -F= '/region/ { gsub(/[" ]/, "", $$2); print $$2 }' terraform.tfvars)


clean:
	@ rm -rf .terraform terraform.tfstate terraform.tfstate.backup

terraform.tfvars:
	@ cp ../terraform.tfvars .

init: terraform.tfvars
	terraform init \
	  -backend-config="bucket=$(domain)" \
	  -backend-config="key=$(environment)/terraform/scaffold.tfstate" \
	  -backend-config="region=$(region)"

validate: terraform.tfvars
	terraform validate

plan: terraform.tfvars
	terraform plan

apply: terraform.tfvars
	terraform apply

destroy: terraform.tfvars
	terraform destroy


.PHONY: clean init validate plan apply destroy
