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

