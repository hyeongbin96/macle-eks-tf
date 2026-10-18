# Terraform 작업 규칙

이 저장소는 Terraform으로 인프라를 관리한다. 코드를 작성·수정할 때 아래 규칙을 따른다.

## 버전

- Terraform CLI: `>= 1.10, < 2.0`
- Provider는 `required_providers`에 반드시 명시하고 `~>`로 메이저 버전을 고정한다.

```hcl
terraform {
  required_version = ">= 1.10, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

- `.terraform.lock.hcl`은 커밋한다. 버전 업그레이드는 별도 작업으로 분리한다 (`terraform init -upgrade`).
- **리소스 인자를 기억에 의존해 쓰지 않는다.** 확실하지 않은 리소스·인자·모듈은 Terraform MCP 서버로 고정된 provider 버전의 문서를 먼저 조회한다.

## 디렉터리 구조

```
modules/<module-name>/      # 재사용 모듈: main.tf, variables.tf, outputs.tf, versions.tf, README.md
envs/<env>/                 # dev, stg, prod — 환경별 루트 모듈, backend 설정 포함
```

- 루트 모듈 파일 분리: `versions.tf`, `providers.tf`, `backend.tf`, `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`
- 환경 간 차이는 변수(`terraform.tfvars`)로만 표현하고, 코드 복붙으로 환경을 나누지 않는다.

## 네이밍

- Terraform 식별자(리소스·변수·출력·로컬): `snake_case`, 소문자
- 리소스 이름에 타입을 반복하지 않는다: `aws_s3_bucket.logs` (O) / `aws_s3_bucket.logs_bucket` (X)
- 리소스가 하나뿐이면 `this` 또는 `main`을 쓴다.
- 클라우드 리소스 실제 이름: `<project>-<env>-<component>` (예: `myapp-prod-api`), 하이픈 구분
- 변수 이름에 단위/형태를 드러낸다: `retention_days`, `enable_logging`, `subnet_ids`
- 모든 리소스에 공통 태그를 붙인다 (`default_tags` 사용):

```hcl
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
```

## 코드 작성 규칙

- 모든 `variable`에 `type`과 `description`을 쓴다. 가능하면 `validation` 블록을 추가한다.
- 모든 `output`에 `description`을 쓴다. 민감 값은 `sensitive = true`.
- 반복은 `count`보다 `for_each`를 우선한다 (키 기반이라 순서 변경 시 재생성이 없다).
- 하드코딩 금지: 리전, 계정 ID, AMI ID 등은 변수 또는 `data` 소스로 받는다.
- 시크릿을 코드·tfvars에 넣지 않는다. Secrets Manager/SSM 등에서 `data`로 읽는다.
- state는 원격 backend(S3 + 잠금 등)를 사용한다. 로컬 state 파일을 만들거나 커밋하지 않는다.

## 검증 순서

코드를 수정한 뒤 아래 순서로 실행하고, 실패하면 고친 뒤 처음부터 다시 실행한다.

1. `terraform fmt -recursive`
2. `terraform init -backend=false` (최초 또는 provider 변경 시)
3. `terraform validate`
4. `tflint --recursive`
5. `checkov -d .` 또는 `trivy config .` (보안 검사)
6. `terraform plan -out=tfplan` — 변경 요약(추가/변경/삭제 수)을 보고한다. **삭제(destroy)나 재생성(-/+)이 포함되면 반드시 명시한다.**

## 금지 사항

- `terraform apply`, `terraform destroy`, `terraform state rm/mv`, `terraform import`는 사용자의 명시적 승인 없이 실행하지 않는다.
- `-auto-approve`를 쓰지 않는다.
- `*.tfstate`, `*.tfvars`(시크릿 포함 시), `.terraform/`, `tfplan`은 커밋하지 않는다.
