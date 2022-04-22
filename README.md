# SRE_Challenge
Comcast

# This repo contains infrastructure code for a basic web server hosted on AWS and a PowerShell script to solve this problem: https://www.hackerrank.com/challenges/validating-credit-card-number/problem

# Requirements
    Terraform
    AWS CLI
    PowerShell

# Instructions and commands. Can be copied and pasted directly
# Configure your AWS credentials and use your access keys to allow Terraform to use AWS account resouces
    aws configure 

# Initialize and run Terraform code
    terraform init
    terraform apply

# The output should look like this:
    web_instance_dns = "ec2-3-91-155-8.compute-1.amazonaws.com"
    web_instance_ip = "3.91.155.8"

# You should be able to use the public IP or Public DNS to browse to the site

# Redirecting to HTTPS
    The virtualhost can be configured to redirect HTTPS traffic in the conf.d with the correct directives. Similar to the example below:

```
<VirtualHost *:443>
  ServerName ec2-3-91-155-8.compute-1.amazonaws.com
  ServerAlias www.ec2-3-91-155-8.compute-1.amazonaws.com

  Protocols h2 http/1.1

  <If "%{HTTP_HOST} == 'www.ec2-3-91-155-8.compute-1.amazonaws.com'">
    Redirect permanent / https://ec2-3-91-155-8.compute-1.amazonaws.com/
  </If>

  # SSL settings

  # Website Settings


</VirtualHost>
```

# SSL Certificate management and deployment can be configured via Load Balancer service directly in EC2




# Coding challenge
    On a machine with PowerShell you should be able to edit the .\sampleinput.txt to have any input data you want to try or you can modify file name in the script to match the input file.

