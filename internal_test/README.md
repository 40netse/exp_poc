There are 4 templates in the folder 'templates'. The template name is based on the traffic path from user's pc on spoke VPC to internet. For instance, spk_tgw_gwlb_asg_fgt_gwlb_igw means traffic path will be Spoke_VPC --> Transic Gateway --> Gateway Load Balancer --> FortiGate instance of Auto-scaling Group --> Internet Gateway.

Pre-requirement:
    Terraform: >= 1.3

There are two ways to use the template.
    1. Copy template:
        Directly copy the folder or files to the test location. In this way, user could have more flexibility to modify the template.
        Note:
            Check the argument 'source' in each module to make sure it can find the target module. We will use absolute path after release, then this will not an issue.
        Steps:
            You can ignore step a-d if you directly use draft folder under 'test/copy_template' folder.

            a. Create a folder for the test. 
            b. Copy all files under templates/<TEMPLATE NAME> to the new folder.
            c. Check the argument 'source' in each module of file main.tf.
            d. Change the name of file terraform.tfvars.txt to terraform.tfvars. 

            e. Modify and check the arguments in file terraform.tfvars.
            f. Run 'terraform init' to initiate it.
            g. Run 'terraform plan' to check whether the output is expected.
            h. Run 'terraform apply' to apply it. It may take several minuties to complete it.
        Example:
            test/copy_template/<TEMPLATE NAME>

    2. Use template as module:
        Using the template as a module. In this way, user just needs to care about the configurations.
        Note:
            Check the argument 'source' in the module to make sure it can find the target module. We will use absolute path after release, then this will not an issue.
        Steps:
            You can ignore step a-b if you directly use draft folder under 'test/template_as_module' folder.
            a. Create a folder for the test.
            b. Create a .tf file with the configurations inside the module block. You could directly copy the file content of file terraform.tfvars to the module block.

            c. Modify and check the arguments.
            c. Run 'terraform init' to initiate it.
            d. Run 'terraform plan' to check whether the output is expected.
            e. Run 'terraform apply' to apply it. It may take several minuties to complete it.
        Example:
            test/template_as_module/<TEMPLATE NAME>

Note for the configuration:

    1. For the CIDR block of the VPC, currently we do not support a netmask larger than 24 for the auto-generate subnets. If the netmask of the CIDR block is larger than 24, please manually provide the argument 'subnets' to identify subnet information for each subnet. 
    2. The key pair should be created by user manually.
    3. FortiGate instance password is required due to the lambda function. The module will change the password to the value been given.
    4. License is required when the argument 'license_type' is set to 'byol'. Otherwise, user need manually to check instance launching status and upload the license manually. Also, the module could not configure the FortiGate settings without a license. There are two ways to provide licenses. Please see 'License' section below.
    5. The module will do basic interface configuration for the FortiGate instance based on the interface settings. For other configurations, like firewall policy and routers, users need to provide the configuration in CLI format by argument 'user_conf'.

License:
    We provide two ways for the license. One is using license files, and another is using FortiFlex.

    a. License file
        The lambda function will auto-apply the available license file to the launched FortiGate instance. And also the function will track the license files. The license file will go back to the available list and ready to use for next FortiGate instance when a FortiGate instance terminated.
        1. Variable 'lic_folder_path'
        Provide the folder path of local directory. The template will create an S3 bucket and upload license files in this directory to the S3 bucket. 
        2. Variable 'lic_s3_name'
        Provide the S3 bucket name that contains license files.
    b. FortiFlex
        The user need provide an refresh token of FortiCloud account (Variable fortiflex_refresh_token). How to get a refresh token: https://fndn.fortinet.net/index.php?/fortiapi/954-fortiflex/956/ and https://docs.fortinet.com/document/fortiauthenticator/latest/rest-api-solution-guide/498666/oauth-server-token-oauth-token. Note: We need the refresh_token, not access_token.
        Also, the user need to provide one or more of following variables:
        1. Variable 'fortiflex_sn_list'
        Provide a list of valid Serial numbers from the FortiFlex account. The lambda function will generate the vm token and apply to the new launched FortiGate instanc automatically. And also the function will track the serial numbers. The serial number will go back to the available list and ready to use for the next FortiGate instance when a FortiGate instance terminated. 
        2. Variable 'Fortiflex_configid_list'
        Provide a list of config IDs from the FortiFlex account. The lambda function will get all valid serial numbers of the given config IDs. The function will refresh the serial numbers on each event (launch or terminate instance).