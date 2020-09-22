# test-terraform-functions
### initialise working directory and other config
 - terraform init 
### generate tfplan
 - echo terraform plan -out=tfplan -input=false \ >> tf-plan.sh
 - cat tf-plan.sh
 - source tf-plan.sh
### terraform plan/apply
 - echo terraform apply -input=false -lock=false tfplan \ >> tf-apply.sh
 - cat tf-apply.sh
 - source tf-apply.sh
### start an interactive environment 
 - terraform console 
