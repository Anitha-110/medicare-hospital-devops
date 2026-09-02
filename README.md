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
