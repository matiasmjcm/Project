# Projet d'Algorithmes - Camlbrick

## Participants :
- Nous, Matias Jose CASTRO MENDOZA

## Objectif :

Notre objectif dans ce projet est de développer un jeu de casse-briques dans lequel nous contrôlons une raquette se déplaçant horizontalement en bas de l'écran. Cette raquette rebondit une balle se déplaçant à travers le niveau, détruisant des briques au contact. Le but du jeu est de détruire toutes les briques destructibles dans le niveau.

La difficulté du jeu réside dans le fait de diriger la balle avec la raquette vers les briques restantes du niveau. Si la balle dépasse la zone de rebond de la raquette, elle est détruite et nous perdons une vie. Le jeu est perdu s'il n'y a plus de balles à l'écran.

Notre jeu est composé de plusieurs parties de l'interface graphique :

- La zone de menu, qui contient des boutons et des informations pertinentes pour le jeu.
- Le monde du jeu, affichant l'ensemble du jeu.
- La zone des briques, où les briques à détruire sont affichées.
- La zone d'évolution des balles, où celles-ci peuvent se déplacer.
- La raquette et sa zone de rebond.

Notre projet inclut également la définition des paramètres du monde du jeu, tels que la largeur et la hauteur du monde, la largeur et la hauteur des briques, la taille initiale de la raquette et la vitesse du temps.

Ce projet nous implique dans la mise en œuvre de la logique du jeu, de l'interface graphique et de la gestion des événements.

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

Nous avons effectué des tests appropriés pour ces fonctions et apporté des modifications dans le fichier `camlbrick_launcher.ml` pour vérifier l'intégration correcte avec l'interface graphique du jeu.

## Itération 2: Gestion de la raquette et préparation des balles

### Gestion de la raquette

#### Préparation de la raquette
Dans cette itération, nous nous sommes concentrés sur la préparation de la raquette afin de pouvoir la représenter et contrôler son mouvement dans le jeu. Nous avons défini le type `t_paddle` pour représenter la raquette et avons modifié le type `t_camlbrick` pour qu'une instance du jeu puisse stocker des informations sur la raquette. Les fonctions suivantes ont été implémentées :

- `make_paddle()`: Crée une instance de raquette pour une utilisation lors des tests logiciels.
- `paddle_x`: Renvoie la position gauche du rectangle qui symbolise la raquette.
- `paddle_size_pixel`: Renvoie la largeur en pixels du rectangle de la raquette.
- `paddle_move_left()`: Permet de déplacer la raquette vers la gauche.
- `paddle_move_right()`: Permet de déplacer la raquette vers la droite.

Nous avons effectué des tests approfondis pour assurer le bon fonctionnement de ces fonctions et leur intégration avec l'interface graphique du jeu.

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

## Itération 3: Gestion des collisions et animations

Pour résumer les étapes précédentes, nous

 avons réalisé l'affichage de toutes les entités de base et nous pouvons déplacer la raquette sur l'écran. Nous allons maintenant animer les balles.

### Animation des balles

L'animation d'une balle consiste simplement à faire évoluer la position d'une balle en ajoutant sa vitesse à chaque image du jeu. Ainsi, la balle se déplacera dans la direction de sa vitesse. Nous avons complété la fonction `animate_action` pour animer toutes les balles d'une partie.

Maintenant, en modifiant la fonction précédente, nous avons ajouté la gestion des collisions avec les bords latéraux et supérieur de l'écran.

Enfin, nous avons complété la fonction `ball_remove_out_of_border` qui renvoie une nouvelle liste sans les balles qui dépassent la zone de rebond et met à jour la partie.

### Gestion des collisions

Pour gérer les collisions, nous nous sommes intéressés d'abord aux collisions entre balles et briques. Pour nous rassurer, nous savons que la gestion des collisions est difficile (même les jeux actuels sont pleins de bugs de collision), donc nous ne demandons pas une gestion parfaite des collisions mais une gestion raisonnable. En particulier, nous pouvons avoir deux conceptions distinctes :

- Soit nous considérons que le centre de la balle est utilisé pour effectuer nos collisions, et donc nous n'avons qu'à tester si le centre de notre cercle est dans le rectangle de la brique et agir en conséquence.
- Soit nous considérons que la balle est un disque avec un certain rayon.

Si une balle est un disque, nous pouvons avoir plusieurs cas pour gérer les collisions avec les briques, comme illustré dans les deux images ci-dessous. À gauche, nous considérons uniquement les 4 coins d'une brique et vérifions simplement qu'un coin entre dans le disque pour agir en conséquence (`ball_hit_corner_brick`). Mais cette approche est très approximative. Sur l'image de droite, nous ajoutons plus de points sur la brique, en particulier les milieux des arêtes de notre rectangle, où nous pouvons détecter plus facilement certaines configurations (`ball_hit_side_brick`).

Sur la base des propositions faites ci-dessus et des deux images fournies, nous avons détecté les collisions et implémenté les réactions. La réaction par défaut est de se déplacer dans le sens opposé de la collision, mais nous avons adapté ce comportement pour qu'il soit raisonnable. Bien sûr, nous n'oublions pas de déclencher une mise à jour de la brique si nécessaire (`brick_hit`).

Pour notre information, nous avons ajouté une touche qui crée à chaque pression une balle dans la zone désignée avec une vitesse aléatoire pour tester rapidement nos collisions et le comportement de notre jeu.

Maintenant que nous avons réussi à gérer les collisions avec les briques, nous avons géré la collision avec la raquette (`ball_hit_paddle`). Nous nous sommes inspirés fortement de ce que nous avons fait précédemment, mais nous avons ajouté le comportement suivant. Pour permettre au joueur de guider la balle vers une zone, notre raquette a été découpée en un nombre impair de morceaux. Le rebond sur chaque morceau influencera la vitesse de la raquette en conséquence.

Enfin, pour conclure cette partie et pour pouvoir diviser nos tests logiciels, si ce n'est pas déjà fait, nous avons mieux divisé la fonction `animate_action` en créant une fonction qui gère uniquement l'animation de la balle, une fonction qui gère toutes les collisions (`game_test_hit_balls`), et une fonction qui met à jour l'état du jeu (détruit les balles en dehors des limites et vérifie si le jeu est gagné ou perdu).

Nous avons encore des problèmes avec l'environnement graphique, mais nous les résoudrons pour l'itération 4.