# AWS Multi-Region Jenkins Architecture Diagram

## Diagram Specifications
- **Name**: copilot
- **Location**: docs/diagrams/architecture/
- **Format**: PNG (editable in draw.io)
- **Tool**: draw.io

## Architecture Components

### External Services Block
1. GitHub
   - Connection to Jenkins master
   - Webhook integration for main branch changes
   - Repository hosting for infrastructure code

### AWS Cloud Infrastructure

#### Regional Components

##### US East 1 (N. Virginia) Region
1. VPC Configuration
   - Public Subnets
   - Private Subnets
   - Internet Gateway
   - NAT Gateway
   - Route Tables
   - Security Groups
   
2. EC2 Instances
   - Jenkins Slave Instance (Private Subnet)
     * Terraform installed
     * Ansible installed
     * Access to other EC2 instances
     * Access to S3 bucket
   - Node.js Instance (Private Subnet)
   - Java Instance (Private Subnet)

3. Jenkins Master Instance (Private Subnet)
   - Connections:
     * To Jenkins slaves in both regions
     * To GitHub for repository monitoring
     * To CloudFront for public access
   - Job Execution:
     * Manual trigger support
     * Automated triggers on GitHub main branch changes

4. Services Block
   - S3 Bucket for artifacts and backups

##### US West 2 (Oregon) Region
1. VPC Configuration
   - Public Subnets
   - Private Subnets
   - Internet Gateway
   - NAT Gateway
   - Route Tables
   - Security Groups

2. EC2 Instances
   - Jenkins Slave Instance (Private Subnet)
     * Terraform installed
     * Ansible installed
     * Access to other EC2 instances
     * Access to S3 bucket
   - Node.js Instance (Private Subnet)
   - Java Instance (Private Subnet)

3. Services Block
   - S3 Bucket for artifacts and backups

#### Global Services Block
1. Amazon CloudFront
   - Distribution connected to Jenkins master
   - SSL/TLS certificate from ACM
   - Edge locations for global access

2. Amazon Route 53
   - DNS record: jenkins.patito.com
   - A-record pointing to CloudFront distribution
   - DNS health checks

## Network Connectivity Requirements

### Inter-Region Communication
1. VPC Peering Connection
   - Between us-east-1 and us-west-2
   - Route table entries for cross-region communication
   - Security group rules for Jenkins master-slave communication

### Security Components
1. VPC Components
   - Internet Gateways for public internet access
   - NAT Gateways for private subnet internet access
   - Network ACLs for subnet-level security
   - Security Groups for instance-level security
   - VPC Endpoints for AWS services (S3)

2. Access Controls
   - IAM roles for EC2 instances
   - Security group rules for Jenkins communication
   - Network ACL rules for subnet protection

### Service Connections
1. Jenkins Master to Slave Communication
   - Secure communication over private network
   - Cross-region connectivity via VPC peering
   - Proper security group rules

2. External Service Integration
   - GitHub webhook integration
   - CloudFront distribution access
   - Route 53 DNS resolution

## Additional Components

### Monitoring and Management
1. CloudWatch
   - EC2 instance monitoring
   - VPC flow logs
   - Custom metrics for Jenkins

2. AWS Systems Manager
   - EC2 instance management
   - Patch management
   - Automation

### Backup and Recovery
1. AWS Backup
   - EC2 instance backups
   - S3 bucket versioning
   - Cross-region backup copies

### Security
1. AWS WAF
   - Web application firewall for CloudFront
   - Protection against common web exploits
   - IP address filtering

2. AWS Certificate Manager
   - SSL/TLS certificates for CloudFront
   - Certificate management and renewal

## Diagram Requirements

### Visual Elements
1. Layout
   - Clear hierarchical structure
   - Logical grouping of components
   - Region separation

2. Connections
   - Distinct line types for different connections
   - Arrow direction showing data flow
   - Clear master-slave relationships

3. Text and Labels
   - All text in English
   - Clear and consistent naming
   - Service names and purposes

### AWS Icons
- Use official AWS architecture icons
- Maintain proper scaling and positioning
- Include service names under icons

### Network Paths
- Show all network connections
- Indicate traffic flow directions
- Mark security boundaries

## Implementation Notes
This diagram represents the infrastructure for a multi-region Jenkins deployment with:
- High availability through regional distribution
- Secure communication between components
- Scalable architecture for future growth
- Integration with external services
- Global content delivery
- Comprehensive monitoring and management
