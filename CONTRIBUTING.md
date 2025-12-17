# Contributing.md

## Pre-requisites

### 1. Pre-commit
To use `pre-commit` use the following steps:
    - Check for installed version of `pre-commit` using `pre-commit --version`, If no version found install precommit using `brew install pre-commit`
    - Run `pre-commit` in the repo 

#### Infracost breakdown
To allow infracost breakdown to work you will need to register an account [here](https://www.infracost.io/docs/#quick-start)
    - Login to infracost using `infracost auth login`
    - Run infracost based path `infracost breakdown --path .`

### 1. AWS setup
Install or upgrade to latest version of `aws cli` [link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - `brew install awscli`
    - AWS CLI tutorial [Link](https://medium.com/@amiri.mccain/install-aws-cli-and-configure-credentials-and-config-files-on-a-mac-cda81cf64052)
    - AWS terragrunt tutorial [Link](https://www.youtube.com/watch?v=yduHaOj3XMg&t=1426s)

To bootstrap the repo you will need to create the following roles via the AWS console.
1. Create a group `devops`, these will house all the `Users`.
1. Create a policy `AllowTerraform`, this will allow both access to the `terraform state bucket` and use `terraform-role`.
    - Attach `AllowTerraform` policy to the `devops` group, this will give all users in the group access to assume the role
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBackendAccess",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-state-bucket-1338",
                "arn:aws:s3:::terraform-state-bucket-1338/*"
            ]
        },
        {
            "Sid": "AllowAssumingDeploymentRoles",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::<YOUR_AWS_ACCOUNT>:role/terraform-role"
            ]
        }
    ]
}
```
1. Create a role `terraform-role`, and attach the `AdministratorAccess` policy.
    - This will allow the `terraform-role` the abiltiy to spin infrastructure.
    - Edit the trust policy of `terraform-role` to allow the aws account to use it.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": { "AWS": "arn:aws:iam::<YOUR_AWS_ACCOUNT>:root" },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
```

- Logging in as user  
    - Add the AWS access keys via command `aws configure`, and key in the `access key` and `secret access key`.
        - View config details using `aws configure list`
    - Verify whoami in aws using `aws sts get-caller-identity`, this should show your user
    - Learn about aws config files [here](https://ben11kehoe.medium.com/aws-configuration-files-explained-9a7ea7a5b42e)

## 1. Applying Infrastructure changes
1. Enter the module that you wish to work on `cd live/dev/module-name`
1. Once there do a `terragrunt init` and `terragrunt plan`

