infra:
	git pull
	terraform init
	terraform apply -auto-approve

ansible:
	git pull
	ansible-playbook -i $(tool_name)-internal.ro-bot.store, setup-tool.yml -e ansible_user=ec2-user -e ansible_password=DevOps321 -e tool_name=$(tool_name)