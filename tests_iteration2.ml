(**@Author CASTRO MENDOZA, Matias*)
(**@Author JOYEUX KERAN*)
(**#use "camlbrick.ml";;*)
(**J'importe mon fichier camlbrick.ml mais sans OUnit2 
je peux l'utiliser mais lorsque j'utilise OUnit, cela 
ne me permet pas de l'utiliser, cela me donne une erreur, 
donc c'est pour cela que j'ai apporté les fonctions et les ai testées.
*)
(**IL FAUT AVOIR OUNIT2 INSTALLÉ POUR UTILISER*)
open OUnit2;;


(**///////////////////////////////////////////////////TYPE///////////////////////////////////////////////////////*)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
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
  position : t_vec2; (** Position de la balle dans le monde *)
  mutable velocity : t_vec2; (** Vecteur vitesse de la balle *)
  size : t_ball_size; (** Taille de la balle *)
};;
type t_camlbrick = {  mutable param : t_camlbrick_param; (** Paramètres du jeu *)
                      state : t_gamestate;
                      mutable bricks : t_brick_kind array array;
                      mutable paddle : t_paddle;
                      mutable ball : t_ball list;
};;



(**/////////////////////////////////////////////FUNCTIONS///////////////////////////////////////////////////////*)

let make_vec2(x,y : int * int) : t_vec2 = 
  (* Itération 1 *)
  { x = x; y = y }
;;

let vec2_mult(a,b : t_vec2 * t_vec2) : t_vec2 = 
  (* Itération 1 *)
  { x = a.x * b.x; y = a.y * b.y }
;;

(*make_paddle*)
let make_paddle() : t_paddle =
  (* Itération 2 *)
  { paddle_x = 400(* calculer la position x au milieu de l'écran *) ;
    paddle_size = PS_MEDIUM (* taille par défaut, tu peux ajuster si nécessaire *) }
;;

(*make_ball*)
let make_ball(x,y, size : int * int * int) : t_ball =
  (* Itération 3 *)
  { position = make_vec2(x, y); (* Crear un vector 2D para la posición *)
    velocity = { x = 0; y = 0 }; (* Inicializar la velocidad a cero *)
    size = match size with
      | 1 -> BS_SMALL
      | 2 -> BS_MEDIUM
      | 3 -> BS_BIG
      | _ -> BS_MEDIUM (* Taille moyenne par défaut en cas de valeur incorrecte *) }
;;

(*paddle_x*)
let paddle_x(game : t_camlbrick) : int= 
  (* Itération 2 *)
  game.paddle.paddle_x
;;

(*paddle_size_pixel*)
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


(*paddle_move_left*)
let paddle_move_left(game : t_camlbrick) : unit = 
  let paddle = game.paddle in
  let move_amount = 10 (* Nombre de pixels à déplacer *) in
  let min_x = 0 (* Coordonnée x minimale autorisée, bord de l'écran *) in
    paddle.paddle_x <- max min_x (paddle.paddle_x - move_amount)
;;

(*paddle_move_right*)
(**
let paddle_move_right(game : t_camlbrick) : unit = 
  let paddle = game.paddle in
  let move_amount = 10 (* Quantité de pixels à déplacer *) in
  let max_x = game.param.world_width - paddle_size_pixel(game)  (* Coordonnée x maximale autorisée, bord de l'écran *) in
  let paddle_right = paddle.paddle_x + paddle_size_pixel(game) in
  let new_paddle_right = paddle_right + move_amount in (* Nouvelle position du bord droit de la palette *)
    (*afin que la coordonnée ne dépasse pas la limite*)
  paddle.paddle_x <- min max_x new_paddle_right
;;
*)

let paddle_move_right (game : t_camlbrick) : unit = 
  let paddle = game.paddle in
  let move_amount = 10 (* Nombre de pixels à déplacer *) in
  let max_x = game.param.world_width - paddle_size_pixel game in
  let new_paddle_right = paddle.paddle_x + move_amount in (* Nouvelle position du bord droit de la palette *)
  (*afin que la coordonnée ne dépasse pas la limite*)
  paddle.paddle_x <- min max_x new_paddle_right
;;


(*has_ball*)
let has_ball(game : t_camlbrick) : bool =
  (* Itération 2 *)
  match game.ball with
  | [] -> false  (* Il n'y a pas de balles dans le jeu *)
  | _ -> true    (* Il y a au moins une balle dans le jeu *)
;;

(*balls_count*)
let balls_count(game : t_camlbrick) : int =
  (* Itération 2 *)
  List.length game.ball
;;

(*balls_get*)
let balls_get(game : t_camlbrick) : t_ball list = 
  (* Itération 2 *)
  game.ball
;;

(*ball_get_i*)
let ball_get_i(game, i : t_camlbrick * int) : t_ball =
  (* Itération 2 *)
  List.nth game.ball i
;;

(*ball_x*)
let ball_x(game,ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.x
;;

(*ball_y*)
let ball_y(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  ball.position.y
;;

(*ball_size_pixel*)
let ball_size_pixel(game, ball : t_camlbrick * t_ball) : int =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> 10   (* Taille du cercle pour une petite balle *)
  | BS_MEDIUM -> 20  (* Taille du cercle pour une balle de taille moyenne *)
  | BS_BIG -> 30     (* Taille du cercle pour une grande balle *)
;;

(*ball_color*)
let ball_color(game, ball : t_camlbrick * t_ball) : t_camlbrick_color =
  (* Itération 2 *)
  match ball.size with
  | BS_SMALL -> GRAY    (* Couleur pour les petites balles *)
  | BS_MEDIUM -> CYAN     (* Couleur pour les balles de taille moyenne *)
  | BS_BIG -> MAGENTA     (* Couleur pour les grandes balles *)
;;

(*ball_modif_speed*)
let ball_modif_speed(game, ball, dv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  ball.velocity <- { x = ball.velocity.x + dv.x; y = ball.velocity.y + dv.y }
;;


(*is_inside_circle*)
let is_inside_circle(cx,cy,rad, x, y : int * int * int * int * int) : bool =
  (* Itération 3 *)
  let distance_squared = (x - cx) * (x - cx) + (y - cy) * (y - cy) in
  let radius_squared = rad * rad in
  distance_squared <= radius_squared
;;

(*is_inside_quad*)
let is_inside_quad(x1,y1,x2,y2, x,y : int * int * int * int * int * int) : bool =
  (* Itération 3 *)
  x >= x1 && x <= x2 && y >= y1 && y <= y2
;;

(*ball_modif_speed_sign*)
let ball_modif_speed_sign(game, ball, sv : t_camlbrick * t_ball * t_vec2) : unit =
  (* Itération 3 *)
  let new_velocity = vec2_mult(ball.velocity, sv) in
  ball.velocity <- new_velocity
;;



(**/////////////////////////////////////////////TEST///////////////////////////////////////////////////////*)

            (*make_ball*)
let test_make_ball test_ctxt =
  let ball = make_ball (10, 20, 2) in
  assert_equal ball.position.x 10;
  assert_equal ball.position.y 20;
  assert_equal ball.velocity.x 0;
  assert_equal ball.velocity.y 0;
  assert_equal ball.size BS_MEDIUM



            (*test_paddle_x_returns_initial_value*)
let test_paddle_x_returns_initial_value test_ctxt =
  let paddle = make_paddle() in
  let game = { param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
                          brick_width = 50; brick_height = 20; paddle_init_width = 100;
                          paddle_init_height = 20; time_speed = ref 0 };
                state = PLAYING;
                bricks = [|[||]|];
                paddle;
                ball = [] } in
  assert_equal (paddle_x game) 400 ~printer:string_of_int
;;

              (*test_paddle_size_pixel_returns_correct_values*)
let test_paddle_size_pixel_returns_correct_values test_ctxt =
  let game = { 
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
                          brick_width = 50; brick_height = 20; paddle_init_width = 100;
                          paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 0; paddle_size = PS_MEDIUM };
    ball = [] } in
  assert_equal (paddle_size_pixel game) 75 ~printer:string_of_int
;;

                (*test_paddle_move_left_moves_paddle_left*)
let test_paddle_move_left_moves_paddle_left test_ctxt =
  let initial_paddle_x = 50 in
  let game = { 
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = initial_paddle_x; paddle_size = PS_MEDIUM };
    ball = [] } in
  paddle_move_left game;
  assert_equal game.paddle.paddle_x (initial_paddle_x - 10) ~printer:string_of_int
;;

                  (*test_paddle_move_right_moves_paddle_right*)
let test_paddle_move_right_moves_paddle_right test_ctxt =
  let initial_paddle_x = 50 in
  let game = { 
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = initial_paddle_x; paddle_size = PS_MEDIUM };
    ball = [] } in
  paddle_move_right game;
  assert_equal game.paddle.paddle_x (initial_paddle_x + 10) ~printer:string_of_int
;;

                  (*test_has_ball_returns_false_when_no_ball*)
let test_has_ball_returns_false_when_no_ball test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [] } in
  assert_equal false (has_ball game)
;;

                  (*test_has_ball_returns_true_when_ball_present*)
let test_has_ball_returns_true_when_ball_present test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 100 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal true (has_ball game)
;;

                  (*test_balls_count_returns_correct_number*)
let test_balls_count_returns_correct_number test_ctxt =
  let game_no_balls = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [] } in
  assert_equal 0 (balls_count game_no_balls);

  let game_with_balls = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 100 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal 1 (balls_count game_with_balls)
;;

                  (*test_balls_get_returns_correct_list*)
let test_balls_get_returns_correct_list test_ctxt =
  let expected_balls = [{ position = { x = 100; y = 100 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] in
  let game_with_balls = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = expected_balls } in
  assert_equal expected_balls (balls_get game_with_balls)
;;

                  (*test_ball_x_returns_correct_value*)
let test_ball_x_returns_correct_value test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal 100 (ball_x (game, List.hd game.ball))

                  (*test_ball_y_returns_correct_value*)
let test_ball_y_returns_correct_value test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal 200 (ball_y (game, List.hd game.ball))

                  (*test_ball_size_pixel_returns_correct_value*)
let test_ball_size_pixel_returns_correct_value test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal 20 (ball_size_pixel (game, List.hd game.ball))

                  (*test_ball_color_returns_correct_value*)
let test_ball_color_returns_correct_value test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  assert_equal CYAN (ball_color (game, List.hd game.ball))


                  (*test_ball_modif_speed_changes_velocity*)
let test_ball_modif_speed_changes_velocity test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 0; y = 0 }; size = BS_MEDIUM }] } in
  ball_modif_speed (game, List.hd game.ball, { x = 10; y = 20 });
  assert_equal { x = 10; y = 20 } (List.hd game.ball).velocity

                  (*test_ball_modif_speed_sign_changes_velocity*)
let test_ball_modif_speed_sign_changes_velocity test_ctxt =
  let game = {
    param = { world_width = 800; world_bricks_height = 600; world_empty_height = 200;
              brick_width = 50; brick_height = 20; paddle_init_width = 100;
              paddle_init_height = 20; time_speed = ref 0 };
    state = PLAYING;
    bricks = [|[||]|];
    paddle = { paddle_x = 400; paddle_size = PS_MEDIUM };
    ball = [{ position = { x = 100; y = 200 }; velocity = { x = 10; y = 20 }; size = BS_MEDIUM }] } in
  ball_modif_speed_sign (game, List.hd game.ball, { x = -1; y = -1 });
  assert_equal { x = -10; y = -20 } (List.hd game.ball).velocity


                  (*test_is_inside_circle_returns_true_inside, outside, boundary*)
let test_is_inside_circle _ =
  assert_equal true (is_inside_circle (0, 0, 5, 3, 4));    
  assert_equal false (is_inside_circle (0, 0, 5, 7, 8));   
  assert_equal true (is_inside_circle (0, 0, 5, 0, 0));    
  assert_equal true (is_inside_circle (2, 2, 2, 3, 3))     
;;


let suite =
  "suite">::: [
    "test_make_ball">:: test_make_ball;
    "test_paddle_x_returns_initial_value">:: test_paddle_x_returns_initial_value;
    "test_paddle_size_pixel_returns_correct_values">:: test_paddle_size_pixel_returns_correct_values;
    "test_paddle_move_left_moves_paddle_left">:: test_paddle_move_left_moves_paddle_left;
    "test_paddle_move_right_moves_paddle_right">:: test_paddle_move_right_moves_paddle_right;
    "test_has_ball_returns_false_when_no_ball">:: test_has_ball_returns_false_when_no_ball;
    "test_has_ball_returns_true_when_ball_present">:: test_has_ball_returns_true_when_ball_present;
    "test_balls_count_returns_correct_number">:: test_balls_count_returns_correct_number;
    "test_balls_get_returns_correct_list">:: test_balls_get_returns_correct_list;
    "test_ball_x_returns_correct_value">:: test_ball_x_returns_correct_value;
    "test_ball_y_returns_correct_value">:: test_ball_y_returns_correct_value;
    "test_ball_size_pixel_returns_correct_value">:: test_ball_size_pixel_returns_correct_value;
    "test_ball_color_returns_correct_value">:: test_ball_color_returns_correct_value;
    "test_ball_modif_speed_changes_velocity">:: test_ball_modif_speed_changes_velocity;
    "test_ball_modif_speed_sign_changes_velocity">:: test_ball_modif_speed_sign_changes_velocity;
    "test_is_inside_circle">:: test_is_inside_circle;
    ]

let () =
  run_test_tt_main suite
