# wke-gcp-vm



## Getting started

```bash
# initailser la ressource
terraform init
# montrer les action qui seront executer pour passer de l'etat actuel à l'etat desirée
terraform plan -var-file="terraform.tfvars"
# appliquer pour passer à l'etat desiré
terraform apply -var-file="terraform.tfvars"
# voir l'etat actuel de l'infrastructure
terraform show
# comparer l'etat actual avec le nouvel etat configuré
terraform plan -var-file="terraform.tfvars"
# detruire la ressource actuel
terraform destroy
```