#use "camlbrick.ml"
(**open OUnit2*)

(* Définition du test unitaire pour make_vec2 *)
let test_make_vec2 () =
  let result = make_vec2 (3, 4) in
  assert (result.x = 3);
  assert (result.y = 4);
  print_endline "Test make_vec2 approuvé."
;;

(* Exécute le test unitaire *)
test_make_vec2 ();;

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

(** Ça fonctionne mais le fichier OUnit2 n'est pas appelé
(* Définition du test pour vec2_mult_scalar *)
let test_vec2_mult_scalar _ =
  let a = { x = 3; y = 4 } in
  let x = 2 in
  let y = 3 in
  let resultado_esperado = { x = 6; y = 12 } in
  let resultado_obtenido = vec2_mult_scalar (a, x, y) in
  assert_equal ~printer:string_of_int resultado_esperado.x resultado_obtenido.x;
  assert_equal ~printer:string_of_int resultado_esperado.y resultado_obtenido.y;
  print_endline "Test vec2_mult_scalar approuvé."
;;

(* Configuration du jeu de tests *)
let suite =
  "Suite" >::: [
    "Test vec2_mult_scalar" >:: test_vec2_mult_scalar;
  ]
;;

(* Configuration du jeu de tests *)
let () = run_test_tt_main suite;;



(* Test pour le type t_camlbrick *)
let test_t_camlbrick _ =
  let param = {
    world_width = 10;
    world_bricks_height = 5;
    world_empty_height = 2;
    brick_width = 20;
    brick_height = 10;
    paddle_init_width = 30;
    paddle_init_height = 15;
    time_speed = ref 1000;
  } in
  let state = PLAYING in
  let bricks = Array.make_matrix 5 10 BK_empty in
  let camlbrick = { param = param; state = state; bricks = bricks } in
  assert_equal 10 camlbrick.param.world_width;
  assert_equal 5 camlbrick.param.world_bricks_height;
  assert_equal 2 camlbrick.param.world_empty_height;
  assert_equal 20 camlbrick.param.brick_width;
  assert_equal 10 camlbrick.param.brick_height;
  assert_equal 30 camlbrick.param.paddle_init_width;
  assert_equal 15 camlbrick.param.paddle_init_height;
  assert_equal 1000 !(camlbrick.param.time_speed);
  assert_equal PLAYING camlbrick.state;
  assert_equal (Array.make_matrix 5 10 BK_empty) camlbrick.bricks;
  print_endline "Test t_camlbrick approuvé."
;;

(* Configuration du jeu de tests *)
let suite =
  "Suite" >::: [
    "Test t_camlbrick" >:: test_t_camlbrick;
  ]
;;

(* Exécuter le jeu de tests *)
let () = run_test_tt_main suite;;



(* Test pour la fonction string_of_gamestate *)
let test_string_of_gamestate _ =
  let game_over = { state = GAMEOVER } in
  let playing = { state = PLAYING } in
  let pausing = { state = PAUSING } in
  assert_equal "GAME OVER" (string_of_gamestate game_over);
  assert_equal "PLAYING" (string_of_gamestate playing);
  assert_equal "PAUSING" (string_of_gamestate pausing);
  print_endline "Test string_of_gamestate approuvé."
;;

(* Configuration du jeu de tests *)
let suite =
  "Suite" >::: [
    "Test string_of_gamestate" >:: test_string_of_gamestate;
  ]
;;

(* Ejecutar la suite de pruebas *)
let () = run_test_tt_main suite;;

*)
(**Test brick_get*)
(**Test brick_hit*)
(**Test brick_color*)