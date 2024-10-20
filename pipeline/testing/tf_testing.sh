cd pipeline/testing
terraform init
terraform apply -auto-approve \
  -var folder_id="$YC_FOLDER_ID" \
  -var service_account_key_file="$YC_ACCOUNT_KEY_FILE" \
  -var ssh_public_key="$SSH_PUBLIC_KEY"
terraform show terraform.tfstate \
| grep instance_public_ip | awk -F'\"' '{print $2}' > ../../do_ip.txt
