# Terraform Azure Infrastructure

이 프로젝트는 Azure 인프라를 Terraform으로 관리하는 프로젝트입니다.

## 구조

```
├── environments/
│   └── dev/                 # 개발 환경
│       ├── main.tf         # 메인 Terraform 설정
│       ├── variables.tf    # 변수 정의
│       ├── terraform.tfvars # 변수 값
│       ├── backend.tf      # 백엔드 설정
│       └── outputs.tf      # 출력 값
├── modules/
│   ├── resource_group/     # 리소스 그룹 모듈
│   ├── network/           # 네트워크 모듈
│   └── vm/                # 가상머신 모듈
└── .github/workflows/
    └── terraform.yml      # GitHub Actions 워크플로우
```

## GitHub Actions 설정

### 필요한 Secrets

GitHub Repository의 Settings > Secrets and variables > Actions에서 다음 secrets를 설정해야 합니다:

1. **AZURE_CLIENT_ID**: Azure Service Principal의 Client ID
2. **AZURE_SUBSCRIPTION_ID**: Azure 구독 ID
3. **AZURE_TENANT_ID**: Azure Tenant ID
4. **AZURE_STORAGE_ACCESS_KEY**: Terraform 상태 저장용 Storage Account의 Access Key

### Azure Service Principal 생성

```bash
# Azure CLI로 로그인
az login

# Service Principal 생성
az ad sp create-for-rbac --name "terraform-github-actions" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
```

### Storage Account 설정

Terraform 상태를 저장할 Storage Account가 필요합니다:

```bash
# Storage Account 생성 (이미 존재하는 경우 생략)
az storage account create \
  --name tfstatestorage123 \
  --resource-group tf-backend-rg \
  --location koreacentral \
  --sku Standard_LRS

# Container 생성
az storage container create \
  --name tfstate \
  --account-name tfstatestorage123

# Access Key 확인
az storage account keys list \
  --account-name tfstatestorage123 \
  --resource-group tf-backend-rg
```

## 사용법

### 로컬에서 실행

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### GitHub Actions를 통한 배포

1. main 브랜치에 push하면 자동으로 배포됩니다
2. Pull Request를 생성하면 Plan 결과가 PR에 코멘트로 추가됩니다
3. 수동 실행은 GitHub Actions 탭에서 가능합니다

## 주의사항

- `admin_password`는 실제 환경에서는 더 안전한 방법으로 관리해야 합니다
