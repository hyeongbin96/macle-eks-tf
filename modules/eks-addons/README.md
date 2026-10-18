# eks-addons

EKS 관리형 애드온 모듈. 설치할 애드온과 버전을 호출하는 쪽에서 **고정해서** 넘긴다.
버전을 자동으로 고르지 않으므로, tfvars를 고치지 않는 한 애드온은 업데이트되지 않는다.

- 클러스터를 만들 때 기본으로 깔리는 self-managed 애드온(vpc-cni, kube-proxy, coredns)은 `OVERWRITE`로 관리형 애드온에 흡수된다.
- coredns는 노드가 있어야 Active 상태가 된다. 그래서 루트 모듈에서는 노드 그룹을 만든 뒤에 이 모듈을 호출한다(`depends_on`).

## 버전 확인

```
aws eks describe-addon-versions --kubernetes-version 1.37 --addon-name coredns \
  --query "addons[].addonVersions[].addonVersion"
```

또는 AWS 문서의 애드온별 버전 표를 확인한다: vpc-cni, kube-proxy, coredns 관리 페이지.

> **클러스터 버전을 올릴 때는 애드온 버전도 직접 함께 올려야 한다.** 특히 kube-proxy는 클러스터 마이너 버전과 맞춰야 한다.

## 입력

| 이름 | 타입 | 설명 |
|---|---|---|
| `cluster_name` | string | 클러스터 이름 |
| `addons` | map(object({ version = string })) | 애드온 이름 → 고정 버전 (`vX.Y.Z-eksbuild.N`) |

## 출력

| 이름 | 설명 |
|---|---|
| `addon_versions` | 애드온별 설치 버전 |
