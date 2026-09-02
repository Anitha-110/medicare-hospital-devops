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

<img width="1361" height="611" alt="p12_051544" src="https://github.com/user-attachments/assets/6a40e4fd-7f45-4dd3-9e50-9a19211959c2" />

<img width="1356" height="653" alt="p13_051552" src="https://github.com/user-attachments/assets/9379afa7-445f-4a67-915f-b9f2f930917a" />


<img width="1279" height="460" alt="p1_051525~2" src="https://github.com/user-attachments/assets/2b1cde36-a03e-4a69-85a7-b6619635db04" />

<img width="842" height="481" alt="p6_051537~2" src="https://github.com/user-attachments/assets/f8a5153d-4a14-4475-8691-4d309b4019f0" />

<img width="1317" height="440" alt="p10_051542~2" src="https://github.com/user-attachments/assets/2beb34e7-2218-411d-9cf1-b3dbd6e474a6" />



<img width="1366" height="582" alt="p5_051536~2" src="https://github.com/user-attachments/assets/f33de704-c997-4b32-a438-159adde4a3e9" />

<img width="1346" height="564" alt="p4_051535~2" src="https://github.com/user-attachments/assets/cb9ea38b-c60d-45e2-9d74-ed5e62e7daf5" />


<img width="1069" height="114" alt="p3_051532~2" src="https://github.com/user-attachments/assets/654b79fb-2835-477e-a6e6-283e536fd05a" />


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




















