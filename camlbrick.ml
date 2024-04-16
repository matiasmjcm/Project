(**
Ce module Camlbrick représente le noyau fonctionnel du jeu de casse-brique nommé <b>camlbrick</b>
(un jeu de mot entre le jeu casse-brique et le mot ocaml).

Le noyau fonctionnel consiste à réaliser l'ensemble des structures et autres fonctions capables
d'être utilisées par une interface graphique. Par conséquent, dans ce module il n'y a aucun
aspect visuel! Vous pouvez utiliser le mode console.

Le principe du jeu de casse-brique consiste à faire disparaître toutes les briques d'un niveau
en utilisant les rebonds d'une balle depuis une raquette contrôlée par l'utilisateur.

@author Hakim Ferrier-Belhaouari
@author Agnès Arnould


@version 1
*)

(**
Pour exécuter le code dans la console dans le fichier camlbrick, utilisez la commande suivante :
ocamlfind ocamlopt -o camlbrick -linkpkg -package labltk,unix,graphics camlbrick.ml camlbrick_gui.ml camlbrick_launcher.ml
et ensuite
./camlbrick   
*)

(** Compteur utilisé en interne pour afficher le numéro de la frame du jeu vidéo. 
    Vous pouvez utiliser cette variable en lecture, mais nous ne devez pas modifier
    sa valeur! *)
let frames = ref 0;;

(**
  type énuméré représentant les couleurs gérables par notre moteur de jeu. Vous ne pouvez pas modifier ce type!
  @deprecated Ne pas modifier ce type! 
*)
type t_camlbrick_color = WHITE | BLACK | GRAY | LIGHTGRAY | DARKGRAY | BLUE | RED | GREEN | YELLOW | CYAN | MAGENTA | ORANGE | LIME | PURPLE;;

(**
  Cette structure regroupe tous les attributs globaux,
  pour paramétrer notre jeu vidéo.
  <b>Attention:</b> Il doit y avoir des cohérences entre les différents paramètres:
  <ul>
  <li> la hauteur totale de la fenêtre est égale à la somme des hauteurs de la zone de briques du monde et
  de la hauteur de la zone libre.</li>
  <li>la hauteur de la zone des briques du monde est un multiple de la hauteur d'une seule brique. </li>
  <li>la largeur du monde est un multiple de la largeur d'une seule brique. </li>
  <li>initialement la largeur de la raquette doit correspondre à la taille moyenne.</li>
  <li>la hauteur initiale de la raquette doit être raisonnable et ne pas toucher un bord de la fenêtre.</li>
  <li>La variable <u>time_speed</u> doit être strictement positive. Et représente l'écoulement du temps.</li>
  </ul>
*)
type t_camlbrick_param = {
  world_width : int; (** largeur de la zone de dessin des briques *)
  world_bricks_height : int; (** hauteur de la zone de dessin des briques *)
  world_empty_height : int; (** hauteur de la zone vide pour que la bille puisse évoluer un petit peu *)

  brick_width : int; (** largeur d'une brique *)
  brick_height : int; (** hauteur d'une brique *)

  paddle_init_width : int; (** largeur initiale de la raquette *)
  paddle_init_height : int; (** hauteur initiale de la raquette *)

  time_speed : int ref; (** indique l'écoulement du temps en millisecondes (c'est une durée approximative) *)
};;

(** Enumeration des différents types de briques. 
  Vous ne devez pas modifier ce type.    
*)
type t_brick_kind = BK_empty | BK_simple | BK_double | BK_block | BK_bonus;;

(**
  Cette fonction renvoie le type de brique pour représenter les briques de vide.
  C'est à dire, l'information qui encode l'absence de brique à un emplacement sur la grille du monde.
  @return Renvoie le type correspondant à la notion de vide.
  @deprecated  Cette fonction est utilisé en interne.    
*)
let make_empty_brick() : t_brick_kind = 
  BK_empty
;;

(** 
    Enumeration des différentes tailles des billes. 
    La taille  normale d'une bille est [BS_MEDIUM]. 
  
    Vous pouvez ajouter d'autres valeurs sans modifier les valeurs existantes.
*)
type t_ball_size = BS_SMALL | BS_MEDIUM | BS_BIG;;

(** 
Enumeration des différentes taille de la raquette. Par défaut, une raquette doit avoir la taille
[PS_SMALL]. 

  Vous pouvez ajouter d'autres valeurs sans modifier les valeurs existantes.
*)
type t_paddle_size = PS_SMALL | PS_MEDIUM | PS_BIG;;

(** 
  Enumération des différents états du jeu. Nous avons les trois états de base:
    <ul>
    <li>[GAMEOVER]: qui indique si une partie est finie typiquement lors du lancement du jeu</li>
    <li>[PLAYING]: qui indique qu'une partie est en cours d'exécution</li>
    <li>[PAUSING]: indique qu'une partie en cours d'exécution est actuellement en pause</li>
    </ul>
    
    Dans le cadre des extensions, vous pouvez modifier ce type pour adopter d'autres états du jeu selon
    votre besoin.
*)
type t_gamestate = GAMEOVER | PLAYING | PAUSING;;


(* Définition du type t_vec2 avec des champs mutables pour les composantes x et y. *)
(* Itération 1 *)
type t_vec2 = {
  mutable x : int; (** Composante en x du vecteur *)
  mutable y : int; (** Composante en y du vecteur *)
};;


(**
  Cette fonction permet de créer un vecteur 2D à partir de deux entiers.
  Les entiers représentent la composante en X et en Y du vecteur.

  Vous devez modifier cette fonction.
  @param x première composante du vecteur
  @param y seconde composante du vecteur
  @return Renvoie le vecteur dont les composantes sont (x,y).
*)
(**
  Cette fonction permet de créer un vecteur 2D à partir de deux entiers.
  Les entiers représentent les composantes en X et en Y du vecteur.

  @param x première composante du vecteur
  @param y seconde composante du vecteur
  @return Renvoie le vecteur dont les composantes sont (x, y).
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let make_vec2(x,y : int * int) : t_vec2 = 
  (* Itération 1 *)
  { x = x; y = y }
;;

(**
  Cette fonction renvoie un vecteur qui est la somme des deux vecteurs donnés en arguments.
  @param a premier vecteur
  @param b second vecteur
  @return Renvoie un vecteur égale à la somme des vecteurs.
*)
(**
  Cette fonction permet d'ajouter deux vecteurs 2D.
  Cela renvoie un nouveau vecteur 2D dont les composantes sont la somme
  des composantes correspondantes des deux vecteurs fournis.

  @param a premier vecteur à additionner
  @param b second vecteur à additionner
  @return Renvoie le vecteur résultant de l'addition de a et b.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let vec2_add(a,b : t_vec2 * t_vec2) : t_vec2 =
  (* Itération 1 *)
  { x = a.x + b.x; y = a.y + b.y }
;;

(**
  Cette fonction renvoie un vecteur égale à la somme d'un vecteur
  donné en argument et un autre vecteur construit à partir de (x,y).
  
  Cette fonction est une optimisation du code suivant (que vous ne devez pas faire en l'état):
  {[
let vec2_add_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  vec2_add(a, make_vec2(x,y))
;;
  ]}

  @param a premier vecteur
  @param x composante en x du second vecteur
  @param y composante en y du second vecteur
  @return Renvoie un vecteur qui est la résultante du vecteur 
*)
(**
  Cette fonction permet d'ajouter un scalaire sous forme de vecteur à un vecteur 2D.
  Elle prend un vecteur 2D et deux entiers, crée un nouveau vecteur 2D avec ces entiers,
  puis additionne ce vecteur scalaire au vecteur original.

  @param a vecteur original à modifier
  @param x composante en X du scalaire à ajouter
  @param y composante en Y du scalaire à ajouter
  @return Renvoie le vecteur résultant de l'addition du scalaire au vecteur original.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let vec2_add_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1 *)
  (* Création du vecteur à partir de (x, y) *)
  let scalar_vector = { x = x; y = y } in
  (* Addition des composantes *)
  let result_x = a.x + scalar_vector.x in
  let result_y = a.y + scalar_vector.y in
  { x = result_x; y = result_y }
;;

(**
  Cette fonction calcul un vecteur où 
  ses composantes sont la résultante de la multiplication  des composantes de deux vecteurs en entrée.
  Ainsi,
    {[
    c_x = a_x * b_x
    c_y = a_y * b_y
    ]}
  @param a premier vecteur
  @param b second vecteur
  @return Renvoie un vecteur qui résulte de la multiplication des composantes. 
*)
let vec2_mult(a,b : t_vec2 * t_vec2) : t_vec2 = 
  (* Itération 1 *)
  { x = a.x * b.x; y = a.y * b.y }
;;

(**
  Cette fonction calcul la multiplication des composantes du vecteur a et du vecteur construit à partir de (x,y).
  Cette fonction est une optimisation du code suivant (que vous ne devez pas faire en l'état):
  {[
let vec2_mult_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  vec2_mult(a, make_vec2(x,y))
;;
  ]}
    
*)

(**
  Cette fonction permet de multiplier un vecteur 2D par un scalaire représenté par deux entiers.
  Elle calcule le produit de chaque composante du vecteur avec les entiers correspondants.

  @param a vecteur original à modifier
  @param x multiplicateur pour la composante en X
  @param y multiplicateur pour la composante en Y
  @return Renvoie le vecteur résultant de la multiplication des composantes.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let vec2_mult_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1 *)
  let result_x = a.x * x in
  let result_y = a.y * y in
  { x = result_x; y = result_y }
;;
(**
  Définition du type pour représenter une balle dans un jeu ou une simulation.
  Ce type contient la position et la vitesse de la balle, ambas son vectores 2D y mutables,
  permitiendo que sus valores sean actualizados directamente. También incluye un campo para la taille de la balle.
  @author CASTRO MATIAS
*)
(* Itération 2 *)
type t_ball = {
  mutable position : t_vec2; (** Position de la balle dans le monde *)
  mutable velocity : t_vec2; (** Vecteur vitesse de la balle *)
  size : t_ball_size; (** Taille de la balle *)
};;

(**
  Définition du type pour représenter une palette dans un jeu de type "pong".
  Ce type inclut la position horizontale de la palette y su tamaño, ambos campos son mutables,
  permitiendo que sus valores sean actualizados según las interacciones del jugador.

  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
(* Itération 2 *)
type t_paddle = { 
  mutable paddle_x : int; (** Position horizontale de la palette *)
  mutable paddle_size : t_paddle_size; (** Taille de la palette *)
};;

(**
  Définition du type pour représenter un jeu de "Breakout" en OCaml. 
  Ce type encapsule tous los elementos necesarios para el estado del juego, 
  incluyendo parámetros del juego, bolas en juego, la paleta del jugador, el estado actual del juego, 
  y una matriz de ladrillos que representan los obstáculos a destruir.

  @author CASTRO MATIAS
*)
(* Itération 1, 2, 3 et 4 *)
type t_camlbrick = {
  mutable param : t_camlbrick_param;
  mutable balls : t_ball list;
  mutable paddle : t_paddle;
  mutable state : t_gamestate;
  mutable bricks : t_brick_kind array array;
}
;;

(**
  Cette fonction initialise et renvoie une structure de paramètres pour configurer un jeu de type "Breakout".
  Elle définit les dimensions du monde de jeu, des briques, de la zone vide, de la palette initiale,
  ainsi que la vitesse de jeu à travers un référence de temps.

  @return Renvoie une structure `t_camlbrick_param` contenant les configurations initiales du jeu.
  @author CASTRO MATIAS
*)

(**
  Cette fonction construit le paramétrage du jeu, avec des informations personnalisable avec les contraintes du sujet.
  Il n'y a aucune vérification et vous devez vous assurer que les valeurs données en argument soient cohérentes.
  @return Renvoie un paramétrage de jeu par défaut      
*)
let make_camlbrick_param() : t_camlbrick_param = {
   world_width = 800;
   world_bricks_height = 400;
   world_empty_height = 200;

   brick_width = 40;
   brick_height = 20;

   paddle_init_width = 100;
   paddle_init_height = 20;

   time_speed = ref 20;
}
;;

(**
  Cette fonction est destinée à récupérer les paramètres actuels du jeu "Breakout".
  Actuellement, cette fonction crée et retourne un nouveau jeu de paramètres par défaut,
  mais elle pourrait être modifiée pour retourner les paramètres actuels de l'instance de jeu fournie en argument.

  @param game Instance du jeu pour laquelle on souhaite obtenir les paramètres.
  @return Renvoie les paramètres par défaut du jeu, tels que spécifiés dans `make_camlbrick_param`.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
(**
  Cette fonction extrait le paramétrage d'un jeu à partir du jeu donné en argument.
  @param game jeu en cours d'exécution.
  @return Renvoie le paramétrage actuel.
  *)
let param_get(game : t_camlbrick) : t_camlbrick_param =
  (* Itération 1 *)
  make_camlbrick_param()
;;

(**
  Cette fonction crée une nouvelle structure qui initialise le monde avec aucune brique visible.
  Une raquette par défaut et une balle par défaut dans la zone libre.
  @return Renvoie un jeu correctement initialisé
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let make_camlbrick() : t_camlbrick = 
  (* Itération 1, 2, 3 et 4 *)
  let params = make_camlbrick_param() in
  let paddle = {
    paddle_x = (params.world_width / 2) - (params.paddle_init_width / 2);
    paddle_size = PS_MEDIUM;
  } in 
  let ball = {
    (* Position initiale de la balle, ajustée au-dessus de la raquette*)
    position = { 
      x = paddle.paddle_x + (params.paddle_init_width / 2);  
      y = params.world_bricks_height - params.brick_height + 50; 
    };
    velocity = { x = 0; y = 10 };  (* Vitesse initiale de la balle*)
    size = BS_SMALL;  
  } in
  let bricks = Array.init params.world_bricks_height (fun _ ->
    Array.init params.world_width (fun _ ->
      match Random.int 5 with
      | 0 -> BK_empty
      | 1 -> BK_simple
      | 2 -> BK_double
      | 3 -> BK_block
      | 4 -> BK_bonus
      | _ -> BK_empty  
    )) in
  {
    param = params;
    balls = [ball];
    paddle = paddle;
    state = PAUSING;
    bricks = bricks;
  }
;;

(**
  Cette fonction crée une raquette par défaut au milieu de l'écran et de taille normal.  
  @deprecated Cette fonction est là juste pour le debug ou pour débuter certains traitements de test.
  @author CASTRO MATIAS
  *)
let make_paddle() : t_paddle =
  (* Itération 2 *)
 let params = make_camlbrick_param() in
 let x = (params.world_width / 2) - (params.paddle_init_width / 2) in
 {
  paddle_x = x;
  paddle_size = PS_MEDIUM;
 }
;;

(** Crée une balle avec la position donnée, une vitesse initiale de zéro et une taille déterminée.

    @param x la coordonnée X de la position de la balle
    @param y la coordonnée Y de la position de la balle
    @param size la taille de la balle (1 pour petite, 2 pour moyenne, 3 pour grande)
    @return une balle avec les propriétés spécifiées
    @author CASTRO MATIAS
*)
let make_ball(x,y, size : int * int * int) : t_ball =
  (* Itération 3 *)
  { position = make_vec2(x, y); (* Créer un vecteur 2D pour la position *)
    velocity = { x = 0; y = 0 }; (* Initialiser la vitesse à zéro *)
    size = match size with
      | 1 -> BS_SMALL
      | 2 -> BS_MEDIUM
      | 3 -> BS_BIG
      | _ -> BS_MEDIUM (* Taille moyenne par défaut en cas de valeur incorrecte *) }
;;

(**
  Fonction utilitaire qui permet de traduire l'état du jeu sous la forme d'une chaîne de caractère.
  Cette fonction est appelée à chaque frame, et est affichée directement dans l'interface graphique.
  
  Vous devez modifier cette fonction.

  @param game représente le jeu en cours d'exécution.
  @return Renvoie la chaîne de caractère représentant l'état du jeu.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let string_of_gamestate(game : t_camlbrick) : string =
  (* Itération 1,2,3 et 4 *)
  match game.state with
  | GAMEOVER -> "GAME OVER"
  | PLAYING -> "PLAYING"
  | PAUSING -> "PAUSING"
;;

(** Récupère le type de brique à la position spécifiée dans le jeu.

    @param game le jeu dans lequel rechercher la brique
    @param i l'indice de ligne de la brique
    @param j l'indice de colonne de la brique
    @return le type de brique à la position spécifiée
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let brick_get(game, i, j : t_camlbrick * int * int)  : t_brick_kind =
  (* Itération 1 *)
  if i >= 0 && i < game.param.world_width && j >= 0 && j < game.param.world_bricks_height then
    match game.bricks.(i).(j) with
    | BK_empty -> BK_empty
    | BK_simple -> BK_simple
    | BK_double -> BK_double
    | BK_block -> BK_block
    | BK_bonus -> BK_bonus
  else
    BK_simple
;;

(** Gère l'impact sur une brique à la position spécifiée dans le jeu.

    @param game le jeu dans lequel la brique est affectée
    @param i l'indice de ligne de la brique
    @param j l'indice de colonne de la brique
    @return le type de brique après l'impact
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let brick_hit (game, i, j : t_camlbrick * int * int) : t_brick_kind =
  let brick_type = game.bricks.(i).(j) in
  match brick_type with
  | BK_simple -> 
      game.bricks.(i).(j) <- BK_empty;
      BK_simple
  | BK_double -> 
      game.bricks.(i).(j) <- BK_simple;
      BK_double
  | BK_bonus -> 
      game.bricks.(i).(j) <- BK_empty;
      BK_bonus
  | BK_block -> 
      BK_block
  | BK_empty -> 
      BK_empty
;;

(** Obtient la couleur de la brique à la position spécifiée dans le jeu.

    @param game le jeu dans lequel se trouve la brique
    @param i l'indice de ligne de la brique
    @param j l'indice de colonne de la brique
    @return la couleur de la brique à la position spécifiée
    @author CASTRO MATIAS
*)
let brick_color(game,i,j : t_camlbrick * int * int) : t_camlbrick_color = 
  (* Itération 1 *)
  (* Obtient le type de brique à la position (i, j) *)
  let brick_kind = brick_get(game, i, j) in
  (* Associe une couleur à chaque type de brique *)
  match brick_kind with
    | BK_empty -> WHITE
    | BK_simple -> ORANGE
    | BK_double -> BLUE
    | BK_block -> GREEN
    | BK_bonus -> YELLOW
;;

(** Obtient la position en X de la raquette dans le jeu.

    @param game le jeu dans lequel se trouve la raquette
    @return la position en X de la raquette
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let paddle_x(game : t_camlbrick) : int= 
  (* Itération 2 *)
  game.paddle.paddle_x
;;

(** Obtient la taille de la raquette en pixels dans le jeu.

    @param game le jeu dans lequel se trouve la raquette
    @return la taille de la raquette en pixels
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let paddle_size_pixel(game : t_camlbrick) : int = 
  (* Itération 2 *)
  (* Récupérer la palette du jeu *)
  let paddle = game.paddle in
  (* Déterminer la taille de la palette et retourner la taille correspondante en pixels *)
  match paddle.paddle_size with
  | PS_SMALL -> 50 (* Taille en pixels pour la palette de taille petite *)
  | PS_MEDIUM -> 75 (* Taille en pixels pour la palette de taille moyenne *)
  | PS_BIG -> 100 (* Taille en pixels pour la palette de taille grande *)
;;

(** Déplace la raquette vers la gauche dans le jeu.

    @param game le jeu dans lequel se trouve la raquette
    @author CASTRO MATIAS
*)
let paddle_move_left(game : t_camlbrick) : unit = 
  (* Itération 2 *)
  let paddle = game.paddle in
  let move_amount = 10 (* Nombre de pixels à déplacer *) in
  let min_x = 0 (* Coordonnée x minimale autorisée, bord de l'écran *) in
    paddle.paddle_x <- max min_x (paddle.paddle_x - move_amount)
;;

(** Déplace la raquette vers la droite dans le jeu.

    @param game le jeu dans lequel se trouve la raquette
    @author CASTRO MATIAS
*)
let paddle_move_right(game : t_camlbrick) : unit = 
  (* Itération 2 *)
  let paddle = game.paddle in
  let move_amount = 10 (* Quantité de pixels à déplacer *) in
  let max_x = game.param.world_width - paddle_size_pixel game in(* Coordonnée x maximale autorisée, bord de l'écran *)
  let new_paddle_right = paddle.paddle_x + move_amount in (* Nouvelle position du bord droit de la palette *)
  (*afin que la coordonnée ne dépasse pas la limite*)
  paddle.paddle_x <- min max_x new_paddle_right
;;

(** Vérifie si le jeu contient au moins une balle.

    @param game le jeu à vérifier
    @return true si le jeu contient au moins une balle, false sinon
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let has_ball(game : t_camlbrick) : bool =
  (* Itération 2 *)
  match game.balls with
  | [] -> false  (* Il n'y a pas de balles dans le jeu *)
  | _ -> true    (* Il y a au moins une balle dans le jeu *)
;;

(** Compte le nombre de balles dans le jeu.

    @param game le jeu à compter
    @return le nombre de balles dans le jeu
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let balls_count(game : t_camlbrick) : int =
  (* Itération 2 *)
  List.length game.balls
;;

(** Récupère la liste des balles présentes dans le jeu.

    @param game le jeu dans lequel rechercher les balles
    @return la liste des balles présentes dans le jeu
    @author CASTRO MATIAS
*)
let balls_get(game : t_camlbrick) : t_ball list = 
  (* Itération 2 *)
  game.balls
;;

(** Récupère la balle à l'indice spécifié dans la liste des balles du jeu.

    @param game le jeu dans lequel rechercher la balle
    @param i l'indice de la balle à récupérer
    @return la balle à l'indice spécifié dans la liste des balles du jeu
    @author CASTRO MATIAS
*)
let ball_get(game, i : t_camlbrick * int) : t_ball =
  (* Itération 2 *)
  List.nth game.balls i
;;

(** Obtient la position en X de la balle donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite obtenir la position en X
    @return la position en X de la balle dans le jeu
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let ball_x(game,ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.x
;;

(** Obtient la position en Y de la balle donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite obtenir la position en Y
    @return la position en Y de la balle dans le jeu
    @author CASTRO MATIAS
*)
let ball_y(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.y
;;

(** Obtient la taille en pixels de la balle donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite obtenir la taille en pixels
    @return la taille en pixels de la balle dans le jeu
    @author CASTRO MATIAS
*)
let ball_size_pixel(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> 10   (* Taille du cercle pour une petite balle *)
  | BS_MEDIUM -> 20  (* Taille du cercle pour une balle de taille moyenne *)
  | BS_BIG -> 30     (* Taille du cercle pour une grande balle *)
;;

(** Obtient la couleur de la balle donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite obtenir la couleur
    @return la couleur de la balle dans le jeu
    @author KERAN JOYEUX
*)
let ball_color(game, ball : t_camlbrick * t_ball) : t_camlbrick_color =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> GRAY    (* Couleur pour les petites balles *)
  | BS_MEDIUM -> CYAN     (* Couleur pour les balles de taille moyenne *)
  | BS_BIG -> MAGENTA     (* Couleur pour les grandes balles *)
;;

(** Modifie la vitesse de la balle donnée dans le jeu en ajoutant un vecteur de modification.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite modifier la vitesse
    @param dv le vecteur de modification à ajouter à la vitesse actuelle de la balle
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let ball_modif_speed(game, ball, dv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  ball.velocity <- vec2_add (ball.velocity, dv)
;;

(** Modifie la vitesse de la balle donnée dans le jeu en multipliant par un vecteur de signe.

    @param game le jeu dans lequel se trouve la balle
    @param ball la balle dont on souhaite modifier la vitesse
    @param sv le vecteur de signe pour la modification de la vitesse
    @author CASTRO MATIAS
*)
let ball_modif_speed_sign(game, ball, sv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  ball.velocity <- vec2_mult(ball.velocity, sv)
;;

(** Vérifie si un point (x, y) est à l'intérieur d'un cercle avec le centre (cx, cy) et le rayon donnés.

    @param cx la coordonnée X du centre du cercle
    @param cy la coordonnée Y du centre du cercle
    @param rad le rayon du cercle
    @param x la coordonnée X du point à vérifier
    @param y la coordonnée Y du point à vérifier
    @return true si le point est à l'intérieur du cercle, false sinon
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let is_inside_circle(cx,cy,rad, x, y : int * int * int * int * int) : bool =
  (* Itération 3 *)
  let distance_squared = (x - cx) * (x - cx) + (y - cy) * (y - cy) in
  let radius_squared = rad * rad in
  distance_squared <= radius_squared
;;

(** Vérifie si un point (x, y) est à l'intérieur d'un quadrilatère défini par ses coins (x1, y1) et (x2, y2).

    @param x1 la coordonnée X du premier coin du quadrilatère
    @param y1 la coordonnée Y du premier coin du quadrilatère
    @param x2 la coordonnée X du deuxième coin du quadrilatère
    @param y2 la coordonnée Y du deuxième coin du quadrilatère
    @param x la coordonnée X du point à vérifier
    @param y la coordonnée Y du point à vérifier
    @return true si le point est à l'intérieur du quadrilatère, false sinon
    @author CASTRO MATIAS
*)
let is_inside_quad(x1,y1,x2,y2, x,y : int * int * int * int * int * int) : bool =
  (* Itération 3 *)
  x >= x1 && x <= x2 && y >= y1 && y <= y2
;;

(** Supprime les balles qui sont sorties de la zone de jeu.

    @param game le jeu dans lequel se trouvent les balles
    @param balls la liste des balles à filtrer
    @return la liste des balles restantes après filtrage
    @author CASTRO MATIAS
*)
let ball_remove_out_of_border(game,balls : t_camlbrick * t_ball list ) : t_ball list = 
  (* Itération 3 *)
  let rec filter_balls = function
  | [] -> []
  | ball :: balls ->
      if ball.position.y > game.param.world_empty_height then
        filter_balls balls
      else
        ball :: filter_balls balls
  in
  filter_balls balls
;;

(** Gère la collision entre la balle et la palette dans le jeu.

    @param game le jeu dans lequel se trouve la balle et la palette
    @param ball la balle en collision avec la palette
    @param paddle la palette avec laquelle la balle entre en collision
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let ball_hit_paddle(game,ball,paddle : t_camlbrick * t_ball * t_paddle) : unit =
  (* Itération 3 *)
  let paddle_x = paddle.paddle_x in
  let paddle_y = game.param.world_empty_height - game.param.paddle_init_height in
  let paddle_width = match paddle.paddle_size with
    | PS_SMALL -> 50
    | PS_MEDIUM -> 75
    | PS_BIG -> 100
  in

  let ball_x = ball.position.x in
  let ball_y = ball.position.y in
  let ball_radius = match ball.size with
    | BS_SMALL -> 5
    | BS_MEDIUM -> 10
    | BS_BIG -> 15
  in

  (* Vérifier si la balle entre en collision avec la palette *)
  if ball_y - ball_radius <= paddle_y && ball_y + ball_radius >= paddle_y &&
     ball_x >= paddle_x && ball_x <= paddle_x + paddle_width then
  begin
    let sections = 5 in (* En supposant un nombre impair de sections pour cet exemple *)
    let section_width = paddle_width / sections in
    let relative_intercept_x = ball_x - paddle_x in
    let section_hit = relative_intercept_x / section_width in
    let middle_section = sections / 2 in

    (* Calculer le ratio de collision basé sur la section touchée *)
    let collision_ratio =
      if section_hit < middle_section then
        (-.1.) +. (float_of_int section_hit /. float_of_int middle_section)
      else if section_hit > middle_section then
        (float_of_int (section_hit - middle_section) /. float_of_int middle_section)
      else
        0. in

    let new_velocity_x = int_of_float (10. *. collision_ratio) in
    let new_velocity_y = -(ball.velocity.y) in

    (* Ajustar la velocidad de la bola basándose en el punto de colisión *)
    ball.velocity <- { x = new_velocity_x; y = new_velocity_y }
  end
;;

(** Vérifie si la balle entre en collision avec un coin d'une brique donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle et la brique
    @param ball la balle à vérifier pour la collision avec un coin de la brique
    @param i l'indice de ligne de la brique
    @param j l'indice de colonne de la brique
    @return true si la balle entre en collision avec un coin de la brique, false sinon
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
(* lire l'énoncé choix à faire *)
let ball_hit_corner_brick(game,ball, i,j : t_camlbrick * t_ball * int * int) : bool =
  (* Itération 3 *)
  let brick_pos = (i * game.param.brick_width, j * game.param.brick_height) in
  let (brick_x, brick_y) = brick_pos in  (* Déstructurez d'abord le tuple *)
  let corners = [
    brick_pos; 
    (brick_x + game.param.brick_width, brick_y);
    (brick_x, brick_y + game.param.brick_height);
    (brick_x + game.param.brick_width, brick_y + game.param.brick_height)] in
  List.exists (fun (cx, cy) ->
    is_inside_circle(cx, cy, ball_size_pixel(game, ball), ball.position.x, ball.position.y)
  ) corners
;;

(** Vérifie si la balle entre en collision avec un côté d'une brique donnée dans le jeu.

    @param game le jeu dans lequel se trouve la balle et la brique
    @param ball la balle à vérifier pour la collision avec un côté de la brique
    @param i l'indice de ligne de la brique
    @param j l'indice de colonne de la brique
    @return true si la balle entre en collision avec un côté de la brique, false sinon
    @author CASTRO MATIAS
*)
(* lire l'énoncé choix à faire *)
let ball_hit_side_brick(game, ball, i, j : t_camlbrick * t_ball * int * int) : bool =
  let brick_x = i * game.param.brick_width and brick_y = j * game.param.brick_height in
  let inside_quad = is_inside_quad(brick_x, brick_y, brick_x + game.param.brick_width, brick_y + game.param.brick_height,
                                   ball.position.x, ball.position.y) in
  if inside_quad then
    not (ball_hit_corner_brick(game, ball, i, j))
  else
    false
  ;
;;

(** Teste les collisions des balles avec les briques et la palette dans le jeu.

    @param game le jeu dans lequel se trouvent les balles, les briques et la palette
    @param balls la liste des balles à tester pour les collisions
    @author CASTRO MATIAS
    @author KERAN JOYEUX
*)
let game_test_hit_balls(game, balls : t_camlbrick * t_ball list) : unit =
  (* Itération 3 *)
  (*Parcourir chaque balle pour vérifier les collisions.*)
  List.iter (fun ball ->
    (*Vérifier les collisions avec chaque brique.*)
    for i = 0 to (Array.length game.bricks) - 1 do
      for j = 0 to (Array.length game.bricks.(0)) - 1 do
        if brick_get(game, i, j) <> BK_empty then (
          (*Si une collision avec un coin ou un côté est détectée, gérer la collision.*)
          if ball_hit_corner_brick(game, ball, i, j) || ball_hit_side_brick(game, ball, i, j) then (
            (*Gérer l'impact sur la brique et éventuellement ajuster la direction de la balle.*)

            ignore (brick_hit(game, i, j)); (*Mettre à jour l'état de la brique.*)
          )
        )
      done;
    done;
    
    (*Vérifier la collision avec la raquette.*)
    ball_hit_paddle(game, ball, game.paddle);
  ) balls;
;;

(*////////////////////////////////////////////////////////////////////*)
(**
  Cette fonction est appelée par l'interface graphique avec le jeu en argument et la position
  de la souris dans la fenêtre lorsqu'elle se déplace. 
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @param x l'abscisse de la position de la souris
  @param y l'ordonnée de la position de la souris     
*)
let canvas_mouse_move(game,x,y : t_camlbrick * int * int) : unit = 
  ()
;;
(*////////////////////////////////////////////////////////////////////*)

(**
  Cette fonction est appelée par l'interface graphique avec le jeu en argument et la position
  de la souris dans la fenêtre lorsqu'un bouton est enfoncé. 
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @param button numero du bouton de la souris enfoncé.
  @param x l'abscisse de la position de la souris
  @param y l'ordonnée de la position de la souris     
*)
let canvas_mouse_click_press(game,button,x,y : t_camlbrick * int * int * int) : unit =
  ()
;;

(**
  Cette fonction est appelée par l'interface graphique avec le jeu en argument et la position
  de la souris dans la fenêtre lorsqu'un bouton est relaché. 
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @param button numero du bouton de la souris relaché.
  @param x l'abscisse de la position du relachement
  @param y l'ordonnée de la position du relachement   
*)
let canvas_mouse_click_release(game,button,x,y : t_camlbrick * int * int * int) : unit =
  ()
;;

(**
  Cette fonction est appelée par l'interface graphique lorsqu'une touche du clavier est appuyée.
  Les arguments sont le jeu en cours, la touche enfoncé sous la forme d'une chaine et sous forme d'un code
  spécifique à labltk.
  
  Le code fourni initialement permet juste d'afficher les touches appuyées au clavier afin de pouvoir
  les identifiées facilement dans nos traitements.

  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @param keyString nom de la touche appuyée.
  @param keyCode code entier de la touche appuyée.   
  @author CASTRO MATIAS
*)
let canvas_keypressed(game, keyString, keyCode : t_camlbrick * string * int) : unit =
  if game.state = PLAYING then
    match keyCode with
    | 65361 -> 
      paddle_move_left game
    | 65363 -> 
      paddle_move_right game
    | 97 -> 
      paddle_move_left game
    | 100 -> 
      paddle_move_right game
    | _ -> ()
;;

(**
  Cette fonction est appelée par l'interface graphique lorsqu'une touche du clavier est relachée.
  Les arguments sont le jeu en cours, la touche relachée sous la forme d'une chaine et sous forme d'un code
  spécifique à labltk.
  
  Le code fourni initialement permet juste d'afficher les touches appuyées au clavier afin de pouvoir
  les identifiées facilement dans nos traitements.

  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @param keyString nom de la touche relachée.
  @param keyCode code entier de la touche relachée.   
  @author KERAN JOYEUX
*)
let canvas_keyreleased(game, keyString, keyCode : t_camlbrick * string * int) =
  if game.state = PLAYING then
    match keyCode with
    | 65361 -> 
    paddle_move_left game
    | 65363 -> 
    paddle_move_right game
    | 97 -> 
    paddle_move_left game
    | 100 -> 
    paddle_move_right game
    | _ -> ()
;;

(**
  Cette fonction est utilisée par l'interface graphique pour connaitre l'information
  l'information à afficher dans la zone Custom1 de la zone du menu.
*)
let custom1_text() : string =
  (* Iteration 4 *)
  "<La palette se déplace\n" ^
  "avec les touches a, d, ou\n" ^
  "les flèches droite et gauche\n" ^
  "de votre clavier>"
;;

(**
  Cette fonction est utilisée par l'interface graphique pour connaitre l'information
  l'information à afficher dans la zone Custom2 de la zone du menu.
*)
let custom2_text() : string =
  (* Iteration 4 *)
  "<:)>"
;;


(**
  Cette fonction est appelée par l'interface graphique lorsqu'on clique sur le bouton
  de la zone de menu et que ce bouton affiche "Start".

  
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
*)
let start_onclick(game : t_camlbrick) : unit=
  game.state <- PLAYING
;;

(**
  Cette fonction est appelée par l'interface graphique lorsqu'on clique sur le bouton
  de la zone de menu et que ce bouton affiche "Stop".

  
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let stop_onclick(game : t_camlbrick) : unit =
  game.state <- PAUSING
;;  


(** Fonction pour calculer la magnitude de la vitesse d'une balle 
   @author KERAN JOYEUX
*)
let speed_of_ball ball =
  let vx = float_of_int ball.velocity.x in
  let vy = float_of_int ball.velocity.y in
  sqrt (vx *. vx +. vy *. vy)
;;


(**
  Cette fonction est appelée par l'interface graphique pour connaitre la valeur
  du slider Speed dans la zone du menu.

  Vous pouvez donc renvoyer une valeur selon votre désir afin d'offrir la possibilité
  d'interagir avec le joueur.
*)
(** Fonction pour obtenir la vitesse moyenne de toutes les balles dans le jeu 
   @author CASTRO MATIAS
   @author KERAN JOYEUX
*)
let speed_get (game : t_camlbrick) : int =
  let sum_speed = List.fold_left (fun acc ball ->
    acc +. speed_of_ball ball
  ) 0.1 game.balls in
  let count = List.length game.balls in
  if count = 0 then 0 else int_of_float (sum_speed /. float_of_int count)
;;


(**
  Cette fonction est appelée par l'interface graphique pour indiquer que le 
  slide Speed dans la zone de menu a été modifiée. 
  
  @author CASTRO MATIAS
*)
let speed_change(game, xspeed : t_camlbrick * int) : unit =
  game.balls <- List.map (fun ball ->
    let new_velocity_x = ball.velocity.x + 5 in
    let new_velocity_y = ball.velocity.y + 5 in
    ball.velocity <- {
      x = new_velocity_x;  
      y = new_velocity_y
    };
    ball
  ) game.balls
;;

(** Déplace toutes les balles dans le jeu en fonction de leur vitesse actuelle.

    @param game le jeu contenant les balles à déplacer
    @author CASTRO MATIAS
*)
let move_balls(game : t_camlbrick) : unit =
  List.iter (fun ball ->
    let new_position = vec2_add (ball.position, ball.velocity) in
    ball.position <- new_position;  
  ) game.balls
;;


(**
  @author CASTRO MATIAS   
  @author KERAN JOYEUX  
*)
let handle_collisions(game : t_camlbrick) : unit =
  List.iter (fun ball ->
    (* Collisions avec les bords de la zone de jeu *)
    if ball.position.x <= 0 || ball.position.x >= game.param.world_width then
      ball.velocity.x <- -(ball.velocity.x);
    if ball.position.y <= 0 then
      ball.velocity.y <- -(ball.velocity.y);
    

    (* Collisions avec la palette *)
    ball_hit_paddle(game, ball, game.paddle);

    (* Collisions avec les briques *)
    for i = 0 to (Array.length game.bricks) - 1 do
      for j = 0 to (Array.length game.bricks.(0)) - 1 do
        let brick = game.bricks.(i).(j) in
        if brick <> BK_empty && (ball_hit_corner_brick(game, ball, i, j) || ball_hit_side_brick(game, ball, i, j)) then
          let _ = brick_hit(game, i, j) in
          (* Ajuster la direction de la balle après la collision avec la brique *)
          ball.velocity.y <- -(ball.velocity.y)
      done;
    done;
  ) game.balls
;;

(**
  @author CASTRO MATIAS     

let update_game_state(game : t_camlbrick) : unit =
  (* Supprimer les balles qui sortent des limites inférieures *)
  game.balls <- ball_remove_out_of_border(game, game.balls);
  
  (* Vérifier si le jeu est terminé *)
  if List.length game.balls = 0 then
    game.state <- GAMEOVER
  else
    (* Vérifier si toutes les briques ont été détruites pour la victoire *)
    let bricks_left = Array.exists (fun row -> Array.exists ((<>) BK_empty) row) game.bricks in
    if not bricks_left then
      game.state <- GAMEOVER  (* Ou un autre état représentant la victoire *)
;;*)

let animate_action(game : t_camlbrick) : unit =  
  (** Iteration 1,2,3 et 4
    Cette fonction est appelée par l'interface graphique à chaque frame
    du jeu vidéo.
    Vous devez mettre tout le code qui permet de montrer l'évolution du jeu vidéo.  
    @author KERAN JOYEUX  
    @author CASTRO MATIAS
  *)
  if game.state = PLAYING then begin
    move_balls game;
    handle_collisions game;
  end
;;
