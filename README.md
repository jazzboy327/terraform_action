# Terraform Azure Infrastructure Automation

이 프로젝트는 **GitHub Issue 기반 자동화**를 통해 Azure 인프라를 Terraform으로 관리하는 프로젝트입니다.

## 🚀 자동화 프로세스

```
1. 사용자가 GitHub Issue 템플릿으로 리소스 요청
        ↓
2. GitHub Actions가 Issue 내용을 파싱
        ↓
3. teams/<팀명>/terraform.tfvars, main.tf 생성 + 자동 PR 생성
        ↓
4. 팀 리더 또는 승인자가 PR 리뷰 → Merge
        ↓
5. GitHub Actions가 terraform apply
```

## 📁 프로젝트 구조

```
terraform_action/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   └── infra-request.yml          # 인프라 요청 Issue 템플릿
│   └── workflows/
│       ├── issue-to-pr.yml            # Issue → PR 자동 생성
│       └── terraform-deploy.yaml      # PR Merge → Terraform Apply
│
├── modules/                           # 재사용 가능한 Terraform 모듈
│   ├── vm/
│   │   ├── main.tf                    # VM 리소스 정의
│   │   ├── variables.tf               # VM 모듈 입력 변수
│   │   └── outputs.tf                 # VM 모듈 출력값
│   ├── network/
│   │   ├── main.tf                    # VNet, Subnet 리소스
│   │   ├── variables.tf               # Network 모듈 입력 변수
│   │   └── outputs.tf                 # Network 모듈 출력값 (subnet_id 등)
│   ├── resource_group/
│   │   ├── main.tf                    # Resource Group 리소스
│   │   ├── variables.tf               # RG 모듈 입력 변수
│   │   └── outputs.tf                 # RG 모듈 출력값
│   └── policy/                        # Azure Policy 모듈
│
├── teams/                             # 팀별 Terraform 설정 (자동 생성)
│   ├── dev0/
│   │   ├── main.tf                    # 팀별 Terraform 설정
│   │   ├── variables.tf               # 팀별 변수 정의
│   │   ├── terraform.tfvars           # 팀별 변수값
│   │   ├── outputs.tf                 # 팀별 출력값
│   │   ├── backend.tf                 # 상태 파일 설정
│   │   └── issue.txt                  # 이슈 내용
│   ├── dev1/
│   │   └── ... (동일한 구조)
│   └── ... (dev2~dev20)
│
├── scripts/
│   ├── parse-issue-to-tfvars.sh       # Issue 파싱 스크립트
│   └── create_team_tf.sh              # 팀별 Terraform 파일 생성
├── template/                          # 팀별 디렉토리 템플릿
│   └── outputs.tf
├── bootstrap/                         # 초기 설정 스크립트
├── .gitignore
├── README.md
├── deploy.sh                          # 배포 스크립트
├── setup-backend.sh                   # 백엔드 설정 스크립트
└── issue_test.txt                     # 테스트용 이슈 내용
```

## 🛠️ 사용법

### 1. GitHub Issue로 인프라 요청

1. **New Issue** 클릭
2. **"Terraform 리소스 생성 요청"** 템플릿 선택
3. 아래 양식에 맞춰 정보 입력:

```yaml
- 환경: dev
- 위치: koreacentral
- 리소스 그룹: dev-rg
- VNet: dev-vnet
- CIDR: ["10.0.0.0/16"]
- VM 이름: dev-vm
- VM 크기: Standard_B1s
- 관리자 계정: azureuser
- 서비스명: axd_playground
- 팀명: dev1
```

4. **Submit new issue** 클릭

### 2. 자동 PR 생성 확인

- Issue 생성 후 **GitHub Actions**가 자동으로 실행됩니다
- `teams/dev1/` 디렉토리에 Terraform 파일들이 자동 생성됩니다
- **Pull Request**가 자동으로 생성됩니다

### 3. PR 리뷰 및 Merge

- 생성된 PR을 리뷰합니다
- 승인 후 **Merge**합니다
- Merge 시 자동으로 `terraform apply`가 실행됩니다

## ⚙️ 설정

### GitHub Secrets 설정

Repository Settings > Secrets and variables > Actions에서 다음 secrets를 설정:

| Secret 이름 | 설명 |
|-------------|------|
| `AZURE_CLIENT_ID` | Azure Service Principal Client ID |
| `AZURE_SUBSCRIPTION_ID` | Azure 구독 ID |
| `AZURE_TENANT_ID` | Azure Tenant ID |
| `VM_ADMIN_PASSWORD` | VM 관리자 비밀번호 |

### Azure Service Principal 생성

```bash
# Azure CLI 로그인
az login

# Service Principal 생성
az ad sp create-for-rbac --name "terraform-github-actions" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID \
  --sdk-auth
```

### Terraform Backend 설정

```bash
# Storage Account 생성 (필요시)
az storage account create \
  --name tfstatestorage123 \
  --resource-group tf-backend-rg \
  --location koreacentral \
  --sku Standard_LRS

# Container 생성
az storage container create \
  --name tfstate \
  --account-name tfstatestorage123
```

## 🔧 로컬 개발

### 특정 팀 디렉토리에서 작업

```bash
cd teams/dev1
terraform init
terraform plan
terraform apply
```

### 모듈 개발

```bash
cd modules/vm
terraform init
terraform plan
```

## 📋 모듈 설명

### VM 모듈 (`modules/vm/`)
- Azure Linux VM 생성
- Network Interface 자동 생성
- Ubuntu 18.04-LTS 기본 이미지 사용

### Network 모듈 (`modules/network/`)
- Virtual Network 생성
- Subnet 생성
- subnet_id output 제공

### Resource Group 모듈 (`modules/resource_group/`)
- Azure Resource Group 생성
- 태그 관리

## 🔒 보안 고려사항

- **민감 정보**: `admin_password`는 GitHub Secrets로 관리
- **상태 파일**: Terraform 상태는 Azure Storage에 안전하게 저장
- **권한 관리**: Service Principal은 최소 권한 원칙 적용
- **PR 리뷰**: 모든 변경사항은 PR 리뷰를 거쳐야 함

## 🚨 주의사항

1. **Issue 제목**: 반드시 `[Terraform]` 포함해야 워크플로우 실행
2. **팀명**: 중복되지 않는 고유한 팀명 사용
3. **리소스 이름**: Azure 리소스 이름 규칙 준수
4. **비용 관리**: VM 크기와 리소스 사용량 모니터링

## 🐛 문제 해결

### Issue 생성 후 PR이 생성되지 않는 경우
1. Issue 제목에 `[Terraform]` 포함 확인
2. GitHub Actions 로그 확인
3. Issue 내용 형식 확인

### Terraform Apply 실패 시
1. Azure 권한 확인
2. 리소스 이름 중복 확인
3. 네트워크 설정 확인

## 📞 지원

문제가 발생하면:
1. GitHub Issues에서 검색
2. GitHub Actions 로그 확인
3. Azure Portal에서 리소스 상태 확인

---

**이 프로젝트는 Azure 인프라 자동화를 통해 개발팀의 생산성을 향상시키는 것을 목표로 합니다.**
