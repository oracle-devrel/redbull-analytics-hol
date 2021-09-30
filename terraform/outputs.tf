# Copyright (c) 2021 Oracle and/or its affiliates.

output "instance_pub_ip" {
  value = oci_core_instance.redbull_lab1.public_ip
}

output "jupyter_url" {
  value = "https://${oci_core_instance.redbull_lab1.public_ip}:8888"
}

output "get_jupyter_token" {
  value = "ssh -i PATH_TO_YOUR_SSH_PRIV_KEY_HERE opc@${oci_core_instance.redbull_lab1.public_ip} 'source redbullenv/bin/activate; jupyter server list'"
}
