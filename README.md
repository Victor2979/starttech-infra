# StartTech Infrastructure (`starttech-infra`)

Terraform-managed AWS infrastructure for the StartTech full-stack application: a React frontend on S3 + CloudFront, a Golang backend on an EC2 Auto Scaling Group behind an ALB, ElastiCache Redis, and CloudWatch observability.

> **Companion repo:** `starttech-application` holds the app code and its CI/CD pipelines. This repo holds infrastructure only.

## Architecture

Internet
|
|-- CloudFront --> S3 (React frontend, private bucket via OAC)
|
|-- ALB (public subnets) --> Target Group :8080
|
Auto Scaling Group (private subnets)
|  EC2 (Docker: Golang API)
|--> ElastiCache Redis (private)
|--> MongoDB Atlas (external)
|--> CloudWatch Logs


## Repository layout

starttech-infra/
├── .github/workflows/infrastructure-deploy.yml   # plan on PR, apply on merge
├── terraform/
│   ├── main.tf              # wires the modules together
│   ├── variables.tf         # all input variables
│   ├── outputs.tf           # root outputs (ALB DNS, bucket, etc.)
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── networking/      # VPC, subnets, IGW, NAT, routes
│       ├── compute/         # ALB, ASG, launch template, Redis, SGs
│       ├── storage/         # S3 + CloudFront
│       └── monitoring/      # CloudWatch log group + EC2 IAM
└── README.md

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured (`aws configure`)
- A MongoDB Atlas connection string

## Quick start

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
#   edit terraform.tfvars: set backend_image and mongo_uri

terraform init
terraform plan
terraform apply
```

### Outputs

| Output | Meaning |
|--------|---------|
| `alb_dns_name` | Public URL of the backend API |
| `cloudfront_domain_name` | Public URL of the frontend |
| `frontend_bucket_name` | S3 bucket the frontend pipeline syncs to |
| `cloudfront_distribution_id` | Used by the frontend pipeline to invalidate cache |
| `redis_endpoint` | Redis host for the backend |
| `app_log_group` | CloudWatch log group |

Generate the grading JSON:

```bash
terraform output -json > grading.json
```

## CI/CD

`.github/workflows/infrastructure-deploy.yml`:

- **On pull request** (changes under `terraform/`): runs `init`, `validate`, `plan`, and posts the plan as a PR comment.
- **On merge to `main`**: runs `terraform apply`.

Required GitHub repo secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.

## Security

- **No secrets in git.** The MongoDB URI is passed as a Terraform variable and stored in **SSM Parameter Store** as a `SecureString`; EC2 reads it at boot. `terraform.tfvars` is gitignored.
- **Least-privilege IAM.** The EC2 role can only write to its own CloudWatch log group and read its own SSM parameters.
- **Network isolation.** Backend instances and Redis live in **private subnets**. Only the ALB is public. Redis only accepts traffic from the backend security group.
- **Private S3.** The frontend bucket is not public; CloudFront reads it via Origin Access Control.

## Cost & teardown

⚠️ EC2, NAT Gateway, ALB, and ElastiCache incur ongoing charges (~$5–8/day if left running). **Always tear down when done:**

```bash
cd terraform
terraform destroy
```

Confirm in the AWS console that the NAT Gateway, ALB, ASG instances, and Redis cluster are gone (these are the costly ones).
