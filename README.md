Ansible role layout
===================

In starting to write roles for ansible, I wanted to do things "right" and in an
ansible way. The way I see things, ansible playbooks are a list of plays - these
are custom to the environment you are running.

Roles are a way of grouping disparate tasks to form a single goal - much like
functions build a module.

So I try to write roles so that :

- They are idempodent
- They can be tested independently
- They can revert all changes they make

While I had been told to use tags and other items, I have also read that adding
tags make things "more complex" in the invocation of a playbook. In the limited
use I have had for tags - I tend to agree.

So I have two roles, that do the same simple changes :

- install a script from a file
- Add a cron job that runs the script

and conversly:

- remove the cron job
- delete the script

I will also try and adapt these for more complex roles, but for now this is really
just a proof of concept to get some feedback.

Role with functions
-------------------

The first method is to develop the role as "functions". I use the term functions
loosely, because this structure reminds me of module and function. In this case,
I have a `deploy` task list and a `remove` task list. They can be called :

```
- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-function/deploy }
```

The reason I like this is that I can break down all "tasks groups" of a role into
these modules - for example "create user", "create directories", etc. This would
also allow the agregation of "tasks" into common playbooks - eg: "create users".
What I don't like is that each of these "functions" have to be placed in a
subdirectory, and you must know the name.

this can be seen in the `docker-purge-function` directory.

Role with state
---------------

After a discussion at an ansible meetup, it was critisized as thinking of tasks
while I should be thinking of states. While I know modules can have state, I have
not seen roles with state - but it does make sense. The deploymnet and removal
becomes a state change:


```
- name: Deploy docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-state, state: "present" }
```

To install the role (make sure it is present) And

```
- name: Remove docker purge on all docker nodes.
  hosts:
    - all
  roles:
    - { role: docker-purge-state, state: "absent" }
```

To remove the role and make sure it is absent.

The can be as small as a single file, and it all stays at the root level of the
role. The selection of what tasks are run is done with the :

```
  when: "state == 'present'"
```

these files could also be included.

Running the test
----------------

### Overview

The tests are controlled through the makefile, typing ```make``` will show its
usage.

```
make
# help                 Prints out this help message
# vm                   Creates the vm for testing, sets up for ansible.
# play                 Runs tthe installation playbook.
# remove               Runs the un-install playbook
# clean                Will destory the VM
```

### Walkthrough

The following steps are to run the test:

```
make vm
```

This will do some preparation work, and run ```vagrant up``` using the ```setup.yml```
playbook. This vagrant file creates an extra interface so we don't need to use
anything special for ssh. The playbook, will dump the IP of that interface inventory
an inventory file, and copy the users public key to the root authorized_key file.

```
make play
```

This will execute the install-docker-purge playbook which will install two
variations fo the docker purge - once via the fucntion method and once via the
state method.

```
make remove
```

This will execute the remove-docker-purge playbook twice - once via the fucntion
method and once via the state method.

```
make clean
```

make clean will destroy the vm and delete the inventory file.

```
make all
```

This is meant to be run-it-all - it will destroy, make, provision and test the
vm.

The ultimate goal is get a True/False  exit code, so that we can run this as a
test case inside a pipeline (see: test-kitchen). It should actually destroy the VM
if the tests passed.
