# vpc

EKS용 VPC 모듈. public/private 서브넷을 AZ마다 하나씩 만들고, private 서브넷은 NAT Gateway를 통해 외부로 나간다.
서브넷에는 AWS Load Balancer Controller가 인식하는 `kubernetes.io/role/*` 태그가 붙는다.

## 입력

| 이름 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `name` | string | - | 리소스 이름 접두사 |
| `cluster_name` | string | - | 서브넷 태그에 쓸 EKS 클러스터 이름 |
| `cidr` | string | - | VPC CIDR |
| `azs` | list(string) | - | 가용 영역 (2개 이상) |
| `public_subnet_cidrs` | list(string) | - | AZ 순서의 public 서브넷 CIDR |
| `private_subnet_cidrs` | list(string) | - | AZ 순서의 private 서브넷 CIDR |
| `single_nat_gateway` | bool | `true` | NAT Gateway 1개만 생성 |

## 출력

| 이름 | 설명 |
|---|---|
| `vpc_id` | VPC ID |
| `vpc_cidr_block` | VPC CIDR |
| `public_subnet_ids` | public 서브넷 ID 목록 |
| `private_subnet_ids` | private 서브넷 ID 목록 |
| `nat_public_ips` | NAT Gateway 공인 IP 목록 |
