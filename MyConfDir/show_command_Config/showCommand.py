from rich.console import Console
from rich.text import Text

# Initialiser la console pour l'affichage
console = Console()

def afficher_fichier_formatte(nom_fichier):
    try:
        # Ouvrir et lire le fichier ligne par ligne
        with open(nom_fichier, 'r') as fichier:
            for ligne in fichier:
                ligne = ligne.strip()  # Supprimer les espaces inutiles autour

                # Afficher les lignes commençant par "#", en gras et en orange
                if ligne.startswith("#"):
                    texte = Text(ligne, style="bold orange1")
                    console.print(texte)
                
                # Afficher les lignes commençant par "*" sans le caractère "*", en bleu
                elif ligne.startswith("*"):
                    ligne_sans_asterisque = ligne[1:].strip()  # Supprimer le premier caractère "*"
                    texte = Text(ligne_sans_asterisque, style="green")
                    console.print(texte)
                
                # Afficher les autres lignes normalement (considérées comme des commandes)
                else:
                    texte = Text(ligne, style="")  # Optionnel : couleur verte pour les commandes
                    console.print(texte)
    
    except FileNotFoundError:
        console.print(f"[bold red]Erreur : le fichier '{nom_fichier}' est introuvable.[/bold red]")

# Nom du fichier à lire
nom_fichier = "/home/albarry/Bureau/DevOps/MyConfDir/show_command_Config/command.txt"

# Appeler la fonction pour afficher le contenu du fichier
afficher_fichier_formatte(nom_fichier)
