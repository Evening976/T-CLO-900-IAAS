T-CLO-900-IAAS
├─ terraform/
│ ├─ backend.tf
│ ├─ main.tf
│ ├─ variables.tf
│ ├─ outputs.tf
│ └─ modules/
│ ├─ network/
│ │ ├─ main.tf
│ │ └─ variables.tf
│ └─ vm/
│ ├─ main.tf
│ └─ variables.tf
├─ ansible/
│ ├─ inventories/
│ │ └─ hosts.ini (généré)
│ ├─ playbooks/
│ │ ├─ bootstrap.yml
│ │ ├─ gitlab.yml
│ │ └─ k8s-cluster.yml
│ ├─ roles/
│ │ ├─ common/
│ │ │ └─ tasks/main.yml
│ │ ├─ kube-common/
│ │ │ └─ tasks/main.yml
│ │ ├─ kube-master/
│ │ │ └─ tasks/main.yml
│ │ ├─ kube-worker/
│ │ │ └─ tasks/main.yml
│ │ └─ gitlab/
│ │ └─ tasks/main.yml
│ └─ group_vars/
│ └─ all.yml
├─ scripts/
│ └─ tf_to_ansible_inventory.py
├─ .gitignore
├─ README.md
└─ .gitlab-ci.yml


## Étapes de déploiement
1. Initialiser Terraform :
   ```bash
   terraform init
   terraform plan -out plan.tfplan
   terraform apply plan.tfplan
   ```
2. Exporter les outputs Terraform pour Ansible :
   ```bash
   terraform output -json > ../scripts/tf_out.json
   ```
3. Générer l'inventaire Ansible :
   ```bash
   cd ../scripts
   python3 tf_to_ansible_inventory.py tf_out.json > ../ansible/inventories/hosts.ini
   ```