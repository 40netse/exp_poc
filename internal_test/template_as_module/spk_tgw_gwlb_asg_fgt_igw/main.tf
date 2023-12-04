module "spk_tgw_gwlb_asg_fgt_igw" {
  source = "../../../templates/spk_tgw_gwlb_asg_fgt_igw"

  ## Note: Please go through all arguments in this file and replace the content with your configuration! This file is just an example.
  ## "<YOUR-OWN-VALUE>" are parameters that you need to specify your own value.

  ## Root config
  region     = "us-west-2" # e.g. "us-east-2"

  #vpc_cidr_block     = "10.0.0.0/24" # e.g. "10.0.0.0/16"
  spoke_cidr_list    = []
  availability_zones = ["us-west-2a", "us-west-2c"] # e.g. ["us-east-2a", "us-east-2b"]

  existing_security_vpc = {
      id = "vpc-01c272d7eac47ff22"
  }
  existing_igw = {
      id = "igw-052b296a5f8ea054c"
  }
  existing_tgw = {
      # id = ""
  }
  existing_subnets = {
     fgt_login_us-west-2a = {
         id = "subnet-0a8e5f1ba766fda0c"
         availability_zone = "us-west-2a"
     },
     fgt_internal_us-west-2a = {
         id = "subnet-0ca861dbc2610c22a"
         availability_zone = "us-west-2a"
     },
     gwlbe_us-west-2a = {
         id = "subnet-0be5921f2d4f82851"
         availability_zone = "us-west-2a"
     },
     fgt_login_us-west-2c = {
         id = "subnet-01ab1c6cb24a7c1d1"
         availability_zone = "us-west-2c"
     },
     fgt_internal_us-west-2c = {
         id = "subnet-02dbf28573951739a"
         availability_zone = "us-west-2c"
     },
     gwlbe_us-west-2c = {
         id = "subnet-08db9eebbd5255daf"
         availability_zone = "us-west-2c"
     }
  }
  ## VPC
  security_groups = {
    secgrp1 = {
      description = "Security group by Terraform"
      ingress = {
        all_traffic = {
          from_port   = "0"
          to_port     = "0"
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      egress = {
        all_traffic = {
          from_port   = "0"
          to_port     = "0"
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  ## Transit Gateway
  tgw_name        = "tgw-test"
  tgw_description = "This is a test for Terraform test"

  ## Auto scale group
  # This example is a hybird license ASG
  fgt_intf_mode = "2-arm"
  asgs = {
    fgt_byol_asg = {
      template_name   = "fgt_asg_template"
      fgt_version     = "7.2.6"
      instance_type   = "c5n.xlarge"
      license_type    = "byol"
      fgt_password = "" # e.g. "fortinet"
      keypair_name = "" # Keypair should be created manually
      lic_folder_path = "./license"
      # fortiflex_refresh_token = "<YOUR-OWN-VALUE>" # e.g. "NasmPa0CXpd56n6TzJjGqpqZm9Thyw"
      # fortiflex_sn_list = "<YOUR-OWN-VALUE>" # e.g. ["FGVMMLTM00000001", "FGVMMLTM00000002"]
      # fortiflex_configid_list = "<YOUR-OWN-VALUE>" # e.g. [2343]
      enable_fgt_system_autoscale = true
      intf_security_group = {
        login_port    = "secgrp1"
        internal_port = "secgrp1"
      }
      user_conf_file_path = "./fgt_config.conf" # e.g. "./fgt_config.conf"
      # There are 3 options for providing user_conf data: 
      # user_conf_content : FortiGate Configuration
      # user_conf_file_path : The file path of configuration file
      # user_conf_s3 : Map of AWS S3 

      asg_max_size = 1
      asg_min_size = 1
      asg_desired_capacity = 1
      create_dynamodb_table = true
      dynamodb_table_name   = "fgt_asg_track_table"
    },
    fgt_on_demand_asg = {
      template_name               = "fgt_asg_template_on_demand"
      fgt_version                 = "7.2.6"
      instance_type               = "c5n.xlarge"
      license_type                = "on_demand"
      fgt_password = "" # e.g. "fortinet"
      keypair_name = "" # Keypair should be created manually
      enable_fgt_system_autoscale = true
      intf_security_group = {
        login_port    = "secgrp1"
        internal_port = "secgrp1"
      }
      user_conf_file_path = "./fgt_config.conf" # e.g. "./fgt_config.conf"
      # There are 3 options for providing user_conf data: 
      # user_conf_content : FortiGate Configuration
      # user_conf_file_path : The file path of configuration file
      # user_conf_s3 : Map of AWS S3 
      asg_max_size = 2
      asg_min_size = 0
      asg_desired_capacity = 0
      dynamodb_table_name = "fgt_asg_track_table"
      scale_policies = {
        byol_cpu_above_80 = {
          policy_type        = "SimpleScaling"
          adjustment_type    = "ChangeInCapacity"
          cooldown           = 60
          scaling_adjustment = 1
        },
        byol_cpu_below_30 = {
          policy_type        = "SimpleScaling"
          adjustment_type    = "ChangeInCapacity"
          cooldown           = 60
          scaling_adjustment = -1
        },
        ondemand_cpu_above_80 = {
          policy_type        = "SimpleScaling"
          adjustment_type    = "ChangeInCapacity"
          cooldown           = 60
          scaling_adjustment = 1
        },
        ondemand_cpu_below_30 = {
          policy_type        = "SimpleScaling"
          adjustment_type    = "ChangeInCapacity"
          cooldown           = 60
          scaling_adjustment = -1
        }
      }
    }
  }

  ## Cloudwatch Alarm
  cloudwatch_alarms = {
    byol_cpu_above_80 = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 120
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        AutoScalingGroupName = "fgt_byol_asg"
      }
      alarm_description   = "This metric monitors average ec2 cpu utilization of Auto Scale group fgt_asg_byol."
      datapoints_to_alarm = 1
      alarm_asg_policies = {
        policy_name_map = {
          "fgt_on_demand_asg" = ["byol_cpu_above_80"]
        }
      }
    },
    byol_cpu_below_30 = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 120
      statistic           = "Average"
      threshold           = 30
      dimensions = {
        AutoScalingGroupName = "fgt_byol_asg"
      }
      alarm_description   = "This metric monitors average ec2 cpu utilization of Auto Scale group fgt_asg_byol."
      datapoints_to_alarm = 1
      alarm_asg_policies = {
        policy_name_map = {
          "fgt_on_demand_asg" = ["byol_cpu_below_30"]
        }
      }
    },
    ondemand_cpu_above_80 = {
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 120
      statistic           = "Average"
      threshold           = 80
      dimensions = {
        AutoScalingGroupName = "fgt_on_demand_asg"
      }
      alarm_description = "This metric monitors average ec2 cpu utilization of Auto Scale group fgt_asg_ondemand."
      alarm_asg_policies = {
        policy_name_map = {
          "fgt_on_demand_asg" = ["ondemand_cpu_above_80"]
        }
      }
    },
    ondemand_cpu_below_30 = {
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 120
      statistic           = "Average"
      threshold           = 30
      dimensions = {
        AutoScalingGroupName = "fgt_on_demand_asg"
      }
      alarm_description = "This metric monitors average ec2 cpu utilization of Auto Scale group fgt_asg_ondemand."
      alarm_asg_policies = {
        policy_name_map = {
          "fgt_on_demand_asg" = ["ondemand_cpu_below_30"]
        }
      }
    }
  }

  ## Gateway Load Balancer
  enable_cross_zone_load_balancing = true

  ## Spoke VPC
  enable_east_west_inspection = true
  # "<YOUR-OWN-VALUE>" # e.g. 
  # spk_vpc = {
  #   # This is optional. The module will create Transit Gateway Attachment under each subnet in argument 'subnet_ids', and also create route table to let all traffic (0.0.0.0/0) forward to the TGW attachment with the subnets associated.
  #   "spk_vpc1" = {
  #     vpc_id = "vpc-123456789",
  #     subnet_ids = [
  #       "subnet-123456789",
  #       "subnet-123456789"
  #     ]
  #   }
  # }

  ## Tag
  general_tags = {
    "purpose" = "ASG_TEST"
  }

}

