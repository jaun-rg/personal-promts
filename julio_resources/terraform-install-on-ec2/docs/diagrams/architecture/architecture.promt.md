# Architecture Diagram Requirements

This document contains the requirements for the architecture diagram that represents the infrastructure where the Terraform project will be executed.

## Diagram Details
- **Name**: architecture
- **Location**: docs/diagrams/architecture/
- **Format**: PNG editable by draw.io

## Components

### External Services
- **GitHub**
  - Connected to Jenkins Master
  - Provides webhook triggers for Jenkins jobs on main branch changes

### AWS Cloud
The diagram should include the following AWS components:

#### Regions
- **us-east-1**
- **us-west-2**

#### In Each Region
- **VPC with public and private subnets**
  - Public subnet containing:
    - 1 EC2 with Terraform, Ansible (Jenkins Slave)
    - 1 EC2 with Node.js
    - 1 EC2 with Java
  - Private subnet (in us-east-1 only):
    - 1 EC2 with Jenkins Master
  - Internet Gateway
  - NAT Gateway
- **Services block**
  - S3 bucket (connected to Jenkins Slave)

#### Only in us-east-1
- **Jenkins Master EC2 instance** (in private subnet)
  - Connected to Jenkins Slaves in both regions
  - Connected to GitHub (external service)
  - Can execute jobs triggered manually or by GitHub webhook on main branch changes

#### Global Services
- **CloudFront** distribution associated with Jenkins Master
- **Route 53** with host jenkins.patito.com pointing to CloudFront

### Network Components
- Internet Gateways in each region
- NAT Gateways for private subnet access
- VPC Peering for cross-region communication between Jenkins Master and Slaves

### Additional Requirements
- All labels and text should be in English
- Show all necessary network components for Jenkins Master to connect to slaves in both regions
- Include any additional network elements like Internet Gateways and associations
- Add any other services (internal or external) that might be necessary for the architecture

## Purpose
This diagram represents the architecture where the Terraform project will be executed, showing how the different components interact with each other.
