# Projet d'Algorithmes - Camlbrick

## Participants :
- CASTRO MENDOZA, Matias Jose 

## Objectif: 

L'objectif de ce projet est de développer un jeu de casse-briques dans lequel un joueur contrôle une raquette se déplaçant horizontalement en bas de l'écran. La raquette rebondit une balle se déplaçant à travers le niveau, détruisant les briques lorsqu'elle les frappe. Le but du jeu est de détruire toutes les briques destructibles dans le niveau.

La difficulté du jeu réside dans le fait de diriger la balle avec la raquette vers les briques restantes du niveau. Si la balle dépasse la zone de rebond de la raquette, elle est détruite et le joueur perd une vie. Le jeu est perdu s'il n'y a plus de balles à l'écran.

Le jeu est composé de plusieurs parties de l'interface graphique :

- La zone de menu, contenant des boutons et des informations pertinentes pour le jeu.
- Le monde du jeu, affichant l'ensemble du jeu.
- La zone des briques, où les briques à détruire sont affichées.
- La zone d'évolution des balles, où celles-ci peuvent se déplacer.
- La raquette et sa zone de rebond.
- La zone de destruction des balles.

Le projet inclut également la définition des paramètres du monde du jeu, tels que la largeur et la hauteur du monde, la largeur et la hauteur des briques, la taille initiale de la raquette et la vitesse du temps.

Le projet implique à la fois la mise en œuvre de la logique du jeu, de l'interface graphique et de la gestion des événements.

## Itération I:

### Itération 1: Réalisation des premières fonctions et des briques

#### Préparation des vecteurs
Dans cette itération, nous avons travaillé sur la préparation des vecteurs pour représenter les coordonnées et les vitesses dans le jeu. Nous avons défini le type `t_vec2` pour représenter des vecteurs 2D et nous avons implémenté les fonctions suivantes :

- `make_vec2(x, y: int * int): t_vec2` : Construit un vecteur à partir de deux entiers.
- `vec2_add(a, b: t_vec2 * t_vec2): t_vec2` : Calcule la somme de deux vecteurs.
- `vec2_mult(a, b: t_vec2 * t_vec2): t_vec2` : Calcule la multiplication des composantes de deux vecteurs entre elles.

#### Préparation des briques
Nous avons implémenté les structures de données nécessaires pour représenter les briques du jeu. Les briques sont des éléments passifs qui peuvent avoir différents types et effets lorsqu'elles sont frappées par une balle. Nous avons modifié le type `t_camlbrick` pour stocker les briques et nous avons implémenté les fonctions suivantes :

- `brick_get(x, y: int * int): brique_type` : Renvoie le type de brique selon les coordonnées dans la zone des briques.
- `brick_hit(x, y: int * int): unit` : Effectue les modifications dans la zone des briques pour simuler l'impact d'une balle.
- `brick_color(b: brique_type): color` : Renvoie une couleur selon le type de brique.

Des tests appropriés ont été réalisés pour ces fonctions et des modifications ont été apportées dans le fichier `camlbrick_launcher.ml` pour vérifier l'intégration correcte avec l'interface graphique du jeu.

## Itération 2: Gestion de la raquette et préparation des balles

### Gestion de la raquette

#### Préparation de la raquette
Dans cette itération, nous nous sommes concentrés sur la préparation de la raquette afin de pouvoir la représenter et contrôler son mouvement dans le jeu. Nous avons défini le type `t_paddle` pour représenter la raquette et avons modifié le type `t_camlbrick` pour qu'une instance du jeu puisse stocker des informations sur la raquette. Les fonctions suivantes ont été implémentées :

- `make_paddle()`: Crée une instance de raquette pour une utilisation lors des tests logiciels.
- `paddle_x`: Renvoie la position gauche du rectangle qui symbolise la raquette.
- `paddle_size_pixel`: Renvoie la largeur en pixels du rectangle de la raquette.
- `paddle_move_left()`: Permet de déplacer la raquette vers la gauche.
- `paddle_move_right()`: Permet de déplacer la raquette vers la droite.

Des tests approfondis ont été effectués pour assurer le bon fonctionnement de ces fonctions et leur intégration avec l'interface graphique du jeu.

### Préparation des balles

#### Conception du type des balles
À cette étape, nous nous sommes concentrés sur la conception du type de données pour représenter les balles dans le jeu. Nous avons défini le type `t_ball`, qui inclut des informations sur la position, la vitesse et la taille d'une balle. Nous avons modifié le type `t_camlbrick` pour pouvoir stocker les balles présentes dans le niveau. Les fonctions suivantes ont été implémentées :

- `has_ball`: Indique si la partie actuelle contient des balles.
- `balls_count`: Renvoie le nombre de balles présentes dans une partie.
- `balls_get`: Récupère toutes les balles d'une partie.
- `ball_get`: Récupère une balle spécifique d'une partie.
- `ball_x`: Renvoie la coordonnée x du centre d'une balle.
- `ball_y`: Renvoie la coordonnée y du centre d'une balle.
- `ball_size_pixel`: Indique la taille de la balle en pixels.
- `ball_color`: Renvoie la couleur d'une balle.

Ces fonctions ont été conçues pour faciliter la visualisation des balles dans l'interface graphique du jeu et leur manipulation ultérieure dans les itérations futures.

Pour préparer la prochaine itération, nous avons finalisé cette étape en implémentant des fonctions qui seront utiles pour détecter certains comportements liés aux balles. Cela comprend les fonctions `ball_modif_speed` et `ball_modif_speed_sign`, qui permettent d'ajuster la vitesse des balles, ainsi que les fonctions de détection `is_inside_circle` et `is_inside_quad`, qui sont utilisées pour déterminer si un point se trouve à l'intérieur d'une balle.
