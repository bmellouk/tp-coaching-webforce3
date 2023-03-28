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

1. Analysez le fichier ansible-2-filtre.yml 

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

#### Le fichier ansible-2-filtre.yml devrait permettre de formater un disque en récupérant sa structure et en affichant le nom du périphérique associé. Cependant, il manque des tâches pour effectuer réellement le formatage du disque.


2. Dans la directory filter_plugins etudier le code de la fonction # get_device #la fonction get_device prend en entrée une liste de péripheriques (list_device)  qui contient des informations sur les disques et les partitions d'un       système .  Elle parcourt les informations, identifie les disques et vérifie leur format. Si un disque a un format non valide, il est ajouté à la liste de sortie.La fonction renvoie cette liste des disques ayant un format non valide.

```Python
from natsort import natsorted
import subprocess
import re
class FilterModule(object):
    def filters(self):
        return {
            'a_filter': self.a_filter,
            'latest_version': self.latest_version,
            'get_device': self.get_device
        }
    def a_filter(self, a_variable):
        a_new_variable = a_variable + ' CRAZY NEW FILTER'
        return a_new_variable
    def latest_version(self, list_of_version):
        array = list_of_version.split("\n")
        sorted = natsorted(array)
        res = sorted[::-1]
        for val in res:
            list_of_version = val
            if len(list_of_version) == 4:
                m = re.search(r'^(v\d{1}.\d{1})', list_of_version)
                if m.group(0):
                    break
       return list_of_version
    def get_device(self, list_device):
           disk = [] #initialiser une liste vide disk
           device = [] #initialiser une liste vide device
           flag = 0 # initialiser une variable "flag" à 0
           type_format = ['swap','ext4','xfs','dos', 'squashfs' ] # contient les noms des formats de système de fichiers que le code doit ignorer.
           line = list_device.split('\n')  #divise chaque chaîne de caractères de la liste "list_device" en une liste de lignes 
           for i in line: #cherche toutes les lignes qui contiennent "Disk /" 
               if 'Disk /' in i:
                  disk.append(i) # en les ajoutant à la liste "disk".
           disk = reversed(disk) # La liste "disk" est inversée.
           for v in disk:
               inter = v.split()
               cmd = "lsblk -f {}".format(inter[1][:-1]) # Permet d'obtenir des informations sur chaque disque,en passant le nom du disque dur comme arg
               check_blk = str(subprocess.check_output(cmd,shell=True)) #La sortie de la commande lsblk est stockée dans la variable check_blk.
               for val in type_format: # Si le format de système de fichiers n'est pas dans la liste "type_format", le périphérique est ajouté à "device"
                   if val in check_blk:
                       flag = 1 # Si le format n'est pas autorisé, la variable flag est mise à 1
               if flag == 0:
                    device.append(inter[1][:-1]) # cette commande extrait le nom du périphérique et l'ajoute à la liste device.
           return device # renvoie la liste "device"
```


3. Regardez egalement le fichier ansible.cfg, mettre des commentaires dans le README.md.
Ce filtre doit etre utilise sur docker-x 

``` shell
[defaults]#section qui contient les options par défaut pour tous les hôtes gérés par Ansible.
deprecation_warnings=False #désactive les avertissements de dépréciation
host_key_checking=False #désactive lla vérification des clés hôtes SSH
ssh_args = -o ControlMaster=auto -o ControlPersist=30m #définit des arguments SSH spécifiques. ControlMaster=auto active la mise en cache des connexions SSH pour améliorer les performances, tandis que ControlPersist=30m conserve la connexion SSH active pendant 30 minutes après la fin de l'exécution d'une tâche pour éviter de rétablir la connexion à chaque fois.
command_warnings=False #désactive les avertissements,si on souhaite exécuter des commandes à distance de manière automatisée sans être interrompu.
pipelining=True #active le "pipelining", une technique qui permet de réduire le nombre de connexions SSH nécessaires pour exécuter une tâche sur un hôte distant, en envoyant plusieurs commandes à la fois via une seule connexion SSH.Améliore les performances.
callback_whitelist = profile_tasks #définit une liste blanche de rappels pour la gestion des tâches.
filter_plugins = filter_plugins #copie la valeur de la variable filter_plugins dans une nouvelle variable portant le même nom, évite de répéter le nom de la variable à chaque fois qu'elle est utilisée.
```


4. Analysez le fichier ansible-2.yml 

```YAML
---
- name: format disk # formater un disque
  become: true # donne les privileges administratifs pour effectuer les opérations
  hosts: almal

  tasks:
    - name: Collect only facts about hardware #Collecte des informations matérielles 
      setup: # spécifie les informations système à collecter 
        gather_subset: #collectera que les informations sur le matériel de l'hôte cible telles que le nb de processeurs, la qté de RAM,les cartes réseau..
          - hardware
    - name: Output disk
      debug: # Affiche les noms des disques disponibles sur l'hôte cible
        var: hostvars[inventory_hostname].ansible_devices.keys() | list
    - name: parted all available disk
      parted: # "parted" pour créer une nouvelle partition sur chaque disque disponible. 
        device: "/dev/{{ item }}" # Le num de partition créé est 1 et l'état de la partition est défini sur "present".
        number: 1
        state: present
      with_items: #  Le nom de chaque disque est déterminé en utilisant une boucle "with_items" qui parcourt la liste des clés du dictionnaire "ansible_devices" de l'hôte cible.
        - "{{ hostvars[inventory_hostname].ansible_devices.keys() | list }}"
      ignore_errors: yes # Ignore les erreurs qui se produisent lors de la création de partitions avec l'option 
```


6. Le script ansible-2-filter.yml ne formate pas le disk. 
7. Ci-dessous le script ansible-2-filter.yaml pour qu'il formate le disque en s'inspirant du script ansible-2.yml 

```YAML

---
- name: format disk
  become: true
  hosts: localhost
  tasks:
    - name: get disk structure
      become: true
      command: fdisk -l
      register: get_disk

    - name: pour la mise au point
      debug:
        msg: " device : {{ get_disk.stdout | get_device }}"

    - name: parted all available disk
      parted:
        device: "/dev/{{ get_disk.stdout | get_device }}"
        number: 1
        state: present
        part_type: primary
        ignore_errors: yes
```

## TP ansible 3 
Dans une sous directory de votre projet tp-coaching-webforce3 nommée **ansible**   
- Créer un fichier ansible-3.yaml qui automatise l'exercice 6 ci-dessus.  
1. activer le firewall d'ubuntu
2. fermer le port 5000
3. ouvrir le port 30101  
Testez votre script


```YAML

---
- name: Activer le firewalld'ubuntu et gerer les ports
  hosts: localhost
  become: true

  tasks:
    - name: Activer le firewall
      ufw:
        state: enabled

    - name: Fermer le port 5000
      ufw:
        rule: deny
        port: 5000

    - name: Ouvrir le port 30101
      ufw:
        rule: allow
        port: 30101
```


## TP ansible 4  inclus maintenant un container almalinux
### Mise en place du container almalinux

le fichier inventory.yaml contient le groupe alma qui contient un container comme ci-dessous
```shell
[alma]
alma ansible_host=172.xx.x.x ansible_ssh_user=root ansible_ssh_private_key=/home/<surname>/.ssh/id_rsa
```
- Faire la commande ansible Ad-hoc pour verifier la connectivite.

     ansible alma -i inventory.yaml -m ping
     
     
 Dans votre home directory creez une directory webforce.
 
    mkdir webforce
    
- Dans cette directory , creer un role postgresql.role

    ansible-galaxy init postgresql.role 
   
- Dans la directory webforce , creer un playbook postgres.yml qui utilise le role

     
- faire les commandes ansible Ad-hoc pour verifier l'OS et la version almalinux 

        ansible localhost -m shell -a 'cat /etc/os-release'
    
      
    <img width="704" alt="Capture d’écran 2023-03-28 à 11 46 08" src="https://user-images.githubusercontent.com/67427059/228197635-c4942fe8-5b1b-4c42-b3c2-32bdebaf29bb.png">


Dans role postgresql.role et dans la directory tasks 

Creez un fichier nommee variables.yml , avec le code suivant: 
Etudier et commenter ce code
```yaml
---
# Variables configuration
- name: Include OS-specific variables (Alma)
  include_vars: "{{ ansible_distribution }}-{{ ansible_distribution_version.split('.')[0] }}.yml" #Le module "include_vars" est utilisé pour inclure un fichier de variables spécifiques à l'OS. 
  when: ansible_distribution == "AlmaLinux" # à l'aide de la clause "when",La tâche ne s'exécutera que si la distribution Ansible est égale à "AlmaLinux"
```

Ce code permet de charger des variables spécifiques à la distribution AlmaLinux si cette dernière est détectée, ce qui peut faciliter la gestion des différences de configuration entre les différentes distributions.   
 
 Pourquoi avez vous besoin d'un handler?
