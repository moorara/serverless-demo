module "func_message" {
  source = "./function"

  name        = "message"
  environment = "${var.environment}"
  region      = "${var.region}"
}
