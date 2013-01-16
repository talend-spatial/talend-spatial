Le format EDIGEO est basé sur une norme dont l'objectif est l'échange 
d'informations géographiques numériques sur support informatique entre des 
Systèmes d'Informations Géographiques (SIG).

Ce component permet de lire les fichiers EDIGEO. Ce format se compose de plusieurs 
fichiers (THF, VEC, GEN, SCD, etc.). Le fichier principal est le fichier THF. 
Il en existe plusieurs généralement. Chaque fichier THF constituant un lot de 
données. Un lot de données propose généralement plusieurs objets. Chaque 
objet peut être récupéré individuellement par le component et utilisé dans le 
flux.

Si vous devez utiliser plusieurs objets dans le flux, vous devrez utiliser 
plusieurs component *sEdigeoInput*.

Ce component propose deux paramètres : le filename qui permet de définir le 
chemin vers le fichier THF et l'objet EDIGEO que vous voulez récupérer. Vous 
devez également définir le schéma des données.

Pour définir un schéma de données, vous avez soit la possibilité de le définir 
manuellement soit par *Métadonnées* (ce dernier est conseillé car il évite les 
erreurs et simplifie la vie).

Plus d'information : 

* http://georezo.net/wiki/main/donnees/edigeo