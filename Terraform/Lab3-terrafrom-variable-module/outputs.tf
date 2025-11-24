output "vm_public_ip" {
  value = module.vm.public_ip
}

# terraform output -raw ansible_inventory >> hosts
output "ansible_inventory" {
  value = <<EOF
[webservers]
%{ for ip in module.vm.public_ip ~}
${ip}
%{ endfor ~}
EOF
}
