output "gwlb_ips" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.gwlb_ips
}

output "secvpc-output" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.secvpc-output
}

output "subnets" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.subnets
}

output "route_tables" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.route_tables
}

output "gwlb_endps" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.gwlb_endps
}

output "user_conf" {
  value = file("${path.module}/fgt_config.conf")
}

output "spkvpc_rt" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.spkvpc_rt
}

output "az_name_map" {
  value = module.spk_gwlb_asg_fgt_gwlb_igw.az_name_map
}