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



(* Itération 1 *)
(** 
  @author CASTRO MATIAS
  @author Enzo BENNEGENT
*)
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
  @author CASTRO MATIAS
  @author Enzo BENNEGENT
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
  @author CASTRO MATIAS
  @author Enzo BENNEGENT
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
  @author CASTRO MATIAS
  @author Enzo BENNEGENT
  @author KERAN JOYEUX
*)
let vec2_add_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1, *)
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
(** 
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
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
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
  @author KERAN JOYEUX
*)
let vec2_mult_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1 *)
  let result_x = a.x * x in
  let result_y = a.y * y in
  { x = result_x; y = result_y }
;;



(* Itération 2 *)
(** 
  @author CASTRO MATIAS 
  @author Sina MIRMOHAMMADI
*)
type t_ball = {
  mutable position : t_vec2; (** Position de la balle dans le monde *)
  mutable velocity : t_vec2; (** Vecteur vitesse de la balle *)
  size : t_ball_size; (** Taille de la balle *)
};;

(* Itération 2 *)
(** 
  @author CASTRO MATIAS
  @author Sina MIRMOHAMMADI
*)
type t_paddle = { mutable paddle_x : int; (** Position horizontale de la palette *)
                  mutable paddle_size : t_paddle_size; (** Taille de la palette *)
};;


(* Itération 1, 2, 3 et 4 *)
(** 
  @author CASTRO MATIAS 
*)
type t_camlbrick = {  mutable param : t_camlbrick_param; (** Paramètres du jeu *)
                      mutable state : t_gamestate;
                      mutable bricks : t_brick_kind array array;
                      mutable paddle : t_paddle;
                      mutable ball : t_ball list;
};;


(**
  Cette fonction construit le paramétrage du jeu, avec des informations personnalisable avec les contraintes du sujet.
  Il n'y a aucune vérification et vous devez vous assurer que les valeurs données en argument soient cohérentes.
  @return Renvoie un paramétrage de jeu par défaut      
*)
let make_camlbrick_param() : t_camlbrick_param = {
  world_width = 800;
  world_bricks_height = 600;
  world_empty_height = 200;

  brick_width = 40;
  brick_height = 20;

  paddle_init_width = 100;
  paddle_init_height = 20;

  time_speed = ref 20;
}
;;

(**
  Cette fonction extrait le paramétrage d'un jeu à partir du jeu donné en argument.
  @param game jeu en cours d'exécution.
  @return Renvoie le paramétrage actuel.
  *)
(** 
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
*)
let param_get(game : t_camlbrick) : t_camlbrick_param =
  (* Itération 1 *)
  game.param
;;

(**
  Cette fonction crée une raquette par défaut au milieu de l'écran et de taille normal.  
  @deprecated Cette fonction est là juste pour le debug ou pour débuter certains traitements de test.
*)
(** 
  @author CASTRO MATIAS 
  @author Sina MIRMOHAMMADI
*)
let make_paddle() : t_paddle =
  (* Itération 2 *)
  { paddle_x = 400(* calculer la position x au milieu de l'écran *) ;
    paddle_size = PS_MEDIUM (* taille par défaut, tu peux ajuster si nécessaire *) }
;;

(**
  Cette fonction crée une nouvelle structure qui initialise le monde avec aucune brique visible.
  Une raquette par défaut et une balle par défaut dans la zone libre.
  @return Renvoie un jeu correctement initialisé
*)
(** 
  @author CASTRO MATIAS 
*)
let make_camlbrick() : t_camlbrick = 
  (* Itération 1, 2, 3 et 4 *)
  let paddle = make_paddle () in
  let params = make_camlbrick_param () in
  let ball = { 
    position = { x = int_of_float (float_of_int paddle.paddle_x +. float_of_int (params.paddle_init_width / 2)); 
                 y = params.world_bricks_height - params.brick_height };  (* Position initiale de la balle, ajustée au-dessus de la raquette*)
    velocity = { x = 0; y = 0 };  (* Vitesse initiale de la balle*)
    size = BS_MEDIUM;  (* Taille initiale de la balle*)
  } in
  { param = params; 
    bricks = Array.make_matrix params.world_width params.world_bricks_height BK_empty;
    state = PLAYING;
    paddle = paddle;
    ball = [ball]} 
;;

(** 
  @author CASTRO MATIAS 
  @author KERAN JOYEUX
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
*)
(** 
  @author CASTRO MATIAS 
*)
let string_of_gamestate(game : t_camlbrick) : string =
  (* Itération 1,2,3 et 4 *)
  match game.state with
  | GAMEOVER -> "GAME OVER"
  | PLAYING -> "PLAYING"
  | PAUSING -> "PAUSING"
;;


(** 
   Récupère le type de brique à une position donnée dans la grille de briques.
   Si les coordonnées (i, j) se trouvent à l'intérieur de la grille, renvoie le type de brique
   à cette position. Sinon, génère une erreur.
   @param game : Instance du jeu.
   @param i : Index de la colonne de la brique.
   @param j : Index de la rangée de la brique.
   @return : Le type de la brique à la position donnée.
   @raise : Failure si les coordonnées sont en dehors de la zone des briques.
*)
(** 
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
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
    failwith "Coordonnées en dehors de la zone des briques"
  ;;
  
(** 
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
*)
let brick_hit(game, i, j : t_camlbrick * int * int)  : t_brick_kind = 
  let brick = brick_get(game, i, j) in
  match brick with
    | BK_simple -> BK_empty (* La brique simple disparaît *)
    | BK_double -> BK_simple (* La brique double se transforme en simple *)
    | BK_block -> BK_block (* Le bloc ne peut pas être détruit *)
    | BK_bonus -> BK_empty (* La brique bonus disparaît et l'action correspondante est gérée en dehors de cette fonction *)
    | BK_empty -> BK_empty (* L'espace vide reste vide *)
;;

(** 
  @author CASTRO MATIAS 
  @author Enzo BENNEGENT
*)
let brick_color(game,i,j : t_camlbrick * int * int) : t_camlbrick_color = 
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


(** 
  @author CASTRO MATIAS
*)
let paddle_x(game : t_camlbrick) : int= 
  (* Itération 2 *)
  game.paddle.paddle_x
;;

(** 
  @author CASTRO MATIAS 
  creoq que se dee corregir, es por lo que no se ve el juego creeeo
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
;;

(** 
  @author CASTRO MATIAS 
  @author KERAN JOYEUX
*)
let paddle_move_left(game : t_camlbrick) : unit = 
  let paddle = game.paddle in
  let move_amount = 10 (* Nombre de pixels à déplacer *) in
  let min_x = 0 (* Coordonnée x minimale autorisée, bord de l'écran *) in
    paddle.paddle_x <- max min_x (paddle.paddle_x - move_amount)
;;

(** 
  @author CASTRO MATIAS 
  @author KERAN JOYEUX
*)
let paddle_move_right (game : t_camlbrick) : unit = 
  let paddle = game.paddle in
  let move_amount = 10 (* Quantité de pixels à déplacer *) in
  let max_x = game.param.world_width - paddle_size_pixel game in(* Coordonnée x maximale autorisée, bord de l'écran *)
  let new_paddle_right = paddle.paddle_x + move_amount in (* Nouvelle position du bord droit de la palette *)
  (*afin que la coordonnée ne dépasse pas la limite*)
  paddle.paddle_x <- min max_x new_paddle_right
;;

(** 
  @author CASTRO MATIAS 
  @author KERAN JOYEUX
*)
(*Paddle stop - NO integrated*)
let paddle_stop(game : t_camlbrick) : unit =
  (* Nous empêchons la raquette de se déplacer trop vers la gauche ou trop vers la droite *)
  let paddle = game.paddle in
  let move_amount = 0 in (* Nous ne voulons pas que la raquette se déplace *)
  let max_x = game.param.world_width - paddle_size_pixel(game) in
  let paddle_right = paddle.paddle_x + paddle_size_pixel(game) in
  let new_paddle_right = paddle_right + move_amount in
  paddle.paddle_x <- min max_x new_paddle_right;
  paddle.paddle_x <- max 0 paddle.paddle_x
;;

(** 
  @author CASTRO MATIAS 
*)
let has_ball(game : t_camlbrick) : bool =
  (* Itération 2 *)
  match game.ball with
  | [] -> false  (* Il n'y a pas de balles dans le jeu *)
  | _ -> true    (* Il y a au moins une balle dans le jeu *)
;;

(** 
  @author CASTRO MATIAS
*)
let balls_count(game : t_camlbrick) : int =
  (* Itération 2 *)
  List.length game.ball
;;

(** 
  @author CASTRO MATIAS 
*)
let balls_get(game : t_camlbrick) : t_ball list = 
  (* Itération 2 *)
  game.ball
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_get_i(game, i : t_camlbrick * int) : t_ball =
  (* Itération 2 *)
  List.nth game.ball i
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_x(game,ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.x
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_y(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.y
;;

(** 
  @author CASTRO MATIAS
*)
let ball_size_pixel(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> 10   (* Taille du cercle pour une petite balle *)
  | BS_MEDIUM -> 20  (* Taille du cercle pour une balle de taille moyenne *)
  | BS_BIG -> 30     (* Taille du cercle pour une grande balle *)
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_color(game, ball : t_camlbrick * t_ball) : t_camlbrick_color =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> GRAY    (* Couleur pour les petites balles *)
  | BS_MEDIUM -> CYAN     (* Couleur pour les balles de taille moyenne *)
  | BS_BIG -> MAGENTA     (* Couleur pour les grandes balles *)
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_modif_speed(game, ball, dv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  ball.velocity <- { x = ball.velocity.x + dv.x; y = ball.velocity.y + dv.y }
;;

(** 
  @author CASTRO MATIAS 
*)
let ball_modif_speed_sign(game, ball, sv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  let new_velocity = vec2_mult(ball.velocity, sv) in
  ball.velocity <- new_velocity
;;

(** 
  @author CASTRO MATIAS 
*)
(* On calcule la distance au carré entre le point (x, y) et le centre du cercle (cx, cy).
   Ensuite, on compare cette distance au carré avec le carré du rayon du cercle pour déterminer
   si le point est à l'intérieur du cercle. *)
let is_inside_circle(cx,cy,rad, x, y : int * int * int * int * int) : bool =
  (* Itération 3 *)
  let distance_squared = (x - cx) * (x - cx) + (y - cy) * (y - cy) in
  let radius_squared = rad * rad in
  distance_squared <= radius_squared
;;

(** 
  @author CASTRO MATIAS 
*)
let is_inside_quad(x1,y1,x2,y2, x,y : int * int * int * int * int * int) : bool =
  (* Itération 3 *)
  x >= x1 && x <= x2 && y >= y1 && y <= y2
;;

(** 
   Supprime les balles sorties de l'écran de jeu.
   @param game : Instance du jeu.
   @param balls : Liste des balles à filtrer.
   @return : Liste filtrée des balles restantes.
*)
(** 
  @author CASTRO MATIAS
  @author KERAN JOYEUX
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


(** 
   Gère la collision entre la balle et la raquette.
   Si la balle entre en collision avec la raquette, ajuste sa direction en fonction
   de la section de la raquette touchée.
   @param game : Instance du jeu.
   @param ball : La balle en mouvement.
   @param paddle : La raquette dans le jeu.
*)
(** 
  @author CASTRO MATIAS
  @author KERAN JOYEUX
*)
let ball_hit_paddle(game, ball, paddle : t_camlbrick * t_ball * t_paddle) : unit =
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


(** 
   Vérifie si la balle heurte le coin d'une brique.
   Calcule les positions des coins de la brique à partir des indices i et j,
   puis vérifie si la position de la balle se trouve à l'intérieur d'un des coins.
   @param game : Instance du jeu.
   @param ball : La balle en mouvement.
   @param i : Index de la colonne de la brique.
   @param j : Index de la rangée de la brique.
   @return : true si la balle heurte un coin de la brique, false sinon.
*)
(**
  @author CASTRO MATIAS     
*)
let ball_hit_corner_brick(game, ball, i, j : t_camlbrick * t_ball * int * int) : bool =
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


(** 
   Vérifie si la balle heurte le côté d'une brique.
   Calcule les coordonnées du coin supérieur gauche de la brique en fonction des indices i et j,
   puis vérifie si la position de la balle se trouve à l'intérieur de ce côté de la brique.
   @param game : Instance du jeu.
   @param ball : La balle en mouvement.
   @param i : Index de la colonne de la brique.
   @param j : Index de la rangée de la brique.
   @return : true si la balle heurte le côté de la brique et ne touche pas un coin, false sinon.
*)
(**
  @author CASTRO MATIAS     
*)
(* lire l'énoncé choix à faire *)
let ball_hit_side_brick(game, ball, i, j : t_camlbrick * t_ball * int * int) : bool =
  let brick_x = i * game.param.brick_width and brick_y = j * game.param.brick_height in
  (**let ball_radius = ball.size |> ball_size_to_pixels in*)
  is_inside_quad(brick_x, brick_y, brick_x + game.param.brick_width, brick_y + game.param.brick_height,
                 ball.position.x, ball.position.y) &&
  not (ball_hit_corner_brick(game, ball, i, j))
;;

(**
  @author CASTRO MATIAS     
*)
let game_test_hit_balls(game, balls : t_camlbrick * t_ball list) : unit =
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
  match button with
    | 1 -> 
      (* Le bouton gauche de la souris *)
      paddle_move_left game
    | 3 -> 
      (* Le bouton droit de la souris. *)
      paddle_move_right game
    | _ -> ()
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
  match button with  
    | 1 -> 
      (* Le bouton gauche de la souris. *)
      paddle_stop game
    | 3 -> 
      (* Le bouton droit de la souris. *)
      paddle_stop game
    | _ -> ()
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
*)
let canvas_keypressed(game, keyString, keyCode : t_camlbrick * string * int) : unit =
  print_string("Key pressed: ");
  print_string(keyString);
  print_string(" code=");
  print_int(keyCode);
  print_newline()
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
*)
let canvas_keyreleased(game, keyString, keyCode : t_camlbrick * string * int) =
  print_string("Key released: ");
  print_string(keyString);
  print_string(" code=");
  print_int(keyCode);
  print_newline()
;;

   @author CASTRO MATIAS 
   @author Sina MIRMOHAMMADI
(**
  Cette fonction est utilisée par l'interface graphique pour connaitre l'information
  l'information à afficher dans la zone Custom1 de la zone du menu.
*)
let custom1_text() : string =
  (* Iteration 4 *)
  "<Rien1>"
;;
   @author CASTRO MATIAS 
   @author Sina MIRMOHAMMADI
(**
  Cette fonction est utilisée par l'interface graphique pour connaitre l'information
  l'information à afficher dans la zone Custom2 de la zone du menu.
*)
let custom2_text() : string =
  (* Iteration 4 *)
  "<Rien2>"
;;


(**
  Cette fonction est appelée par l'interface graphique lorsqu'on clique sur le bouton
  de la zone de menu et que ce bouton affiche "Start".

  
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
*)
let start_onclick(game : t_camlbrick) : unit=
  ()
;;

(**
  Cette fonction est appelée par l'interface graphique lorsqu'on clique sur le bouton
  de la zone de menu et que ce bouton affiche "Stop".

  
  Vous pouvez réaliser des traitements spécifiques, mais comprenez bien que cela aura
  un impact sur les performances si vous dosez mal les temps de calcul.
  @param game la partie en cours.
*)
let stop_onclick(game : t_camlbrick) : unit =
  ()
;;

(**
  Cette fonction est appelée par l'interface graphique pour connaitre la valeur
  du slider Speed dans la zone du menu.

  Vous pouvez donc renvoyer une valeur selon votre désir afin d'offrir la possibilité
  d'interagir avec le joueur.
*)
let speed_get(game : t_camlbrick) : int = 
  0
;;


(**
  Cette fonction est appelée par l'interface graphique pour indiquer que le 
  slide Speed dans la zone de menu a été modifiée. 
  
  Ainsi, vous pourrez réagir selon le joueur.
*)
let speed_change(game,xspeed : t_camlbrick * int) : unit=
  (* Ajuster le vecteur de vitesse de chaque balle selon xspeed.
    xspeed pourrait être interprété de différentes manières ; ici, nous l'utilisons
    comme un facteur de multiplication directe pour simplifier. *)
    game.ball <- List.map (fun ball ->
    let adjusted_velocity_x = ball.velocity.x * xspeed / 100 in
    let adjusted_velocity_y = ball.velocity.y * xspeed / 100 in
    { ball with velocity = { x = adjusted_velocity_x; y = adjusted_velocity_y } }
  ) game.ball;
  print_endline ("Vitesse changée à : " ^ string_of_int xspeed);
;;



(**
  @author CASTRO MATIAS 
  @author Sina MIRMOHAMMADI
*)
let move_balls(game : t_camlbrick) : unit =
  game.ball <- List.map (fun ball ->
    let new_position = vec2_add (ball.position, ball.velocity) in
    ball.position <- new_position;
    ball
  ) game.ball
;;

(**
  @author CASTRO MATIAS  
  @author Sina MIRMOHAMMADI
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
  ) game.ball
;;

(**
  @author CASTRO MATIAS  
  @author Sina MIRMOHAMMADI
*)
let update_game_state(game : t_camlbrick) : unit =
  (* Supprimer les balles qui sortent des limites inférieures *)
  game.ball <- ball_remove_out_of_border(game, game.ball);
  
  (* Vérifier si le jeu est terminé *)
  if List.length game.ball = 0 then
    game.state <- GAMEOVER
  else
    (* Vérifier si toutes les briques ont été détruites pour la victoire *)
    let bricks_left = Array.exists (fun row -> Array.exists ((<>) BK_empty) row) game.bricks in
    if not bricks_left then
      game.state <- GAMEOVER  (* Ou un autre état représentant la victoire *)
;;

(**
  @author CASTRO MATIAS 
  @author Sina MIRMOHAMMADI
*)
let animate_action(game : t_camlbrick) : unit =
  if game.state = PLAYING then begin
    move_balls game;
    handle_collisions game;
    update_game_state game;
  end
;;

