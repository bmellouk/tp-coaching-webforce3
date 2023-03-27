# tp-coaching-webforce3
## Exercice 1 - Scrum

1- Aller sur project

2- Ensuite sur New Project

3- Sélectionner un modèle puis cliquer sur créer

4- Créer la liste des tâches à effectuer

5- Faire un screenshot image

<img width="1448" alt="Capture d’écran 2023-03-27 à 11 22 10" src="https://user-images.githubusercontent.com/67427059/227899793-6d3ae526-8af0-41c2-bca4-ee809d5bb175.png">

## Exercice 2 - Linux

1-Mettre à jour les packages de votre VM ubuntu:

        sudo apt-get update sudo apt-get upgrade

2-Vérifier la version de python3 déjà installée:

        python3 --version : Python 3.8.10 

3-créer un alias nommé python valide pour le user ubuntu de votre VM:

-Ouvrir le fichier .bashrc du user ubuntu: sudo nano ~/.bashrc

Ajouter la ligne suivante au fichier :

        alias python='python3

Rechargez les modifications faites dans le fichier ~/.bashrc en tapant la commande suivante :

        source ~/.bashrc

La commande "python" peut être utilisée pour exécuter le programme "python3" sur la VM.

Pour vérifier,utiliser :

        python -V

4- Installer flask:

On doit installé le pip :

        sudo apt install pip

Vérifier si pip est bien installé et la version :

        pip --version

Installer flask :

        pip install flask

Vérifier si flask est bien installé :

        flask --version

## Exercice 3 - Storage

1- Rechercher le disque supplémentaire de 1Gb connecté à la VM:

Utiliser la commande suivante pour lister les disques et les partitions connectés au système :

        sudo fdisk -l

Pour trouver directement le disque supplémentaire de 1Gb connecté à la VM utiliser la commande suivante:

        sudo fdisk -l | grep "1 GiB"

2- Formater le disque au format ext4

Vérifier que le disque ne figure pas dans la liste des systèmes de fichiers montés, avec leur point de montage correspondant:

        df -h

formater le disque au format ext4:

        sudo mkfs -t ext4 /dev/vdc

3- Monter (mount) ce disque sur le point montage /home/ubuntu/tp-coaching-webforce3/log :

Créez le répertoire de point de montage avec la commande suivante :

        sudo mkdir log

Montez le disque sur le point de montage en utilisant la commande suivante :

        sudo mount /dev/vdc /home/ubuntu/tp-coaching-webforce3/log

## Exercice 4 - Git/Github

1- Dans PyCharm allez dans File->Settings->Version control->github

2- Appuyer sur la croix, en haut a gauche de cette fenetre et selectionnez log in with token.

3- Entrez votre token github

4- Vous pouvez maintenant faire des git commit et git push depuis PyCharm

## Exercice 5 - Python

Créez un fichier blogs.py

        nano blogs.py

le commenter:

```python

   from flask import Flask
   import logging
   # create the app
   # app est une application Flask
   app = Flask(__name__)
   #effectuer la configuration de base du système du journalisation dans la fiche "log/record.log" 
   logging.basicConfig(filename='log/record.log', level=logging.DEBUG, format=f'%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')
   # application route, décorateur pour lier une fonction à une URL
    @app.route('/blogs')
   #creation de la fonction avec le nom blog qui retourne " Welcom to the Blog"
    def blog():
         app.logger.info('Info level log')
         app.logger.warning('Warning level log')
    return f"Welcome to the Blog"
    #l'exectuion de l'application en localhost
    app.run(host='localhost', debug=True)

```
Ajouter une variable d'environnement FLASK_APP=blogs n utilisant la commande suivante :

        export FLASK_APP=blogs.py

mettre cette variable dans le fichier ~/.bashrc de votre user ubuntu:

        nano ~/.bashrc

Pour prendre en compte le changement fais sur le fichier :

        source ~/.bashrc

Lancer le web server avec la commande :

        flask run --host=0.0.0.0 -p 30101

Rajouter une condition manquante pour pouvoir lancer le web server:

        if __name__ == '__main__'

Vérifier avec votre navigateur en utilisant l'url http://<ip_de_votre_vm>:30101/blogs:

image

## Exercice 6 - Pare-feu

Trouvez la commande de gestion du firewall sous ubuntu 20.04: 

        sudo ufw [option]

fermer le port 5000 en utilisant le commande:

        sudo ufw deny 5000 

autoriser le port 30101:

        sudo ufw allow 30101 
        
Vérifier l'application Web sur ces ports par la commande: 

        netsate | grep "30101"
