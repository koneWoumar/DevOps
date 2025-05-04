regerer exactement la meme chose sous forme de :
commande : description sans cela soit dans un tableau :

| Commande   | Description                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------- |
| `cat`      | Affiche le contenu d’un ou plusieurs fichiers (ou flux) sur la sortie standard.                   |
| `tac`      | Comme `cat` mais affiche les lignes en ordre inverse (bottom to top).                             |
| `head`     | Affiche les premières lignes d’un fichier ou d’un flux (par défaut 10).                           |
| `tail`     | Affiche les dernières lignes d’un fichier (peut suivre en temps réel avec `-f`).                  |
| `more`     | Affiche le contenu d’un fichier page par page.                                                    |
| `less`     | Pareil que `more`, mais plus interactif (navigation avant/arrière, recherche).                    |
| `cut`      | Coupe et extrait des colonnes ou champs de texte (par caractère ou délimiteur).                   |
| `awk`      | Langage de traitement de texte puissant, utilisé pour filtrer, transformer ou agréger des lignes. |
| `sed`      | Stream editor : permet de faire des recherches/remplacements et d’éditer en flux.                 |
| `tr`       | Traduit ou supprime des caractères (ex : majuscules en minuscules).                               |
| `sort`     | Trie les lignes d’un fichier ou flux (par ordre alphabétique, numérique, etc.).                   |
| `uniq`     | Supprime les lignes dupliquées consécutives (souvent après un `sort`).                            |
| `wc`       | Compte les mots, lignes, caractères ou octets d’un fichier ou d’un flux.                          |
| `diff`     | Compare deux fichiers ligne par ligne et affiche les différences.                                 |
| `cmp`      | Compare deux fichiers octet par octet (silencieux si identiques).                                 |
| `tee`      | Réplique un flux en sortie standard **et** dans un fichier.                                       |
| `xargs`    | Construit et exécute des commandes à partir d’un flux de données ou d’un fichier.                 |
| `split`    | Divise un fichier en plusieurs fichiers plus petits.                                              |
| `paste`    | Fusionne les lignes de plusieurs fichiers côte à côte (colonne par colonne).                      |
| `join`     | Joint deux fichiers sur une colonne commune (comme un "JOIN" SQL).                                |
| `nl`       | Numérote les lignes d’un fichier.                                                                 |
| `yes`      | Génère une chaîne répétée infiniment (utile pour automatiser une saisie).                         |
| `printf`   | Affiche du texte formaté (plus contrôlable que `echo`).                                           |
| `echo`     | Affiche une chaîne sur la sortie standard.                                                        |
| `rev`      | Inverse les caractères de chaque ligne d’un fichier.                                              |
| `grep`     | Recherche des motifs dans un fichier ou un flux, affiche les lignes correspondantes.              |
| `egrep`    | Version améliorée de `grep` supportant les expressions régulières étendues.                       |
| `fgrep`    | Version de `grep` qui ne traite pas les expressions régulières (littéral uniquement).             |
| `comm`     | Compare deux fichiers triés et affiche les lignes communes ou distinctes.                         |
| `strings`  | Extrait les chaînes imprimables contenues dans un fichier binaire.                                |
| `fold`     | Coupe les lignes longues à une certaine largeur (utile pour formater).                            |
| `fmt`      | Reformate des paragraphes pour respecter une largeur de ligne donnée.                             |
| `iconv`    | Convertit l’encodage d’un fichier texte (ex : UTF-8 vers ISO-8859-1).                             |
| `file`     | Détermine le type d’un fichier (texte, binaire, image, etc.).                                     |
| `stat`     | Donne des infos détaillées sur un fichier (taille, dates, permissions, etc.).                     |
| `basename` | Extrait le nom de fichier d’un chemin complet.                                                    |
| `dirname`  | Extrait le répertoire d’un chemin de fichier.                                                     |
