# Optimized Architecture Diagram Requirements

This document contains detailed requirements for creating an architecture diagram that closely matches the current implementation in architecture.drawio.

## Diagram Details
- **Name**: optimized-architecture
- **Format**: draw.io editable diagram with PNG export capability
- **Canvas Size**: Use a large canvas (min : 1600x1880) to accommodate all components

## Overall Layout
- Create a main container with a title "Diagramas de arquitectura" at the top
- Place all AWS components inside an "AWS Cloud" container
- Place external services in a separate "External Services" container at the bottom center of  "AWS Cloud" container
- Project Details  on the right side of "AWS Cloud" container; minimun height is the same of "AWS Cloud" container


## Components and Structure

### AWS Cloud Container
The AWS Cloud container should include:

#### 1. Network Global Services (Top Section)
- **Route 53**
  - Label: "Route 53 jenkins.patito.com"
  - Connected to CloudFront
- **CloudFront**
  - Connected to Jenkins Master in us-east-1
  - Both services should be placed in a container labeled "Network Global Services"

#### 2. AWS Regions (Middle Section)
Create two region containers side by side:

##### Region: us-east-1 (Left Side)
- **VPC Container** with:
  - An "Availability Zone" container inside
  - **Public Subnet** 
  - **Private Subnet** (below public Subnet) containing:
    - Jenkins Master EC2 instance
    - Jenkins Slave EC2 instance (with Terraform, Ansible)
    - Node.js EC2 instance
    - Java EC2 instance
    - Connect Jenkins Master to Jenkins Slave
    - Connect Jenkins Slave to Node.js and Java instances
  - **NAT Gateway** (right side of VPC)
  - **Internet Gateway** (right side of VPC, below NAT Gateway)
- **Services Container** below VPC with:
  - S3 Bucket
  - Connect Jenkins Slave to S3 Bucket

##### Region: us-west-2 (Right Side)
- **VPC Container** with:
  - An "Availability Zone" container inside
  - **Public Subnet** 
  - **Private Subnet** (below Private Subnet) containing:
    - Jenkins Slave EC2 instance (with Terraform, Ansible)
    - Node.js EC2 instance
    - Java EC2 instance
    - Connect Jenkins Slave to Node.js and Java instances
  - **NAT Gateway** (right side of VPC)
  - **Internet Gateway** (right side of VPC, below NAT Gateway)
- **Services Container** below VPC with:
  - S3 Bucket
  - Connect Jenkins Slave to S3 Bucket

#### 3. Cross-Region Communication
- Add a **VPC Peering Connection** between the two regions
- Connect Jenkins Master in us-east-1 to Jenkins Slave in us-west-2 through the VPC Peering Connection
- Add a "Cross-Region Communication" label

#### 4. Global Services (below AWS Regions)
- **IAM**

### External Services Container
- **GitHub** icon
- **Push to branch** trigger icon
- Connect Jenkins Master to GitHub with a dashed line labeled "download repo Github webhook"

### Internet and User Access
- Add a **Users** icon at the top
- Add an **Internet** icon at the bottom right
- Connect Users to Route 53
- Connect Internet Gateways from both regions to the Internet icon
- Add a **Manual Trigger** icon connected to Jenkins Master

### Project Details 
- same height (or more) of AWS Cloud Container

#### Header
- header 1 with text: Project name: Terraform Install on EC2

#### Tecnical details
- List with follow text:
   - **Type**: Architecture Diagram
   - **Version**: 1.0
   - **Environments**: "dev / qa / prod
   - **Author**: Julio César Gómez Gómez
   - **Date**: 2025-06-15
  
#### Description
- Text block normal with the follorw text: This project provides a modular Terraform infrastructure for creating and provisioning EC2 instances in AWS. It allows you to create instances in multiple regions and install various dependencies and resources on them using either direct scripts or Ansible playbooks

#### Features
- List with follow text:   
   - Support for multiple regions
   - Modular architecture
   - VPC and network configuration
   - EC2 instance creation with dynamic module discovery
   - Automatic SSH key generation
   - Provisioning options (scripts and Ansible)
   - Support for different types of installations


#### Symbology (Bottom of Project Details)
- Header 3 with text: Symbology 
- Add a table with 2 columns without borders
   - Each column without title 
   - Left column (Arrows): each arrow type used diagram
   - Right column (Description): For each arrow, add the type connection       


## Styling Guidelines
1. **Colors and Icons**:
   - Use AWS official icons for all AWS services
   - Use purple (#8C4FFF) for network components (NAT Gateway, Internet Gateway, VPC Peering)
   - Use orange (#F58534) for EC2 instances
   - Use red (#E05243) for S3 buckets

2. **Containers**:
   - AWS Cloud: Light gray outline with AWS icon
   - Regions: Blue dashed outline with region icon
   - VPCs: Green outline with VPC icon
   - Private Subnets: Light blue fill
   - Public Subnets: Light green fill
   - Services: Dark outline with cloud icon

3. **Connections**:
   - Use solid arrows for direct connections
      - public to private: blue
      - private to public: blue
      - private to private: purple
      - public to public: green
   - Use dashed arrows for logical/indirect connections : gray
   - Add directional arrows to show data flow

## Create Diagram Plan

1. **Set up the canvas and main containers**
   - Create a large canvas
   - Add the main title "Diagramas de arquitectura"
   - Create the AWS Cloud container
   - Create the External Services container

2. **Create the Network Global Services section**

3. **Create the us-east-1 region**

4. **Create the us-west-2 region**
   - Follow the same structure as us-east-1
   - Omit the Jenkins Master instance

5. **Create the Global Services section**:

6. **Add cross-region communication**:

7. **Add external components and connections**:

8. **Add Project Details**:

9. **Review and finalize**:
   - Ensure all components are properly labeled
   - Verify all connections have appropriate arrows
   - Adjust layout for clarity and readability

## Notes
- Maintain consistent spacing between components
- Align similar components across regions for visual clarity
- Ensure all text is in English
