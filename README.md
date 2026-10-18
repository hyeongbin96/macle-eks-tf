# macle 인프라

사내 웹 서비스용 AWS EKS 인프라 (ap-northeast-2).

## 구조

```
bootstrap/              state용 S3 버킷 (로컬 state, 최초 1회)
modules/
  vpc/                  VPC, 서브넷, NAT
  eks-cluster/          EKS 컨트롤 플레인, IAM, KMS, OIDC, Access Entry
  eks-node-group/       관리형 노드 그룹
  eks-addons/           vpc-cni, kube-proxy, coredns, eks-pod-identity-agent
envs/
  dev/                  DEV 환경 루트 모듈
```

실행 흐름과 파일 참조 관계 도식: [docs/terraform-flow.html](docs/terraform-flow.html) (브라우저로 열기)

## 사전 준비

- Terraform `>= 1.10`
- AWS CLI와 자격 증명 (`aws configure` 또는 `aws sso login`)

## 최초 배포 순서

0. **tfvars 준비**: `terraform.tfvars`는 git에서 제외됩니다. 각 디렉터리의 예시 파일을 복사해서 씁니다.
   ```
   copy bootstrap\terraform.tfvars.example bootstrap\terraform.tfvars
   copy envs\dev\terraform.tfvars.example envs\dev\terraform.tfvars
   ```

1. **state 버킷 생성**
   ```
   cd bootstrap
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
   출력된 `state_bucket_name`을 메모한다.

2. **dev 설정**
   - `envs/dev/backend.tf`: `bucket`을 위에서 메모한 버킷 이름으로 바꾼다.
   - `envs/dev/terraform.tfvars`: `public_access_cidrs`에 내 공인 IP를 넣고, 필요하면 `admin_principal_arns`도 채운다.

3. **dev 배포**
   ```
   cd envs/dev
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

4. **kubectl 연결**: `terraform output configure_kubectl`에 나온 명령을 실행한다.

## 버전 관리와 업그레이드

자동 업그레이드는 쓰지 않습니다. 모든 버전을 `envs/<env>/terraform.tfvars`에 고정하고, 사람이 직접 올립니다.

| 대상 | 고정 위치 | 비고 |
|---|---|---|
| 컨트롤 플레인 | `kubernetes_version` | `cluster_support_type = "EXTENDED"`가 안전망 역할을 함 (아래 참고) |
| 애드온 | `addons` | `aws eks describe-addon-versions`로 확인 |
| 노드 AMI | `node_groups.*.release_version` | [amazon-eks-ami releases](https://github.com/awslabs/amazon-eks-ami/releases) |

EKS는 컨트롤 플레인 자동 업그레이드를 완전히 끌 수 없습니다. `EXTENDED`로 두면 표준 지원 종료 후 12개월 동안 강제 업그레이드가 미뤄지고, 그 기간에는 추가 요금이 붙습니다. 목표는 그 기간에 들어가기 전에 직접 업그레이드하는 것입니다.

### 업그레이드 절차 (마이너 버전 1단계씩)

1. 표준 지원 종료 3~4개월 전에 일정을 잡습니다. 1.37은 2027-12-01에 종료됩니다.
2. EKS 콘솔의 **Upgrade Insights**에서 삭제 예정 API를 쓰는 곳이 있는지 확인합니다.
3. tfvars를 수정합니다: `kubernetes_version` +1, 새 버전과 호환되는 `addons` 버전, 새 버전용 `release_version`.
4. `terraform plan`을 검토합니다. 컨트롤 플레인, 애드온, 노드 그룹 업데이트만 있어야 하고, 재생성(-/+)이 있으면 안 됩니다.
5. dev → stg → prod 순서로 apply합니다. 노드는 롤링 교체되므로 워크로드에 PodDisruptionBudget을 설정해 둡니다.

## 비용 참고 (dev)

비용이 드는 주요 항목은 EKS 컨트롤 플레인, NAT Gateway 1개, t3.medium 노드 2대, CloudWatch 로그다.
쓰지 않을 때는 노드 그룹의 `min_size`/`desired_size`를 0으로 줄이면 비용을 아낄 수 있다.
