Role: docker-purge-function
===========================

This role is written in a "Module/Function" way :
- docker-purge-function/deploy: which will install the purge script and install a cron job
- docker-purge-function/remove: which will remove the script and the cron job.

Deployment
------------

Installation is done by including the role `docker-purge-function/deploy` as can be seen :

```
-- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-function/deploy }
```
*fig1: playbook\install_docker_purge.yml*

Removal
-------

To remove the docker purge include the role `docker-purge-function/remove` as can be seen :

```
-- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-function/remove }
```

*fig2: playbook\remove_docker_purge.yml*
