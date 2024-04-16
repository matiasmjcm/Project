(*
ocamlc -o tests_iteration3 camlbrick.ml CPtest.ml tests_iteration3.ml
./tests_iteration3
*)
(* tests_iteration3.ml *)

open Camlbrick
open CPtest

let test_speed_of_ball () =
  let ball = {
    position = { x = 0; y = 0 };
    velocity = { x = 3; y = 4 }; (* Vitesse connue, devrait donner une magnitude de 5 *)
    size = BS_SMALL
  } in
  let expected_speed = 5.0 in (* 3^2 + 4^2 = 9 + 16 = 25 -> sqrt(25) = 5 *)
  let result = speed_of_ball ball in
  assert_equals (expected_speed, result);
  test_report();
;;

let test_speed_get () =
  let game = make_camlbrick() in
  let expected_avg_speed = 5 (* (5 + 5) / 2 *) in
  let result = speed_get(game) in
  assert_equals(expected_avg_speed,result);
  test_report();
;;

let test_speed_change () =
  let initial_ball = {
    position = { x = 0; y = 0 };
    velocity = { x = 3; y = 4 };
    size = BS_SMALL;
  } in
  let game = make_camlbrick() in
  game.balls <- [initial_ball];  (* Assurez-vous que la liste de balles n'est pas vide *)
  let speed_increment = 5 in
  speed_change (game, speed_increment);
  let expected_velocity_x = initial_ball.velocity.x + speed_increment in
  let expected_velocity_y = initial_ball.velocity.y + speed_increment in
  let actual_ball = List.hd game.balls in  (* Correctement obtient la première balle *)
  let actual_velocity = actual_ball.velocity in  (* Accède à la propriété vélocité de la balle *)
  assert_equals ({ x = expected_velocity_x; y = expected_velocity_y }, actual_velocity);  (* Compare les vitesses comme un tuple *)
  test_report();  
;;

let test_handle_collisions () =
  (* Configuration initiale du jeu *)
  let game = make_camlbrick() in

  (* Exécuter la fonction qui gère les collisions *)
  handle_collisions(game);

  (* Vérification des résultats: nous nous attendons à ce que la vitesse x soit inversée *)
  let expected_velocity_x = -5 in
  let actual_velocity_x = (List.hd game.balls).velocity.x in

  assert_equals (expected_velocity_x, actual_velocity_x);
  test_report();
;;

let () = 
  test_speed_of_ball ();
  test_speed_get ();
  test_speed_change ();
  test_handle_collisions ();
;;
