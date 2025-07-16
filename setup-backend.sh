#!/bin/bash

echo "🚀 Terraform Backend 설정을 시작합니다..."

# Azure CLI 로그인 확인
if ! az account show &> /dev/null; then
    echo "❌ Azure CLI에 로그인되어 있지 않습니다."
    echo "다음 명령어로 로그인해주세요:"
    echo "az login"
    exit 1
fi

echo "✅ Azure CLI 로그인 확인됨"

# Bootstrap 디렉토리로 이동
cd bootstrap

echo "📦 Bootstrap Terraform 초기화..."
terraform init

echo "📋 Bootstrap Plan 실행..."
terraform plan

echo "🔧 Bootstrap Apply 실행..."
terraform apply -auto-approve

echo "🔑 Storage Account Access Key 확인..."
ACCESS_KEY=$(terraform output -raw storage_account_key)

echo "✅ Backend 설정 완료!"
echo ""
echo "📝 다음 단계:"
echo "1. GitHub Repository의 Settings → Secrets and variables → Actions로 이동"
echo "2. 'AZURE_STORAGE_ACCESS_KEY' secret을 추가하고 다음 값을 입력:"
echo "   $ACCESS_KEY"
echo ""
echo "3. 그 후 environments/dev 디렉토리에서 terraform init을 실행하세요" 