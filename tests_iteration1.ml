(**@Author CASTRO MENDOZA, Matias*)
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
type t_paddle = { mutable paddle_x : int; (** position horizontale de la palette *)
                  mutable paddle_size : t_paddle_size; (** taille de la palette *)
};;
type t_ball = {
  position : t_vec2; (** Posición de la pelota en el mundo *)
  mutable velocity : t_vec2; (** Vector velocidad de la pelota *)
  size : t_ball_size; (** Tamaño de la pelota *)
};;
type t_camlbrick = {  mutable param : t_camlbrick_param; (** Paramètres du jeu *)
                      state : t_gamestate;
                      mutable bricks : t_brick_kind array array;
                      mutable paddle : t_paddle;
                      mutable ball : t_ball list;
};;

(**///////////////////////////////////////////////FUNCTIONS//////////////////////////////////////////////////////*)

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

let make_paddle() : t_paddle =
  (* Itération 2 *)
  { paddle_x = 400(* calculer la position x au milieu de l'écran *) ;
    paddle_size = PS_MEDIUM (* taille par défaut, tu peux ajuster si nécessaire *) }
;;

let make_camlbrick () : t_camlbrick =
  let paddle = make_paddle () in
  let params = make_camlbrick_param () in
  let ball = {
    position = { x = paddle.paddle_x + params.paddle_init_width / 2; y = params.world_bricks_height - params.brick_height };
    velocity = { x = 0; y = 0 };
    size = BS_MEDIUM;
  } in
  {
    param = params;
    bricks = Array.make_matrix params.world_width params.world_bricks_height BK_empty;
    state = PLAYING;
    paddle = paddle;
    ball = [ball];
  }
;;

let make_vec2(x,y : int * int) : t_vec2 = 
  (* Itération 1 *)
  { x = x; y = y }
;;

let string_of_gamestate(game : t_camlbrick) : string =
  (* Itération 1,2,3 et 4 *)
  match game.state with
  | GAMEOVER -> "GAME OVER"
  | PLAYING -> "PLAYING"
  | PAUSING -> "PAUSING"
;;

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

(**////////////////////////////////////////////TESTS 3.1/////////////////////////////////////////////////////*)


(* Définition du test unitaire pour make_vec2 *)
let test_make_vec2 () =
  let result = make_vec2 (3, 4) in
  assert (result.x = 3);
  assert (result.y = 4);
  print_endline "Test make_vec2 approuvé."
;;

(* Exécute le test unitaire *)
test_make_vec2 ();;

let vec2_add(a,b : t_vec2 * t_vec2) : t_vec2 =
  (* Itération 1 *)
  { x = a.x + b.x; y = a.y + b.y }
;;

(* Définition du test unitaire pour vérifier vec2_add *)
let test_vec2_add () =
  let v1 = { x = 3; y = 4 } in
  let v2 = { x = 1; y = 2 } in
  let result = vec2_add (v1, v2) in
  assert (result.x = 4);
  assert (result.y = 6);
  print_endline "Test vec2_add approuvé."
;;

(* Ejecuta el test unitario *)
test_vec2_add ();;

let vec2_add_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1, *)
  (* Création du vecteur à partir de (x, y) *)
  let scalar_vector = { x = x; y = y } in
  (* Addition des composantes *)
  let result_x = a.x + scalar_vector.x in
  let result_y = a.y + scalar_vector.y in
  { x = result_x; y = result_y }
;;

(* Définition du test unitaire pour vérifier vec2_add_scalar *)
let test_vec2_add_scalar () =
  let v = { x = 3; y = 4 } in
  let x = 1 in
  let y = 2 in
  let result = vec2_add_scalar (v, x, y) in
  assert (result.x = 4);
  assert (result.y = 6);
  print_endline "Test vec2_add_scalar approuvé."
;;

(* Exécute le test unitaire *)
test_vec2_add_scalar ();;

let vec2_mult(a,b : t_vec2 * t_vec2) : t_vec2 = 
  (* Itération 1 *)
  { x = a.x * b.x; y = a.y * b.y }
;;

(* Définition du test unitaire pour vérifier vec2_mult *)
let test_vec2_mult () =
  let v1 = { x = 3; y = 4 } in
  let v2 = { x = 2; y = 5 } in
  let result = vec2_mult (v1, v2) in
  assert (result.x = 6);
  assert (result.y = 20);
  print_endline "Test vec2_mult approuvé."
;;

test_vec2_mult ();;

let vec2_mult_scalar(a,x,y : t_vec2 * int * int) : t_vec2 =
  (* Itération 1 *)
  let result_x = a.x * x in
  let result_y = a.y * y in
  { x = result_x; y = result_y }
;;

(** Ça fonctionne mais le fichier OUnit2 n'est pas appelé *)
(* Définition du test pour vec2_mult_scalar *)
let test_vec2_mult_scalar _ =
  let a = { x = 3; y = 4 } in
  let x = 2 in
  let y = 3 in
  let resultado_esperado = { x = 6; y = 12 } in
  let resultado_obtenido = vec2_mult_scalar (a, x, y) in
  OUnit2.assert_equal ~printer:string_of_int resultado_esperado.x resultado_obtenido.x;
  OUnit2.assert_equal ~printer:string_of_int resultado_esperado.y resultado_obtenido.y;
  print_endline "Test vec2_mult_scalar approuvé."
;;


(**//////////////////////////////////////////////////TESTS 3.2////////////////////////////////////////////////////*)

(**Test t_camlbrick*)

let test_make_camlbrick _ =
  let camlbrick = make_camlbrick () in
  assert_equal 800 camlbrick.param.world_width;
  assert_equal 600 camlbrick.param.world_bricks_height;
  assert_equal 20 camlbrick.param.brick_height;
  assert_equal 100 camlbrick.param.paddle_init_width;
  assert_equal PLAYING camlbrick.state;
  assert_equal 400 camlbrick.paddle.paddle_x;
  assert_equal 1 (List.length camlbrick.ball);
  let ball = List.hd camlbrick.ball in
  assert_bool "La position x de la balle est incorrecte :" (ball.position.x >= 400 && ball.position.x <= 450);
  assert_equal (600 - 20) ball.position.y;
  assert_equal { x = 0; y = 0 } ball.velocity;
  assert_equal BS_MEDIUM ball.size


(* Test pour la fonction string_of_gamestate *)
let test_string_of_gamestate _ =
  let game1 = { state = GAMEOVER; bricks = [||]; param = make_camlbrick_param (); paddle = make_paddle (); ball = [] } in
  let game2 = { state = PLAYING; bricks = [||]; param = make_camlbrick_param (); paddle = make_paddle (); ball = [] } in
  let game3 = { state = PAUSING; bricks = [||]; param = make_camlbrick_param (); paddle = make_paddle (); ball = [] } in
  
  assert_equal "GAME OVER" (string_of_gamestate game1);
  assert_equal "PLAYING" (string_of_gamestate game2);
  assert_equal "PAUSING" (string_of_gamestate game3)
;;


let test_brick_get _ =
  let game = make_camlbrick () in
  (* Remplir une brique dans la matrice de briques *)
  game.bricks.(0).(0) <- BK_simple;
  
  (* Test pour une coordonnée valide *)
  assert_equal BK_simple (brick_get(game, 0, 0));
  
  (* Test pour une coordonnée en dehors de la zone des briques *)
  assert_raises (Failure "Coordonnées en dehors de la zone des briques") (fun () -> brick_get(game, -1, -1))
;;

let test_brick_hit _ =
  let game = make_camlbrick () in
  (* Remplir une brique simple dans la matrice de briques *)
  game.bricks.(0).(0) <- BK_simple;
  (* Test pour une brique simple *)
  assert_equal BK_empty (brick_hit(game, 0, 0));
  (* Remplir une brique double dans la matrice de briques *)
  game.bricks.(1).(1) <- BK_double;
  (* Test pour une brique double *)
  assert_equal BK_simple (brick_hit(game, 1, 1));
  (* Remplir un bloc dans la matrice de briques *)
  game.bricks.(2).(2) <- BK_block;
  (* Test pour un bloc *)
  assert_equal BK_block (brick_hit(game, 2, 2));
  (* Remplir une brique bonus dans la matrice de briques *)
  game.bricks.(3).(3) <- BK_bonus;
  (* Test pour une brique bonus *)
  assert_equal BK_empty (brick_hit(game, 3, 3));
  (* Test pour un espace vide *)
  assert_equal BK_empty (brick_hit(game, 4, 4))
;;

let test_brick_color _ =
  let game = make_camlbrick () in
  (* Remplir une brique de chaque type dans la matrice de briques *)
  game.bricks.(0).(0) <- BK_empty;
  game.bricks.(1).(1) <- BK_simple;
  game.bricks.(2).(2) <- BK_double;
  game.bricks.(3).(3) <- BK_block;
  game.bricks.(4).(4) <- BK_bonus;
  
  (* Test de la couleur pour une brique vide *)
  assert_equal WHITE (brick_color(game, 0, 0));
  (* Test de la couleur pour une brique simple *)
  assert_equal ORANGE (brick_color(game, 1, 1));
  (* Test de la couleur pour une brique double *)
  assert_equal BLUE (brick_color(game, 2, 2));
  (* Test de la couleur pour un bloc *)
  assert_equal GREEN (brick_color(game, 3, 3));
  (* Test de la couleur pour une brique bonus *)
  assert_equal YELLOW (brick_color(game, 4, 4))
;;

(* Configuration du jeu de tests *)
let suite =
  "Suite" >::: [
    "test_make_camlbrick" >:: test_make_camlbrick;
    "test_vec2_mult_scalar" >:: test_vec2_mult_scalar;
    "Test string_of_gamestate" >:: test_string_of_gamestate;
    "Test brick_get" >:: test_brick_get;
    "Test brick_hit" >:: test_brick_hit;
    "Test brick_color" >:: test_brick_color;
  ]

(* Exécuter le jeu de tests*)
let () = run_test_tt_main suite

