
terraform {
  required_version = ">= 1.0"
}

resource "terraform_data" "kind_cluster" {
  triggers_replace = [
    filesha256("${path.module}/kind-config.yaml")
  ]

  provisioner "local-exec" {
    command = "kind create cluster --name sock-shop --config ${path.module}/kind-config.yaml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kind delete cluster --name sock-shop"
  }
}
