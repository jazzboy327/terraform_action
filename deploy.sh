#!/bin/bash
set -e

echo "[1] 이슈 텍스트 파싱 → terraform.tfvars 생성"
bash scripts/parse-issue-to-tfvars.sh issue_test.txt > teams/dev1/terraform.tfvars

echo "[2] 민감 정보 추가"
echo 'admin_password = "azureuser1234!@#$"' >> teams/dev1/terraform.tfvars

echo "[3] Terraform 실행"   
cd teams/dev1
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
cd ../../
