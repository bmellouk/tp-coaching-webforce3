# tp-coaching-webforce3

## Exercice 7: Compare les codes Ansible
Allez dans chatGPT et tapez :  
     **code ansible de l'installation de docker**

Comparez mon code install_docker_ubuntu.yml(1) avec le code généré par chatGPT (2)
Ajouter des commentaires

### code 1
```YAML
---
- name: Install Docker on Ubuntu
  hosts: all
  become: true
  tasks:
    - name: update all packages
      apt:
        update_cache: yes
    - name: Add pre-requisite packages
      apt:
        pkg:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg-agent
          - software-properties-common
          - python3-pip
          - python3-venv
          - ansible
    - name: Add official GPG key
      shell: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    - name: add specificed repository into source list
      shell: add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    - name: update all packages
      apt:
        update_cache: yes
    - name: install docker packages
      apt:
        pkg:
          - docker-ce
          - docker-ce-cli
          - containerd.io
    - name: Set current user to docker group
      command: usermod -aG docker ubuntu
    - name: Install pip docker package
      pip:
        name: docker
```

### code 2
```YAML
- name: Install Docker
  hosts: all
  become: true
  tasks:
    - name: Install packages required for Docker
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg-agent
          - software-properties-common
        state: present
    - name: Add Docker GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present
    - name: Add Docker APT repository
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable
        state: present
    - name: Install Docker CE
      apt:
        name: docker-ce
        state: present
    - name: Install Docker Compose
      get_url:
        url: "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64"
        dest: /usr/local/bin/docker-compose
        mode: '0755'
```


Le code 1 Ansible installe Docker sur une machine Ubuntu en utilisant la méthode d'installation officielle de Docker. Il met à jour les packages, ajoute les packages pré-requis, ajoute la clé GPG officielle de Docker, ajoute le référentiel spécifié à la liste des sources, installe les packages Docker, ajoute l'utilisateur courant au groupe Docker et installe le package Docker via pip.

Le code 2 installe Docker sur une machine Debian en utilisant le référentiel officiel Debian. Il met également à jour les packages, ajoute les packages pré-requis, ajoute la clé GPG officielle de Docker, ajoute le référentiel Debian à la liste des sources, installe les packages Docker et ajoute l'utilisateur courant au groupe Docker.

En général, les deux approches sont similaires dans leur installation de Docker, mais il y a des différences dans les paquets pré-requis et la façon dont les référentiels sont ajoutés. Les deux codes ajoutent également l'utilisateur courant au groupe Docker, ce qui est une bonne pratique pour éviter d'utiliser sudo pour chaque commande Docker.


## Exercice 8: Comparez les Dockerfiles

Générer avec chatGPT le dockerfile de l'application blogs.    
Allez dans chatGPT et tapez :      
     **écrit un dockerfile ubuntu web flask python**  
     
```BASH
# Utilisez une image Ubuntu comme base
FROM ubuntu:latest

# Mettez à jour les packages disponibles et installez Python et pip
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip

# Copiez les fichiers de l'application dans le conteneur
COPY . /app

# Définissez le répertoire de travail de l'application
WORKDIR /app

# Installez les dépendances de l'application via le fichier requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Exposez le port 5000 pour que l'application puisse être accessible depuis l'extérieur du conteneur
EXPOSE 5000

# Démarrez l'application Flask
CMD [ "python3", "app.py" ]
```

Faire la mise au point du script généré.  
Tapez la commande pour voir la taille de l'image docker.   
 
    docker build -t docker .
    

<img width="638" alt="Capture d’écran 2023-03-28 à 15 52 58" src="https://user-images.githubusercontent.com/67427059/228260938-5f95c3de-c934-4c0f-95f8-85cee30fd7e4.png">


Allez dans chatGPT et tapez :      
     **écrit un dockerfile alpine web flask python**
     
```sql
# On utilise l'image Python 3.9.10 Alpine comme base
FROM python:3.9.10-alpine

# On définit le répertoire de travail pour notre application
WORKDIR /app

# On copie le fichier requirements.txt dans le conteneur
COPY requirements.txt .

# On installe les packages nécessaires pour installer les packages Python
# (gcc, musl-dev et linux-headers), puis on installe les dépendances
# de l'application avec pip
RUN apk add --update --no-cache \
        gcc \
        musl-dev \
        linux-headers \
    && pip install --no-cache-dir -r requirements.txt

# On copie tous les fichiers du répertoire actuel (.) dans le conteneur
COPY . .

# On expose le port 5000 pour permettre à l'application d'être accessible depuis l'extérieur
EXPOSE 5000

# On définit la commande par défaut qui sera exécutée lorsque le conteneur sera démarré
# Ici, on exécute simplement le fichier app.py avec Python
CMD [ "python", "app.py" ]

```     

Faire la mise au point du script généré.
Tapez la commande pour voir la taille de l'image docker.

    docker build -t alpine .
    
<img width="612" alt="Capture d’écran 2023-03-28 à 16 09 36" src="https://user-images.githubusercontent.com/67427059/228265699-0da83058-7029-4293-9c87-6136c79c7ef1.png">

