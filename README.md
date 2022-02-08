## terraform-cloudops POC

# Dependencies
terraform >= 0.12

Use this commands to quick deploy:
```
terraform init
terraform plan
terraform apply
```

# Notes
Noticed that you maybe need AWS Sandbox or Cloud Account, in variables.tf there are comments how to set AWS credentials

You can also use this oneline command:
```
cd terraform-cloudops/infra/backend && rm -rf .terraform && terraform init && terraform plan && terraform apply -auto-approve
```