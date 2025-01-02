import os
import sys
from rich.console import Console
from rich.text import Text

# Initialiser la console pour l'affichage
console = Console()

# Fonction pour afficher un fichier formaté
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
                
                # Afficher les lignes commençant par "*" sans le caractère "*", en vert
                elif ligne.startswith("*"):
                    ligne_sans_asterisque = ligne[1:].strip()  # Supprimer le premier caractère "*"
                    texte = Text(ligne_sans_asterisque, style="green")
                    console.print(texte)
                
                # Afficher les autres lignes normalement
                else:
                    texte = Text(ligne, style="")
                    console.print(texte)
    except FileNotFoundError:
        console.print(f"[bold red]Erreur : le fichier '{nom_fichier}' est introuvable.[/bold red]")

# Fonction pour déterminer le nom du fichier en fonction d'un mot-clé
mapping = {
    "docker": "cmd_docker",
    "kubectl": "cmd_kubectl",
    "ansible": "cmd_ansible",
    "terraform": "cmd_terraform",
    "reseau": "cmd_reseau",
    "admin":"cmd_admin",
    "cerbot":"cmd_cerbot"
}
def give_file_name_from(keyword):
    return mapping.get(keyword, None)


# Répertoire des fichiers
file_dir = "/home/albarry/Bureau/DevOps/MyConfDir/show_command_Config/cmd_file"

# Vérifier si un argument est fourni depuis l'invite de commande
if len(sys.argv) > 1:
    keyword = sys.argv[1]
    fichier = give_file_name_from(keyword)

    if fichier:
        chemin_fichier = os.path.join(file_dir, fichier)
        afficher_fichier_formatte(chemin_fichier)
    else:
        console.print(f"[bold red]Erreur : mot-clé '{keyword}' non reconnu.[/bold red]")
        console.print(f"[bold blue]Mot-clé Valable :[/bold blue]")
        for key in mapping:
            console.print(key)
else:
    # Aucun mot-clé fourni, afficher tous les fichiers du répertoire
    for fichier in os.listdir(file_dir):
        chemin_fichier = os.path.join(file_dir, fichier)
        # console.print(f"[bold blue]Affichage du fichier : {fichier}[/bold blue]")
        afficher_fichier_formatte(chemin_fichier)
        console.print("\n" + "-" * 50 + "\n")

