
# 🏥 Hospital Appointment Application – AWS Cloud & DevOps Project

## 📌 Project Overview

This project demonstrates the deployment of a Hospital Appointment Application on AWS using Infrastructure as Code, configuration management, networking, load balancing, auto scaling, and a managed database.

The project uses:

- ☁️ AWS
- 🏗️ Terraform
- ⚙️ Ansible
- 🐍 Python Flask
- 🐧 Linux
- 🌐 Application Load Balancer (ALB)
- 🔄 Auto Scaling Group (ASG)
- 💾 Amazon RDS MySQL
- 🔐 AWS Security Groups
- 🌍 Amazon VPC
- 🚪 Internet Gateway
- 🔀 NAT Gateway
- 📦 Git
- 🐙 GitHub

The main objective is to create a secure and highly available AWS architecture and automate infrastructure provisioning and server configuration.

---

# 🏗️ Architecture

```text
                         INTERNET
                            |
                            |
                    Internet Gateway
                            |
                            |
                 +----------------------+
                 |    PUBLIC SUBNETS    |
                 |                      |
                 |   Application        |
                 |   Load Balancer      |
                 |       (ALB)          |
                 +----------+-----------+
                            |
                     HTTP Port 80
                            |
                +-----------+-----------+
                |                       |
                v                       v
       +----------------+       +----------------+
       | Private App    |       | Private App    |
       | Subnet - AZ A  |       | Subnet - AZ B  |
       |                |       |                |
       | EC2 Instance   |       | EC2 Instance   |
       |      |         |       |      |         |
       +------+---------+       +------+---------+
              \                       /
               \                     /
                \                   /
                 +--------+--------+
                          |
                    MySQL Port 3306
                          |
             +------------+-------------+
             |                          |
             v                          v
     +---------------+          +---------------+
     | Private DB    |          | Private DB    |
     | Subnet - AZ A |          | Subnet - AZ B |
     +-------+-------+          +-------+-------+
             \                          /
              \                        /
               +----------+------------+
                          |
                    Amazon RDS MySQL
````

---

# 🌐 AWS Network Architecture

The project uses the AWS region:

```text
ap-south-1
```

The VPC CIDR is:

```text
10.0.0.0/16
```

The VPC contains six subnets distributed across two Availability Zones.

## Public Subnets

| Subnet   | CIDR        | Availability Zone | Purpose           |
| -------- | ----------- | ----------------- | ----------------- |
| Public A | 10.0.1.0/24 | ap-south-1a       | ALB / NAT Gateway |
| Public B | 10.0.2.0/24 | ap-south-1b       | ALB / NAT Gateway |

## Private Application Subnets

| Subnet        | CIDR        | Availability Zone | Purpose                 |
| ------------- | ----------- | ----------------- | ----------------------- |
| Private App A | 10.0.3.0/24 | ap-south-1a       | EC2 application servers |
| Private App B | 10.0.4.0/24 | ap-south-1b       | EC2 application servers |

## Private Database Subnets

| Subnet       | CIDR        | Availability Zone | Purpose |
| ------------ | ----------- | ----------------- | ------- |
| Private DB A | 10.0.5.0/24 | ap-south-1a       | RDS     |
| Private DB B | 10.0.6.0/24 | ap-south-1b       | RDS     |

The subnet configuration is defined in `subnets.tf`. 

---

# 🔐 Security Architecture

The application follows a three-layer network design:

```text
Internet
   |
   v
ALB
Public
   |
   v
EC2
Private
   |
   v
RDS
Private
```

The EC2 application servers are not intended to receive application traffic directly from the internet.

Instead:

```text
Internet
   |
   v
ALB : 80
   |
   v
EC2 : 5000
   |
   v
RDS : 3306
```

---

# ⚖️ Application Load Balancer

An internet-facing Application Load Balancer is used to receive user requests.

The ALB is deployed in:

```text
Public Subnet A
Public Subnet B
```

The ALB listens on:

```text
HTTP : 80
```

It forwards requests to the application target group on:

```text
HTTP : 5000
```

The target group performs health checks against the application.

Health check configuration:

```text
Protocol       : HTTP
Path           : /
Port           : 5000
Healthy        : 2
Unhealthy      : 3
Interval       : 30 seconds
Timeout        : 5 seconds
Matcher        : 200-399
```

The ALB configuration is defined in:

```text
terraform/alb.tf
```

The ALB is internet-facing and uses the public subnets, while the target group sends traffic to application instances in the private subnets. 

---

# 🔄 Auto Scaling Group

The application servers are managed using an AWS Auto Scaling Group.

Configuration:

```text
Minimum instances : 2
Desired instances  : 2
Maximum instances  : 4
```

The instances are launched into:

```text
Private App Subnet A
Private App Subnet B
```

The Auto Scaling Group is connected to the ALB target group.

It also uses:

```text
health_check_type = ELB
```

This allows the load balancer health status to be used when managing application instances.

The configuration is defined in:

```text
terraform/ec2.tf
```



---

# 💻 EC2 Application Servers

EC2 instances run the Flask application.

Terraform creates a Launch Template containing:

* AMI
* Instance type
* Key pair
* Security group
* User data

The current default instance type is:

```text
t3.micro
```

The application runs on:

```text
Port 5000
```

The Flask application provides:

```text
/
```

and:

```text
/health
```

The `/health` endpoint returns:

```text
OK
```

The Launch Template and Auto Scaling Group are defined in:

```text
terraform/ec2.tf
```



---

# 🗄️ Amazon RDS MySQL

Amazon RDS is used as the managed database layer.

Configuration:

```text
Engine          : MySQL
Engine Version  : 8.0
Instance Class  : db.t3.micro
Storage         : 20 GB
Storage Type    : gp3
Database Name   : hospitaldb
Port            : 3306
Public Access   : Disabled
Multi-AZ        : Disabled
Backup Retention: 7 days
```

RDS is deployed using a DB subnet group containing:

```text
Private DB Subnet A
Private DB Subnet B
```

The database is not publicly accessible.

The RDS configuration is defined in:

```text
terraform/rds.tf
```



---

# 🔒 Security Groups

Three security groups are used.

## 1. ALB Security Group

The ALB allows:

```text
HTTP  : 80
HTTPS : 443
```

from the internet.

The ALB security group is:

```text
hospital-alb-sg
```

## 2. Application Security Group

The application security group allows:

```text
Port 5000
```

only from the ALB security group.

It also currently allows SSH:

```text
Port 22
```

The SSH rule should be restricted in a production environment.

Security group:

```text
hospital-app-sg
```

## 3. RDS Security Group

The RDS security group allows:

```text
MySQL : 3306
```

only from the application security group.

Security group:

```text
hospital-rds-sg
```

Therefore the communication flow is:

```text
Internet
   |
   | 80
   v
ALB
   |
   | 5000
   v
EC2
   |
   | 3306
   v
RDS
```

The security groups are defined in:

```text
terraform/security.tf
```



---

# 🌐 Internet Gateway

The VPC contains an Internet Gateway.

The public route table contains:

```text
0.0.0.0/0 → Internet Gateway
```

This provides internet connectivity for resources in the public subnets.

The VPC and Internet Gateway are defined in:

```text
terraform/vpc.tf
```

The routing configuration is defined in:

```text
terraform/routes.tf
```



---

# 🔀 NAT Gateway

Two NAT Gateways are created.

```text
NAT Gateway A → Public Subnet A
NAT Gateway B → Public Subnet B
```

Each NAT Gateway has an Elastic IP.

Private application subnets use NAT Gateways for outbound internet connectivity.

Example:

```text
Private EC2
    |
    v
NAT Gateway
    |
    v
Internet Gateway
    |
    v
Internet
```

The NAT Gateway configuration is defined in:

```text
terraform/nat.tf
```



---

# 🏗️ Terraform

Terraform is used as Infrastructure as Code.

Instead of manually creating AWS resources through the AWS Console, infrastructure is defined using Terraform `.tf` files.

Terraform provisions:

* VPC
* Internet Gateway
* Public subnets
* Private application subnets
* Private database subnets
* Route tables
* NAT Gateways
* Elastic IPs
* Security Groups
* Application Load Balancer
* Target Group
* Listener
* Launch Template
* Auto Scaling Group
* RDS MySQL

---

# 📁 Terraform Files

```text
terraform/
│
├── .gitignore
├── .terraform.lock.hcl
├── main.tf
├── variables.tf
├── vpc.tf
├── subnets.tf
├── routes.tf
├── nat.tf
├── security.tf
├── alb.tf
├── ec2.tf
└── rds.tf
```

These are the actual Terraform files currently present in the repository. ([GitHub][2])

---

# 📄 Terraform File Responsibilities

| File           | Purpose                                              |
| -------------- | ---------------------------------------------------- |
| `main.tf`      | Terraform and AWS provider configuration             |
| `variables.tf` | Input variables                                      |
| `vpc.tf`       | VPC and Internet Gateway                             |
| `subnets.tf`   | Public, application and database subnets             |
| `routes.tf`    | Route tables and subnet associations                 |
| `nat.tf`       | NAT Gateways and Elastic IPs                         |
| `security.tf`  | ALB, EC2 and RDS security groups                     |
| `alb.tf`       | Application Load Balancer, target group and listener |
| `ec2.tf`       | Launch Template and Auto Scaling Group               |
| `rds.tf`       | RDS MySQL and DB subnet group                        |

The Terraform provider is configured for `ap-south-1`. 

---

# ⚙️ Ansible

Ansible is used for server configuration and application deployment.

The Ansible playbook performs tasks such as:

1. Update packages
2. Install Git
3. Install Python
4. Install pip
5. Install Python virtual environment
6. Clone the GitHub repository
7. Create a Python virtual environment
8. Install application dependencies
9. Create a systemd service
10. Start the Flask application
11. Enable the application service

The main playbook is:

```text
ansible/playbook.yml
```



---

# 📁 Ansible Files

```text
ansible/
│
├── ansible.cfg
├── inventory
└── playbook.yml
```

The current repository contains these three Ansible files. ([GitHub][3])

---

# 🐍 Flask Application

The application is built using Python Flask.

Application structure:

```text
application/
│
├── app.py
├── requirements.txt
├── static/
└── templates/
```

The Flask application handles HTTP requests and provides the hospital appointment interface.

---

# 🔗 GitHub

GitHub is used for source code management.

The repository contains:

```text
application/
terraform/
ansible/
README.md
```

Repository:

```text
https://github.com/Anitha-110/medicare-hospital-devops
```

---

# 🔄 End-to-End Project Flow

The complete architecture works like this:

```text
Developer
    |
    v
Git
    |
    v
GitHub
    |
    v
Terraform
    |
    v
AWS Infrastructure
    |
    +---- VPC
    |
    +---- Public Subnets
    |
    +---- Private App Subnets
    |
    +---- Private DB Subnets
    |
    +---- Internet Gateway
    |
    +---- NAT Gateways
    |
    +---- Security Groups
    |
    +---- ALB
    |
    +---- Auto Scaling Group
    |
    +---- RDS
    |
    v
EC2 Application Servers
    |
    v
Ansible
    |
    +---- Install Packages
    |
    +---- Clone Application
    |
    +---- Install Dependencies
    |
    +---- Configure systemd
    |
    +---- Start Flask
    |
    v
Hospital Appointment Application
    |
    v
RDS MySQL
```

---

# 🌍 User Request Flow

When a user opens the application:

```text
User Browser
     |
     v
Internet
     |
     v
Internet Gateway
     |
     v
Application Load Balancer
     |
     | HTTP : 80
     v
Target Group
     |
     | HTTP : 5000
     v
EC2 Application Server
     |
     | MySQL : 3306
     v
Amazon RDS MySQL
```

The ALB distributes requests between healthy EC2 instances in the Auto Scaling Group.

---

# 🩺 Health Check Flow

The ALB checks the application using:

```text
HTTP
Port : 5000
Path : /
```

If an EC2 instance becomes unhealthy:

```text
ALB
 |
 | Health Check
 v
Unhealthy EC2
 |
 X
```

The ALB stops routing normal traffic to the unhealthy target.

The Auto Scaling Group can maintain the required number of application instances.

---

# 🚀 Terraform Deployment

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Create infrastructure:

```bash
terraform apply
```

Confirm with:

```text
yes
```

---

# ⚙️ Ansible Deployment

Navigate to the Ansible directory:

```bash
cd ansible
```

Test connectivity:

```bash
ansible all -m ping
```

Run the playbook:

```bash
ansible-playbook playbook.yml
```

The playbook configures the server and starts the Flask application.

---

# 🔍 Application Verification

After deployment, verify:

### ALB

Check that the ALB is:

```text
Active
```

### Target Group

Check that EC2 targets are:

```text
Healthy
```

### EC2

Verify the application instances are:

```text
Running
```

### RDS

Verify:

```text
RDS Status = Available
```

### Application

Access the application using the ALB DNS name.

---

# 🧪 Useful Commands

## Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Ansible

```bash
ansible all -m ping
ansible-playbook playbook.yml
```

## Linux

```bash
systemctl status hospital-app
systemctl restart hospital-app
journalctl -u hospital-app
```

---

# 🧹 Destroy Infrastructure

To remove the AWS infrastructure created by Terraform:

```bash
terraform destroy
```

Review the resources carefully before confirming.

This is especially important because resources such as:

* NAT Gateway
* RDS
* EC2
* ALB
* Elastic IP

can generate AWS charges.

---

# 🔐 Security Considerations

The project separates the infrastructure into:

```text
Public Layer
    |
    +---- ALB
    +---- NAT Gateway

Private Application Layer
    |
    +---- EC2
    +---- Auto Scaling Group

Private Database Layer
    |
    +---- RDS MySQL
```

Important security principles:

* ALB is publicly accessible.
* EC2 application servers are placed in private subnets.
* RDS is placed in private database subnets.
* EC2 receives application traffic from the ALB security group.
* RDS receives MySQL traffic from the application security group.
* Database public access is disabled.
* Separate security groups are used for each layer.

---

# 📊 High Availability Design

The application layer is distributed across two Availability Zones:

```text
Availability Zone A
    |
    +---- Public ALB
    +---- Private EC2
    +---- Private RDS subnet


Availability Zone B
    |
    +---- Public ALB
    +---- Private EC2
    +---- Private RDS subnet
```

The Auto Scaling Group maintains a minimum of two application instances.

This improves application availability and allows the application layer to scale when required.

---

# 🎯 DevOps Concepts Demonstrated

This project demonstrates practical knowledge of:

* ☁️ AWS Cloud
* 🏗️ Infrastructure as Code
* 🔄 Terraform
* ⚙️ Ansible
* 🐳 Application deployment concepts
* 🐧 Linux administration
* 🌐 AWS Networking
* 🔐 Security Groups
* ⚖️ Load Balancing
* 🔄 Auto Scaling
* 💾 RDS
* 🐍 Python Flask
* 📦 Git
* 🐙 GitHub
* 🔧 Configuration Management
* 🤖 Automation
* 🩺 Application Health Checks
* 🌍 High Availability Architecture

---

# 💼 Interview Project Explanation

### Short Version

> "I developed a Hospital Appointment Application deployment on AWS using Terraform and Ansible. Terraform provisions the complete AWS infrastructure including a VPC, public and private subnets across two Availability Zones, Internet Gateway, NAT Gateways, security groups, an internet-facing Application Load Balancer, an Auto Scaling Group and private RDS MySQL. The ALB receives user traffic on port 80 and forwards it to Flask application servers running on port 5000 in private subnets. RDS runs in private database subnets and accepts MySQL traffic only from the application security group. I used Ansible to configure the application servers, install dependencies, clone the application from GitHub and manage the Flask application using systemd."

---

# 🔑 Key Architecture

```text
GitHub
   |
   v
Terraform
   |
   v
AWS VPC
   |
   +-------------------------------+
   |                               |
   v                               v
Public Subnets                Private Subnets
   |                               |
   v                               |
ALB                               |
   |                               |
   v                               v
EC2 Auto Scaling Group -------> RDS MySQL
   |
   v
Flask Application
```

---

# 👩‍💻 Project Responsibilities

In this project, I worked on:

* Designing the AWS network architecture
* Creating AWS infrastructure using Terraform
* Creating public and private subnets
* Configuring route tables
* Configuring Internet Gateway and NAT Gateways
* Creating security groups
* Configuring Application Load Balancer
* Configuring target groups and health checks
* Configuring EC2 Launch Template
* Configuring Auto Scaling Group
* Deploying RDS MySQL
* Configuring application servers using Ansible
* Installing Python dependencies
* Deploying Flask application
* Managing application using systemd
* Troubleshooting networking and database connectivity
* Managing code using Git and GitHub

---

# ⭐ Project Highlights

### Infrastructure as Code

Terraform is used to provision AWS infrastructure automatically.

### Configuration Management

Ansible automates server configuration and application deployment.

### Load Balancing

ALB distributes incoming requests across healthy application servers.

### Auto Scaling

The application layer runs using an Auto Scaling Group with:

```text
Minimum : 2
Desired : 2
Maximum : 4
```

### Security

Application servers and RDS are kept in private subnets.

### Database

Amazon RDS MySQL provides the managed database layer.

### High Availability

The application layer is distributed across two Availability Zones.

---

# 📌 Project Structure

```text
medicare-hospital-devops/
│
├── application/
│   ├── app.py
│   ├── requirements.txt
│   ├── static/
│   └── templates/
│
├── terraform/
│   ├── .gitignore
│   ├── .terraform.lock.hcl
│   ├── main.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── routes.tf
│   ├── nat.tf
│   ├── security.tf
│   ├── alb.tf
│   ├── ec2.tf
│   └── rds.tf
│
├── ansible/
│   ├── ansible.cfg
│   ├── inventory
│   └── playbook.yml
│
└── README.md
```

---

# 🏁 Conclusion

This project demonstrates an AWS-based Hospital Appointment Application using a secure 
