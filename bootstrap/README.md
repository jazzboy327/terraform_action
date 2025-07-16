# Terraform Backend Bootstrap

이 디렉토리는 Terraform 상태를 저장할 Azure Storage Account를 생성하는 bootstrap 스크립트입니다.

## 실행 방법

### 1. Azure CLI 로그인
```bash
az login
```

### 2. Bootstrap 실행
```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

### 3. Storage Account Access Key 확인
```bash
terraform output storage_account_key
```

### 4. GitHub Secrets 설정
생성된 Access Key를 GitHub Repository의 Secrets에 설정:

1. GitHub Repository → Settings → Secrets and variables → Actions
2. `AZURE_STORAGE_ACCESS_KEY` secret 추가
3. 위에서 출력된 Access Key 값을 입력

## 주의사항

- 이 스크립트는 한 번만 실행하면 됩니다
- Storage Account 이름은 전역적으로 고유해야 합니다
- Access Key는 안전하게 보관해야 합니다 