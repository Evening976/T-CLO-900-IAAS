output "hosts" {
  value = {
    bastion = length(module.bastion.public_ips) > 0 ? module.bastion.public_ips[0] : null
    masters = flatten([for m in module.vm_master : m.private_ips])
    workers = flatten([for w in module.vm_worker : w.private_ips])
    gitlab  = length(module.vm_gitlab.private_ips) > 0 ? module.vm_gitlab.private_ips[0] : null
  }
}
