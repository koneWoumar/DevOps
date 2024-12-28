# Server Selector


## Selector Dependences


## Selector Code

- selector.sh :
```bash
#!/bin/bash

# Lire les options depuis le fichier
OPTIONS_FILE="options.txt"
CHOICES=$(cat "$OPTIONS_FILE" | cut -d'=' -f1)  # Extraire seulement les noms des options

# Créer un menu avec fzf pour choisir une option
CHOICE=$(echo "$CHOICES" | fzf --prompt="Filter here: " --height=10 --border)

# Lire la commande associée à l'option choisie
COMMAND=$(grep "^$CHOICE=" "$OPTIONS_FILE" | cut -d'=' -f2-)

# Vérifier si une commande a été trouvée et l'exécuter
if [ -n "$COMMAND" ]; then
    # echo "Exécution de la commande : $COMMAND"
    eval "$COMMAND"  # Exécuter la commande
else
    echo "Aucune commande trouvée pour l'option sélectionnée."
fi


# should install fzf
```
- selector.txt
```txt
option=commands

wke-gcp-prod=ssh kone_wolouho@web.kone-wolouho-oumar.com
wke-gcp-infra=ssh kone_wolouho@infra.kone-wolouho-oumar.com
```

### Selector Configuration

- add alias server=/path-to-your-selector.bash