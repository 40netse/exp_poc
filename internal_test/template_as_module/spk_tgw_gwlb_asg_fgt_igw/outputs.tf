output "gwlb_ips" {
  value = module.spk_tgw_gwlb_asg_fgt_igw.gwlb_ips
}

output "secvpc-output" {
  value = module.spk_tgw_gwlb_asg_fgt_igw.secvpc-output
}

output "subnets" {
  value = module.spk_tgw_gwlb_asg_fgt_igw.subnets
}

output "route_tables" {
  value = module.spk_tgw_gwlb_asg_fgt_igw.route_tables
}

output "user_conf" {
  value = file("${path.module}/fgt_config.conf")
}

output "az_name_map" {
  value = module.spk_tgw_gwlb_asg_fgt_igw.az_name_map
}