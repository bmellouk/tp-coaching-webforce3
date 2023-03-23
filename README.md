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

## TP ansible 1 

Dans une sous directory de votre projet tp-coaching-webforce3 nommée **ansible**   
Créer un fichier ansible-1.yaml qui automatise l'exercice 2 ci-dessus.  
1. Le script doit mettre à jour les packages ubuntu.   
2. Vérifier la version de python3  
3. Créer un alias dans ~/.bashrc  
4. installer le package pip

```YAML
---
- name: Mettre a jour les packages ubuntu/ Vérifier la version de python3/ Créer un alias dans ~/.bashrc / Installer le package pip
  hosts: localhost
  become: true

  tasks:
    - name: Mettre a jour les packages ubuntu
      ansible.builtin.apt:
        update_cache: yes
        upgrade: dist

    - name:  Vérifier la version de python3
      command: python3 --version
      register: python_version
      changed_when: false

    - name: Créer un alias dans ~/.bashrc
      ansible.builtin.lineinfile:
        dest: ~/.bashrc
        line: 'alias python="python3"'
        state: present

    - name: Installer le package pip
      ansible.builtin.apt:
        name: python3-pip
        state: latest
```
    
## TP ansible 2 
Dans une sous directory de votre projet tp-coaching-webforce3 nommée **ansible**   

Trouvez le fichier ansible-2-filtre.yml qui affiche les devices en mode raw

```YAML
    ---
- name: format disk
  become: true # donne les privileges administratifs pour effectuer les opérations
  hosts: localhost
  
  tasks:
    - name: get disk structure
      command: fdisk -l # obtenir la structure des disques
      register: get_disk # enregistrer la sortie dans une variable appelée get_disk
      
    - name: pour la mise au point
      debug:
        msg: " device : {{ get_disk.stdout | get_device }}"
        # cette tache utilise le filtre get_device pour extraire le nom du périphérique à partir de fdisk et va l'afficher grace a la commande Debug
```
