.PHONY: help

export ANSIBLE_HOST_KEY_CHECKING=False

help: ## Prints out this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "# \033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: clean vm play test

vm: ## Creates the vm for testing, sets up for ansible.
	@rm -f inventory
	@vagrant up
	@ansible all -i inventory -u root -m ping

play: ## Runs tthe installation playbook.
	@ansible-playbook -i inventory -u root playbooks/install_docker_purge.yml

remove: ## Runs the un-install playbook
	@ansible-playbook -i inventory -u root playbooks/remove_docker_purge.yml

clean: ## Will destory the VM
	@vagrant destroy -f
	@rm -f inventory
