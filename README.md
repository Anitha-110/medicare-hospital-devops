 **Hospital Appointment DevOps project**

* Project overview
* Architecture
* AWS services used
* Terraform — what it creates and how it works
* Ansible — what it configures
* Application — what it does
* Git/GitHub workflow
* Deployment flow
* How to run Terraform
* How to run Ansible
* How the complete project works
* Project structure
* Screenshots
* Cleanup/destroy commands


Here is a complete README you can use:

# 🏥 Hospital Appointment Application – AWS DevOps Project

## 📌 Project Overview

This project demonstrates the deployment of a **Hospital Appointment Application** on AWS using Infrastructure as Code and Configuration Management.

The project uses:

* **AWS** – Cloud infrastructure
* **Terraform** – Infrastructure provisioning
* **Ansible** – Server configuration and application deployment
* **Git & GitHub** – Source code management
* **EC2** – Application server
* **RDS MySQL** – Database
* **VPC** – Network isolation
* **Internet Gateway** – Internet connectivity for public resources
* **NAT Gateway** – Outbound internet connectivity for private resources
* **Security Groups** – Network security

The goal is to automate the complete infrastructure and application deployment process instead of manually creating and configuring AWS resources.

---

# 🏗️ Architecture

```text
                         Internet
                            |
                            |
                     Internet Gateway
                            |
                            |
                     Public Subnet
                            |
                      EC2 Web Server
                            |
                            |
                    Private Subnet
                            |
                       RDS MySQL
                            |
                         Database
```

### Network Architecture

```text
AWS Region: ap-south-1
        |
        VPC
        |
        +-----------------------+
        |                       |
   Public Subnet          Private Subnets
        |                       |
     EC2 Server             RDS MySQL
        |
   Internet Gateway
        |
    NAT Gateway
```

---

# 🔧 Technologies Used

| Technology     | Purpose                  |
| -------------- | ------------------------ |
| AWS            | Cloud platform           |
| Terraform      | Infrastructure as Code   |
| Ansible        | Configuration management |
| Git            | Version control          |
| GitHub         | Code repository          |
| Linux/Ubuntu   | Server operating system  |
| Python         | Application backend      |
| Flask          | Web framework            |
| MySQL          | Database                 |
| EC2            | Application server       |
| RDS            | Managed database         |
| VPC            | Network                  |
| Security Group | Firewall                 |

---

# ☁️ AWS Services Used

## 1. Amazon VPC

A VPC provides an isolated network environment for the application.

The VPC contains:

* Public subnet
* Private subnets
* Route tables
* Internet Gateway
* NAT Gateway
* Security Groups

---

## 2. Public Subnet

The EC2 application server is deployed in the public subnet.

The public subnet allows the server to receive internet traffic through the Internet Gateway.

---

## 3. Private Subnets

Private subnets are used for resources that should not be directly accessible from the internet.

The RDS database is placed inside private subnets.

---

## 4. Internet Gateway

The Internet Gateway provides internet connectivity for resources in the public subnet.

Example:

```text
User
 |
Internet
 |
Internet Gateway
 |
Public Subnet
 |
EC2
```

---

## 5. NAT Gateway

The NAT Gateway allows resources inside private subnets to access the internet for outbound communication without making them directly reachable from the internet.

Example:

```text
Private Resource
       |
       v
NAT Gateway
       |
       v
Internet Gateway
       |
    Internet
```

---

# 💻 EC2

EC2 is used as the application server.

Terraform creates the EC2 instance.

After the instance is created, Ansible connects to the server using SSH and performs the required configuration.

Ansible installs/configures the required software and deploys the hospital appointment application.

---

# 🗄️ RDS MySQL

Amazon RDS is used as the managed database service.

The application stores appointment and other application-related data in MySQL.

RDS is deployed in private subnets for better security.

Example:

```text
Flask Application
       |
       |
       v
RDS MySQL
       |
       |
   Database
```

---

# 🔐 Security Groups

Security Groups act as virtual firewalls.

Typical rules include:

### EC2 Security Group

```text
SSH       - Port 22
HTTP      - Port 80
Application Port - Required application port
```

SSH should preferably be restricted to the administrator's IP address instead of allowing the entire internet.

### RDS Security Group

RDS should allow MySQL traffic only from the application server/security group.

```text
EC2
 |
 | MySQL 3306
 v
RDS
```

This prevents direct public access to the database.

---

# 🏗️ Terraform

Terraform is used to create AWS infrastructure automatically.

Instead of manually creating AWS resources through the AWS Console, Terraform defines the infrastructure using `.tf` files.

Terraform can create:

* VPC
* Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* EC2
* RDS
* IAM resources when required

---

# 🔄 How Terraform Works

The Terraform workflow is:

```text
Terraform Code
      |
      v
terraform init
      |
      v
terraform validate
      |
      v
terraform plan
      |
      v
terraform apply
      |
      v
AWS Infrastructure
```

### Step 1 – Initialize Terraform

```bash
terraform init
```

This downloads the required Terraform providers.

### Step 2 – Validate

```bash
terraform validate
```

This checks whether the Terraform configuration is syntactically correct.

### Step 3 – Plan

```bash
terraform plan
```

This shows what Terraform plans to create, modify, or destroy.

### Step 4 – Apply

```bash
terraform apply
```

This creates the AWS infrastructure.

---

# ⚙️ Ansible

Ansible is used after Terraform creates the EC2 instance.

Terraform creates the server.

Ansible configures the server.

This separation makes the deployment easier to manage.

---

# 🔄 How Ansible Works

```text
Terraform
   |
   v
EC2 Created
   |
   v
EC2 Public IP
   |
   v
Ansible Inventory
   |
   v
SSH Connection
   |
   v
Install Required Packages
   |
   v
Deploy Application
   |
   v
Start Application
```

Ansible can perform tasks such as:

* Connect to EC2
* Install Python
* Install required packages
* Install application dependencies
* Copy application files
* Configure services
* Start/restart the application

---

# 📁 Project Structure

```text
hospital-devops/
│
├── application/
│   ├── app.py
│   ├── requirements.txt
│   ├── static/
│   │   └── css/
│   │       └── style.css
│   └── templates/
│       └── ...
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── route_table.tf
│   ├── nat_gateway.tf
│   ├── security_group.tf
│   ├── ec2.tf
│   ├── rds.tf
│   └── outputs.tf
│
├── ansible/
│   ├── inventory
│   ├── playbook.yml
│   └── ansible.cfg
│
└── README.md
```

The exact filenames can be changed depending on the final Terraform and Ansible structure.

---

# 🚀 Complete Deployment Flow

The complete project works in the following order:

```text
Developer
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
    +---- Subnets
    |
    +---- Internet Gateway
    |
    +---- NAT Gateway
    |
    +---- Security Groups
    |
    +---- EC2
    |
    +---- RDS
    |
    v
Ansible
    |
    v
EC2 Configuration
    |
    v
Application Deployment
    |
    v
Hospital Appointment Website
    |
    v
RDS MySQL Database
```

---

# 🔁 Detailed Working

## Step 1 – Developer pushes code

Application, Terraform and Ansible files are stored in GitHub.

```text
Developer
    |
    v
Git
    |
    v
GitHub Repository
```

---

## Step 2 – Terraform creates infrastructure

Terraform reads the `.tf` files and creates the AWS environment.

```text
Terraform
    |
    +--> VPC
    |
    +--> Subnets
    |
    +--> Route Tables
    |
    +--> Internet Gateway
    |
    +--> NAT Gateway
    |
    +--> Security Groups
    |
    +--> EC2
    |
    +--> RDS
```

---

## Step 3 – EC2 is created

Terraform creates the EC2 instance in the public subnet.

The EC2 instance receives a public IP address.

---

## Step 4 – Ansible connects to EC2

The EC2 public IP is added to the Ansible inventory.

Example:

```ini
[web]
EC2_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=Anitha.pem
```

Ansible then tests the connection.

```bash
ansible all -m ping
```

If the connection is successful:

```text
SUCCESS
```

---

# 🛠️ Step 5 – Ansible Configures the Server

Ansible executes the playbook.

Example tasks:

```text
Connect to EC2
      |
      v
Update packages
      |
      v
Install Python
      |
      v
Install application dependencies
      |
      v
Copy application
      |
      v
Configure application
      |
      v
Start application
```

---

# 🌐 Step 6 – User Accesses Application

Once deployment is completed, users can access the application using the EC2 public IP/domain.

```text
User
 |
 v
Internet
 |
 v
EC2
 |
 v
Hospital Appointment Application
 |
 v
RDS MySQL
```

---

# 🏥 Application Features

The Hospital Appointment Application provides a web interface for hospital appointment management.

Possible application features include:

* Hospital information
* Doctor information
* Patient information
* Appointment booking
* Appointment details
* Contact information
* Responsive web interface

The Flask application handles backend requests and communicates with the database.

---

# 🐍 Flask Application

The backend application is written using Python Flask.

Example application flow:

```text
Browser
   |
   v
Flask Application
   |
   +---- Process Request
   |
   +---- Validate Data
   |
   +---- Database Query
   |
   v
RDS MySQL
   |
   v
Response
   |
   v
Browser
```

---

# 🗃️ Database Flow

When a user submits an appointment:

```text
Patient
   |
   v
Appointment Form
   |
   v
Flask Application
   |
   v
MySQL Connection
   |
   v
RDS MySQL
   |
   v
Appointment Stored
```

---

# 🔐 Security Design

The project follows a basic AWS security architecture.

### Public

```text
Internet
   |
   v
EC2
```

### Private

```text
EC2
 |
 v
RDS
```

The database is not intended to be directly accessible from the public internet.

Security Groups control communication between the application and database.

---

# 📦 Git Workflow

Git is used for version control.

Basic workflow:

```bash
git status
```

```bash
git add .
```

```bash
git commit -m "Add hospital DevOps project"
```

```bash
git push origin main
```

This uploads the project to GitHub.

---

# 📌 Important Files

## Terraform Files

Terraform files define the AWS infrastructure.

```text
provider.tf       → AWS provider
variables.tf      → Input variables
vpc.tf            → VPC
subnet.tf         → Subnets
route_table.tf    → Routing
nat_gateway.tf    → NAT Gateway
security_group.tf → Security Groups
ec2.tf            → EC2
rds.tf            → RDS
outputs.tf        → Outputs
```

## Ansible Files

```text
inventory      → EC2 connection details
playbook.yml   → Server configuration tasks
ansible.cfg    → Ansible configuration
```

## Application

```text
app.py              → Flask application
requirements.txt    → Python dependencies
templates/          → HTML pages
static/             → CSS/static files
```

---

# 🧪 Testing

After deployment, test the following:

### Terraform

```bash
terraform validate
```

### Terraform Plan

```bash
terraform plan
```

### Ansible Connection

```bash
ansible all -m ping
```

### Application

Open the EC2 public IP in a browser.

### Database

Verify that the application can communicate with RDS.

---

# 📊 Infrastructure Verification

After Terraform deployment, verify the following in AWS:

* VPC exists
* Public subnet exists
* Private subnets exist
* Internet Gateway exists
* NAT Gateway exists
* Route tables are correctly associated
* EC2 is running
* RDS is available
* Security Groups are attached correctly

---

# 🧹 Destroy Infrastructure

When the project is no longer required, Terraform can remove the infrastructure.

```bash
terraform destroy
```

Review the resources carefully before confirming.

```text
terraform destroy
        |
        v
AWS Resources Removed
```

This helps avoid unnecessary AWS charges.

---

# 💰 Cost Consideration

Some AWS resources can generate charges even when the application is not actively being used.

Examples include:

* NAT Gateway
* RDS
* EC2
* Elastic IP addresses

For a learning project, destroy unused infrastructure after testing.

```bash
terraform destroy
```

---

# 🎯 Project Objective

The main objective of this project is to demonstrate practical knowledge of:

* AWS Cloud
* Infrastructure as Code
* Terraform
* Ansible
* Linux
* Git
* GitHub
* Networking
* EC2
* RDS
* Security Groups
* Application deployment
* Automation

---

# 📚 DevOps Concepts Demonstrated

This project demonstrates the following DevOps concepts:

### Infrastructure as Code

Terraform creates infrastructure using code instead of manually creating resources.

### Configuration Management

Ansible configures the EC2 server automatically.

### Version Control

Git tracks changes to application and infrastructure code.

### Automation

The infrastructure and server configuration are automated.

### Cloud Deployment

The application runs on AWS infrastructure.

### Security

Private database architecture and security groups are used to control network access.

---

# 🔄 End-to-End DevOps Lifecycle

```text
Code
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
 v
EC2
 |
 v
Ansible
 |
 v
Application Deployment
 |
 v
Flask Application
 |
 v
RDS MySQL
 |
 v
Hospital Appointment System
```

---

# 📸 Screenshots

<img width="1365" height="603" alt="p3" src="https://github.com/user-attachments/assets/7c3201b8-1536-4238-a0e7-eba2b30fac31" />
<img width="1365" height="608" alt="p4" src="https://github.com/user-attachments/assets/49ca1850-d190-4182-a0f8-4453da4cb0ca" />
<img width="1366" height="608" alt="p5" src="https://github.com/user-attachments/assets/3e3d0ce3-f08d-4b0f-87ea-f9307ffca06e" />
<img width="855" height="524" alt="p6" src="https://github.com/user-attachments/assets/a4adab14-980f-4a32-9b2c-fb64db986f11" />
<img width="1366" height="568" alt="p11" src="https://github.com/user-attachments/assets/8964c8d2-c4fb-454a-b153-7f67b3a6080f" />
<img width="1361" height="611" alt="p12" src="https://github.com/user-attachments/assets/0d88dd78-8d47-4ff9-9fa4-0bf638ae74c6" />
<img width="1356" height="653" alt="p13" src="https://github.com/user-attachments/assets/34d6f4cb-a5f3-4f48-a68b-c4078f73e5a4" />


Recommended screenshots:

1. AWS VPC
2. Subnets
3. EC2 instance
4. RDS instance
5. Security Groups
6. Terraform apply
7. Ansible ping
8. Ansible playbook execution
9. Hospital application homepage
10. Appointment page


```

---

# 👩‍💻 Project by

**Anitha M**

### Skills Demonstrated

* AWS
* Terraform
* Ansible
* Linux
* Git
* GitHub
* Python
* Flask
* MySQL
* AWS Networking
* Infrastructure as Code
* Configuration Management

---

# ⭐ Conclusion

This project demonstrates how a web application can be deployed on AWS using modern DevOps practices.

Terraform automates infrastructure provisioning, while Ansible automates server configuration and application deployment.

The combination of AWS, Terraform, Ansible, Git and GitHub creates a repeatable and automated deployment workflow.

```text
Terraform → Infrastructure
Ansible   → Configuration
GitHub    → Version Control
AWS       → Cloud
Flask     → Application
RDS       → Database
```
