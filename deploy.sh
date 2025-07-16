#!/bin/bash
set -e

echo "[1] 이슈 텍스트 파싱 → terraform.tfvars 생성"
bash scripts/parse-issue-to-tfvars.sh local_test.txt > environments/dev/tfvars/terraform.tfvars

echo "[2] 민감 정보 추가"
echo 'admin_password = "azureuser1234!@#$"' >> environments/dev/tfvars/terraform.tfvars

echo "[3] Terraform 실행"   
cd environments/dev
terraform init
terraform plan -var-file=tfvars/terraform.tfvars -out=tfplan
terraform apply -auto-approve tfplan
cd ../../
