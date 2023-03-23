# tp-coaching-webforce3

## Installation avec virtualenv

Mettre en place ansible dans la VM, si ce n'est pas deja fait
Nous allons créer un virtualenv python pour installer la derniere version 
d'Ansible.

```shell
    cd ~/tp-coaching-webforce3
    c  # set up the module venv in the directory venv
    source venv/bin/activate  # activate the virtualenv python
    pip3 install wheel  # set for permissions purpose
    pip3 install --upgrade pip # update pip3
    pip3 install ansible # install ansible 
    pip3 install requests # extra packages
    pip3 install natsort # require for an ansible filter
    ansible --version # check the version number
```
