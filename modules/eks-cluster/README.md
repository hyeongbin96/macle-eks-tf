# eks-cluster

EKS 컨트롤 플레인 모듈. 클러스터 IAM 역할, Secret 암호화용 KMS 키, 컨트롤 플레인 로그 그룹, IRSA용 OIDC Provider, 관리자 Access Entry를 함께 만든다.

- 인증 모드는 `API`다. aws-auth ConfigMap 없이 Access Entry로만 접근을 관리한다.
- API 엔드포인트는 Public과 Private를 모두 연다. Public 쪽은 `public_access_cidrs`로 접근을 제한한다.
- 업그레이드 정책 기본값은 `STANDARD`다. 표준 지원이 끝나면 자동으로 업그레이드되고, 연장 지원 비용은 발생하지 않는다.

## 입력

| 이름 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `cluster_name` | string | - | 클러스터 이름 |
| `kubernetes_version` | string | - | Kubernetes 버전 |
| `subnet_ids` | list(string) | - | 컨트롤 플레인 ENI 서브넷 |
| `public_access_cidrs` | list(string) | - | Public 엔드포인트 허용 CIDR (`0.0.0.0/0` 금지) |
| `admin_principal_arns` | list(string) | `[]` | 관리자 권한 IAM ARN (생성자 제외) |
| `bootstrap_cluster_creator_admin_permissions` | bool | `true` | 생성자에게 관리자 권한 자동 부여 |
| `enabled_log_types` | list(string) | `["api","audit","authenticator"]` | 컨트롤 플레인 로그 |
| `log_retention_days` | number | `30` | 로그 보존 기간 |
| `kms_deletion_window_in_days` | number | `7` | KMS 키 삭제 대기 기간 |
| `support_type` | string | `"STANDARD"` | 업그레이드 정책 |

## 출력

`cluster_name`, `cluster_arn`, `cluster_version`, `cluster_endpoint`, `cluster_certificate_authority_data`,
`cluster_security_group_id`, `oidc_provider_arn`, `oidc_issuer_url`, `kms_key_arn`
