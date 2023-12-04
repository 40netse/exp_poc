## Build 0008
Improvements:
On template spk_tgw_gwlb_asg_fgt_igw:
    Improvements:
    * Support using given CIDR block to generate subnets; (Variable 'subnet_cidr_block')
    * Support not generate subnet for GWLB or TGW if they are marked as ignore. (Ignore it means setting variable 'existing_gwlb' or 'existing_tgw' to empty map);
    * Support using existing subnets; (Variable 'existing_subnets');
    * Change default instance type of FGT instance to 'c5n.xlarge';
    * Support using existing GWLB;
    * Fix validation check error of variable 'security_vpc_tgw_attachments';

    Changes:
    * Add variable of 'existing_subnets';
    * Add variable of 'gwlb_ep_service_name';
    * Add variable of 'existing_gwlb';
    * Add variable of 'existing_gwlb_tgp';
    * Add variable of 'existing_gwlb_ep_service';

On module aws/gwlb:
    Improvements:
    * Support using existing GWLB, GWLB Target Group, VPC Endpoint Service;

    Changes:
    * Add variable of 'existing_gwlb';
    * Add variable of 'existing_gwlb_tgp';
    * Add variable of 'existing_gwlb_ep_service';

On module aws/vpc:
    Changes:
    * Change output of 'subnets' map value from subnet_id to map with keys 'id' and 'availability_zone';
    * Change output of 'igw' from IGW ID to IGW resource output;

On internal_test of template_as_module/spk_tgw_gwlb_asg_fgt_igw/main_existing_vpc.tf.txt:
    Changes:
    * Change example of variable 'subnets' to 'existing_subnets';


## Build 0007
Improvements:
On template spk_tgw_gwlb_asg_fgt_igw:
    * Support using existing IGW, TGW, VPC;
    * Support ignore TGW and related route tables;
    * Add some validation check functionalities;
    * Support using ENV variables for AWS credentials;

    Changes:
    * Add variable of 'existing_igw';
    * Add variable of 'subnet_cidr_block';

On module aws/vpc:
    Improvements:
    * Support using existing IGW;

    Changes:
    * Add variable of 'existing_igw';

## Build 0006
Improvements:
* Updated the user_conf example;
* Included all rfc1918 spaces on .conf file;
* Add name 'tgw_rt_spokevpc' for Spoke VPC TGW route table;
* Add name for FortiGate instances as the ASG name;
* Support using existing TGW by adding variable 'existing_tgw' on templates;

Changes:
* Change variable 'user_conf' to 'user_conf_content';
* Geneve tunnel name changed from the AZ name to format of geneve-az\<az number\>;

## Build 0005
Improvements:
* Fix lumbda function issue on build 0004

## Build 0004
Improvements:
* Encode password on HTTP request; 
* Set appliance_mode_support default to enable;
* Fix TGWa plan issue; 
* Support ease-west traffic by adding another TGW RT, add variable enable_east_west_inspection;
* Support using private link when communicating with FortiGate instance; 
* Support 1-arm and 2-arm FortiGate interface design by adding variable fgt_intf_mode; 
* Apply general_tags to all resources;
* Support variable user_conf_file_path; 
* Add tag 'Autoscale Role' for FortiGate instance to show its autoscale role;

Changes:
* Update example .tfvars file to remind user must-check variables;
* FortiGate configuration example change to using route policies;

## Build 0003
Improvements:
* Support FortiFlex on FortiGate ASG;
* Add option 'fgt_hostname' into variable 'asgs' on all templates;

## Build 0002
Improvements:
* Support FGT configuration file from S3 by adding variable 'user_conf_s3';
* Support hybrid license FortiGate ASG for all templates;
* Improve .tftpl file to ignore the command line if not configured;
* Update deprecated variable 'vpc' to 'domain' of resource aws_eip;

Changes:
* Delete all Auto Scale Group related variables and combine them into one variable 'asgs' for all templates. So that user could define multiple ASGs;
* Delete template 'spk_tgw_gwlb_hybrid_asg_fgt_igw' since template 'spk_tgw_gwlb_asg_fgt_igw' already covered it;
* Change option type 'alarm_asg_policies' of variable 'cloudwatch_alarms' from list to map for all templates. So that user has more flexibility to configure the auto-scale policies;
* Add new variable 'create_dynamodb_table' for module fgt_asg to determine whether to create the DynamoDB by the module;
