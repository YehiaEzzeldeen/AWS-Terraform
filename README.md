# AWS-Terraform
Terraform templates to deploy resources on AWS
Contents:<br />
1- A Variable file Containing the Whole VPC variables needed to create a Dynamic VPC.<br />
2- A Network file responsible for taking the variables from the variables file and creating a complete VPC.<br />
3- Security Groups file to create the security Groups and their rules that are stated in the variables file.<br />
4- KeyPairs file to create the KeyPairs in AWS and then generates the .pem files for the keys generated. Keys are generated according to a list variable in the variables file.
5- Site to site VPN script.
6- Cloud Trail script to create a trail following AWS best practices.
7- Backup Plans script to create Daily, Weekly or Monthly Backup plans to create automated backups. Resource assignment is done through tags.
