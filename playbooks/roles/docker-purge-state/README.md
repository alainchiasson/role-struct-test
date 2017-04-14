Role: docker-purge-state
========================

This role is written in a "Ansible-onic" :
 - state='present' : which will install the purge script and install a cron job
 - state='absent' : which will remove the script and the cron job.

Deployment
------------

Installation is done by including the role `docker-purge-state` as can be seen :

```
-- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-state, state: "present" }
```
*fig1: playbook\install_docker_purge.yml*

Removal
-------

To remove the docker purge include the role `docker-purge/remove` as can be seen :

```
-- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-state, state: "absent" }
```

*fig2: playbook\remove_docker_purge.yml*
