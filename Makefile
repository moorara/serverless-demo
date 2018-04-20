path := $(shell pwd)
report_path := $(path)/coverage


clean:
	@ rm -rf files $(report_path)
	@ rm -rf terraform/.terraform terraform/terraform.tfstate*

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
.PHONY: init plan apply destroy
