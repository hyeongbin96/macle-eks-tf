# eks-node-group

EKS 관리형 노드 그룹 모듈. 노드 IAM 역할 하나를 모든 노드 그룹이 같이 쓰고, 노드 그룹마다 Launch Template을 하나씩 만든다.

- Launch Template에서 IMDSv2를 필수로 켜고(hop limit 2), 루트 볼륨은 gp3로 암호화한다.
- 노드에는 별도 보안 그룹을 지정하지 않는다. 그래서 EKS가 만든 클러스터 보안 그룹이 그대로 적용된다.
- 노드에 SSH 대신 SSM Session Manager로 접속할 수 있다(`AmazonSSMManagedInstanceCore`).
- `desired_size`는 Terraform이 무시한다(`ignore_changes`). 처음 생성한 뒤에 바꾸려면 콘솔이나 오토스케일러를 쓴다.

## 입력

| 이름 | 타입 | 설명 |
|---|---|---|
| `cluster_name` | string | 클러스터 이름 |
| `kubernetes_version` | string | 노드 Kubernetes 버전 |
| `subnet_ids` | list(string) | 노드 서브넷 |
| `node_groups` | map(object) | 노드 그룹 정의 (아래 참고) |

`node_groups` 항목 필드: `instance_types`, `desired_size`, `min_size`, `max_size`,
`capacity_type` (기본 `ON_DEMAND`), `ami_type` (기본 `AL2023_x86_64_STANDARD`), `disk_size` (기본 30), `labels` (기본 `{}`),
`release_version` (AMI 고정, 예 `1.37.0-20261012`. 비우면 생성 시점의 최신 AMI)

## 출력

| 이름 | 설명 |
|---|---|
| `node_role_arn` | 노드 IAM 역할 ARN |
| `node_groups` | 노드 그룹별 `{ name, arn }` |
