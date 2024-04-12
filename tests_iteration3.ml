(**@Author CASTRO MENDOZA, Matias*)
(**@Author JOYEUX KERAN*)
(**#use "camlbrick.ml";;*)
(**Je importe mon fichier camlbrick.ml mais sans OUnit2 
je peux l'utiliser mais lorsque j'utilise OUnit, cela 
ne me permet pas de l'utiliser, cela me donne une erreur, 
donc c'est pour cela que j'ai apporté les fonctions et les ai testées.
*)
(**IL FAUT AVOIR OUNIT2 INSTALLÉ POUR UTILISER*)
open OUnit2;;


(**///////////////////////////////////////////////////TYPE///////////////////////////////////////////////////////*)
type t_vec2 = {
  mutable x : int; (** Composante en x du vecteur *)
  mutable y : int; (** Composante en y du vecteur *)
};;

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
type t_camlbrick_color = WHITE | BLACK | GRAY | LIGHTGRAY | DARKGRAY | BLUE | RED | GREEN | YELLOW | CYAN | MAGENTA | ORANGE | LIME | PURPLE;;
type t_gamestate = GAMEOVER | PLAYING | PAUSING;;
type t_brick_kind = BK_empty | BK_simple | BK_double | BK_block | BK_bonus;;
type t_paddle_size = PS_SMALL | PS_MEDIUM | PS_BIG;;
type t_ball_size = BS_SMALL | BS_MEDIUM | BS_BIG;;
type t_paddle = { mutable paddle_x : int; (** Position horizontale de la palette *)
                  mutable paddle_size : t_paddle_size; (** taille de la palette *)
};;
type t_ball = {
  mutable position : t_vec2; (** Position de la balle dans le monde *)
  mutable velocity : t_vec2; (** Vecteur vitesse de la balle *)
  size : t_ball_size; (** Taille de la balle *)
};;
type t_camlbrick = {  mutable param : t_camlbrick_param; (** Paramètres du jeu *)
                      mutable state : t_gamestate;
                      mutable bricks : t_brick_kind array array;
                      mutable paddle : t_paddle;
                      mutable ball : t_ball list;
};;



(**/////////////////////////////////////////////FUNCTIONS///////////////////////////////////////////////////////*)

let make_vec2(x,y : int * int) : t_vec2 = 
  (* Itération 1 *)
  { x = x; y = y }
;;

let is_inside_quad(x1,y1,x2,y2, x,y : int * int * int * int * int * int) : bool =
  (* Itération 3 *)
  x >= x1 && x <= x2 && y >= y1 && y <= y2
;;

let is_inside_circle(cx,cy,rad, x, y : int * int * int * int * int) : bool =
  (* Itération 3 *)
  let distance_squared = (x - cx) * (x - cx) + (y - cy) * (y - cy) in
  let radius_squared = rad * rad in
  distance_squared <= radius_squared
;;

let ball_size_pixel(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> 10   (* Taille du cercle pour une petite balle *)
  | BS_MEDIUM -> 20  (* Taille du cercle pour une balle de taille moyenne *)
  | BS_BIG -> 30     (* Taille du cercle pour une grande balle *)
;;

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
   Supprime les balles sorties de l'écran de jeu.
   @param game : Instance du jeu.
   @param balls : Liste des balles à filtrer.
   @return : Liste filtrée des balles restantes.
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
(* lire l'énoncé choix à faire *)
let ball_hit_side_brick(game, ball, i, j : t_camlbrick * t_ball * int * int) : bool =
  let brick_x = i * game.param.brick_width and brick_y = j * game.param.brick_height in
  (**let ball_radius = ball.size |> ball_size_to_pixels in*)
  is_inside_quad(brick_x, brick_y, brick_x + game.param.brick_width, brick_y + game.param.brick_height,
                 ball.position.x, ball.position.y) &&
  not (ball_hit_corner_brick(game, ball, i, j))
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

let brick_hit(game, i, j : t_camlbrick * int * int)  : t_brick_kind = 
  let brick = brick_get(game, i, j) in
  match brick with
    | BK_simple -> BK_empty (* La brique simple disparaît *)
    | BK_double -> BK_simple (* La brique double se transforme en simple *)
    | BK_block -> BK_block (* Le bloc ne peut pas être détruit *)
    | BK_bonus -> BK_empty (* La brique bonus disparaît et l'action correspondante est gérée en dehors de cette fonction *)
    | BK_empty -> BK_empty (* L'espace vide reste vide *)
;;


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

let game_test_hit_balls(game, balls : t_camlbrick * t_ball list) : unit =
  List.iter (fun ball ->
    (* Vérifier les collisions avec chaque brique. *)
    for j = 0 to (Array.length game.bricks) - 1 do
      for i = 0 to (Array.length game.bricks.(j)) - 1 do
        if brick_get(game, i, j) <> BK_empty then (
          (* S'il y a collision avec un coin ou un côté, gérer la collision. *)
          if ball_hit_corner_brick(game, ball, i, j) || ball_hit_side_brick(game, ball, i, j) then (
            ignore (brick_hit(game, i, j));  (* Mettre à jour l'état de la brique. *)
            (* Ajuster la direction de la balle en fonction du type de collision. *)
            (* Ici, on pourrait ajouter une logique supplémentaire pour ajuster la direction de la balle. *)
          )
        )
      done;
    done;

    (* Vérifier la collision avec la raquette. *)
    ball_hit_paddle(game, ball, game.paddle);
  ) balls
;;


let vec2_add(a,b : t_vec2 * t_vec2) : t_vec2 =
  (* Itération 1 *)
  { x = a.x + b.x; y = a.y + b.y }
;;


let move_balls(game : t_camlbrick) : unit =
  game.ball <- List.map (fun ball ->
    let new_position = vec2_add (ball.position, ball.velocity) in
    ball.position <- new_position;
    ball
  ) game.ball
;;

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


let animate_action(game : t_camlbrick) : unit =
  if game.state = PLAYING then begin
    move_balls game;
    handle_collisions game;
    update_game_state game;
  end
;;

(**/////////////////////////////////////////////GAME-GENERAL///////////////////////////////////////////////////////*)


let make_game () = {
  param = {
    world_width = 800;  (* Largeur du monde *)
    world_bricks_height = 400;  (* Hauteur des briques dans le monde *)
    world_empty_height = 200;  (* Hauteur vide dans le monde *)
    brick_width = 40;  (* Largeur d'une brique *)
    brick_height = 20;  (* Hauteur d'une brique *)
    paddle_init_width = 100;  (* Largeur initiale de la palette *)
    paddle_init_height = 20;  (* Hauteur initiale de la palette *)
    time_speed = ref 20;  (* Vitesse de temps *)
  };
  state = PLAYING;  (* État initial du jeu *)
  bricks = Array.make_matrix 20 10 BK_empty;  (* Matrice de briques vide pour simplifier *)
  paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };  (* Configuration de la palette *)
  ball = [];  (* Liste initiale de balles vide *)
}



(**/////////////////////////////////////////////TEST///////////////////////////////////////////////////////*)

(* Test pour vérifier que seules les balles au-dessus de world_empty_height sont supprimées *)
let test_ball_remove_out_of_border _ =
  let game = {
    param = {
      world_width = 800;
      world_bricks_height = 400;
      world_empty_height = 200;
      brick_width = 40;
      brick_height = 20;
      paddle_init_width = 100;
      paddle_init_height = 20;
      time_speed = ref 20;
    };
    state = PLAYING;
    bricks = [||]; (* En supposant l'initialisation de la matrice des briques *)
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = []; (* Liste initiale de balles vide *)
  } in

  let balls = [
    make_ball (100, 180, 2);  (* Doit être supprimée, car elle est en dessous de world_empty_height *)
    make_ball (200, 220, 2); (* Doit rester, car elle est au-dessus de world_empty_height *)
  ] in

  let expected_balls_remaining = 1 in
  let filtered_balls = ball_remove_out_of_border (game, balls) in
  assert_equal ~printer:string_of_int expected_balls_remaining (List.length filtered_balls)
;;
let test_game_behaviors _ =
  let game = {
    param = {
      world_width = 800;
      world_bricks_height = 400;
      world_empty_height = 200;
      brick_width = 40;
      brick_height = 20;
      paddle_init_width = 100;
      paddle_init_height = 20;
      time_speed = ref 20;
    };
    state = PLAYING;
    bricks = Array.make_matrix 20 10 BK_empty; (* Exemple de matrice de briques *)
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [
      make_ball (100, 180, 2);  (* Cette balle est au-dessus de world_empty_height et ne doit pas être supprimée *)
      make_ball (200, 250, 2)   (* Cette balle est en dessous de world_empty_height et doit être supprimée *)
    ];
  } in

  (* Test pour ball_remove_out_of_border *)
  let filtered_balls = ball_remove_out_of_border (game, game.ball) in
  print_endline ("Nombre de balles filtrées : " ^ string_of_int (List.length filtered_balls));
  assert_bool "ball_remove_out_of_border devrait supprimer les balles en dessous de world_empty_height" (List.length filtered_balls < List.length game.ball);


  (* Test pour is_inside_quad *)
  assert_bool "Le point est à l'intérieur du quadrilatère" (is_inside_quad (100,100,200,200,150,150));
  assert_bool "Le point est à l'extérieur du quadrilatère" (not (is_inside_quad (100,100,200,200,50,50)));

;;

let test_ball_hit_paddle _ =
  let game = {
    param = {
      world_width = 800;
      world_bricks_height = 400;
      world_empty_height = 200;
      brick_width = 40;
      brick_height = 20;
      paddle_init_width = 100;
      paddle_init_height = 20;
      time_speed = ref 20;
    };
    state = PLAYING;
    bricks = [||];  (* Attribution d'une matrice de briques vide pour simplifier *)
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };  (* Configuration de la palette *)
    ball = [];  (* Initialisation de la liste des balles vide *)
  } in

  let ball = {
    position = { x = 425; y = game.param.world_empty_height - game.param.paddle_init_height - 10 };  (* Placement de la balle pour garantir la collision *)
    velocity = { x = 5; y = -5 };  (* Vitesse initiale de la balle *)
    size = BS_MEDIUM;
  } in

  let initial_velocity_x = ball.velocity.x in

  ball_hit_paddle(game, ball, game.paddle);

  (* Vérification que la vitesse y de la balle est inversée à une valeur négative,
     et comme elle est déjà négative, vérification qu'elle est inversée si ta logique est de la refléter *)
  assert_bool "ball_hit_paddle doit inverser la vitesse y de la balle" (ball.velocity.y > 0);

  (* Vérification que la vitesse x de la balle a été ajustée. Ce test vérifie qu'il y a eu un changement. *)
  assert_bool "ball_hit_paddle doit ajuster la vitesse x de la balle" (ball.velocity.x != initial_velocity_x);
;;
let test_ball_hit_corner_brick _ =
  let game = make_game () in
  (* En supposant une configuration spécifique pour tester la collision avec le coin *)
  let ball = make_ball(40, 40, 2) in  (* Position et taille ajustées pour le test *)
  let i, j = 0, 0 in (* Indices du premier bloc *)
  assert_bool "La balle devrait frapper le coin d'un bloc" (ball_hit_corner_brick(game, ball, i, j))
;;

let test_ball_hit_side_brick _ =
  let game = make_game () in
  (* En supposant une configuration spécifique pour tester la collision avec le côté *)
  let ball = make_ball(60, 20, 2) in  (* Position ajustée pour éviter les coins *)
  let i, j = 1, 0 in (* Indices d'un bloc spécifique, à ajuster selon les besoins *)
  assert_bool "La balle devrait frapper le côté d'un bloc sans toucher les coins" (not (ball_hit_side_brick(game, ball, i, j)))
;;


(**let test_game_test_hit_balls _ =
  (* Tout d'abord, nous définissons le jeu *)
  let game = {
    param = {
      world_width = 800;
      world_bricks_height = 400;
      world_empty_height = 200;
      brick_width = 40;
      brick_height = 20;
      paddle_init_width = 100;
      paddle_init_height = 20;
      time_speed = ref 20;
    };
    state = PLAYING;
    bricks = Array.make_matrix 10 10 BK_empty;  (* Exemple : Matrice de briques, ajustez-la selon vos besoins *)
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };  (* Configuration de la palette *)
    ball = [];  (* Initialisation de la liste des balles, ajoutée plus tard *)
  } in

  (* Maintenant que le jeu est défini, nous pouvons configurer la balle *)
  let ball = {
    position = { x = 425; y = game.param.world_bricks_height - 10 };  (* Placer la balle près de la brique *)
    velocity = { x = 0; y = -10 };  (* Vitesse initiale vers le haut pour frapper la brique *)
    size = BS_MEDIUM;
  } in

  (* Ajout de la balle au jeu *)
  let () = game.ball <- [ball] in
  match game.ball with
    | [] -> assert_failure "Aucune balle dans le jeu"  (* Ou gérer d'une autre manière s'il est possible qu'il n'y ait pas de balles *)
    | first_ball :: _ ->  (* Utilisation de la correspondance de motif pour obtenir la première balle *)
        let initial_velocity_y = first_ball.velocity.y in
        (* Le reste de votre code qui utilise initial_velocity_y *)

  game_test_hit_balls (game, game.ball);

  (* Vérification que la vitesse y de la balle est inversée après avoir heurté la brique,
     ce qui indiquerait que la balle a rebondi vers le bas *)
  assert_bool "La balle devrait rebondir sur la brique et inverser sa vitesse y" ((List.hd game.ball).velocity.y > 0);

  (* Vérification que la brique a été frappée en changeant son état de BK_simple à BK_empty,
     ce qui indiquerait que la brique a été correctement détruite par la collision *)
  assert_equal BK_empty (brick_get (game, 0, 0));

  let updated_velocity_y = (List.hd game.ball).velocity.y in
  assert_bool "La vitesse Y devrait changer" (initial_velocity_y <> updated_velocity_y);

;;


*)


(* Conjunto de pruebas *)
let suite =
  "Project Tests" >::: [
    "test_ball_remove_out_of_border" >:: test_ball_remove_out_of_border;
    "test_game_behaviors" >:: test_game_behaviors;
    "test_ball_hit_paddle" >:: test_ball_hit_paddle;
    "test_ball_hit_corner_brick" >:: test_ball_hit_corner_brick;
    "test_ball_hit_side_brick" >:: test_ball_hit_side_brick;
  ]

(* Ejecutar pruebas *)
let () =
  run_test_tt_main suite
