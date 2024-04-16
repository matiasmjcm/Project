(*
ocamlc -o tests_iteration1 camlbrick.ml CPtest.ml tests_iteration1.ml
./tests_iteration1
*)
(* tests_iteration1.ml *)

open Camlbrick
open CPtest

let test_make_vec2 () =
  (* Démarre un nouveau cas de test *)
  let step = test_new "Test make_vec2" in

  (* Exécuter la fonction make_vec2 dans l'environnement de test contrôlé. *)
  let result = test_exec (make_vec2, "créer vecteur", (5, -3)) in

  (* Ici, nous utilisons des assertions pour vérifier que le résultat est celui attendu. *)
  (* Vérifie si le résultat contient une valeur, puis si cette valeur est correcte. *)
  if test_has_value result then
    let vector = test_get result in
    assert_equals (5, vector.x);
    assert_equals (-3, vector.y);
  else
    step.error <- Some (Test_exec_failure "Aucun vecteur n'a été renvoyé");
  test_report ();
;;

(* Tests pour vec2_add *)
let test_vec2_add () =
  let step = test_new "Test vec2_add" in
  let a = { x = 1; y = 2 } in
  let b = { x = 3; y = 4 } in
  let result = test_exec (vec2_add, "additionner les vecteurs", (a, b)) in
  if test_has_value result then
    let vector = test_get result in
    assert_equals (4, vector.x);
    assert_equals (6, vector.y);
  else
    step.error <- Some (Test_exec_failure "Aucun vecteur n'a été renvoyé");

  test_report ();
;;

(* Tests pour vec2_add_scalar *)
let test_vec2_add_scalar () =
  let step = test_new "Test vec2_add_scalar" in
  let a = { x = 1; y = 2 } in
  let result = test_exec (vec2_add_scalar, "ajouter un scalaire au vecteur", (a, 3, 4)) in
  if test_has_value result then
    let vector = test_get result in
    assert_equals (4, vector.x);
    assert_equals (6, vector.y);
  else
    step.error <- Some (Test_exec_failure "Aucun vecteur n'a été renvoyé");

  test_report ();
;;

(* Tests pour vec2_mult *)
let test_vec2_mult () =
  let step = test_new "Test vec2_mult" in
  let a = { x = 2; y = 3 } in
  let b = { x = 4; y = 5 } in
  let result = test_exec (vec2_mult, "multiplier les vecteurs", (a, b)) in
  if test_has_value result then
    let vector = test_get result in
    assert_equals (8, vector.x);
    assert_equals (15, vector.y);
  else
    step.error <- Some (Test_exec_failure "Aucun vecteur n'a été renvoyé");

  test_report ();
;;

(* Tests pour vec2_mult_scalar *)
let test_vec2_mult_scalar () =
  let step = test_new "Test vec2_mult_scalar" in
  let a = { x = 2; y = 3 } in
  let result = test_exec (vec2_mult_scalar, "multiplier le vecteur par un scalaire", (a, 4, 5)) in
  if test_has_value result then
    let vector = test_get result in
    assert_equals (8, vector.x);
    assert_equals (15, vector.y);
  else
    step.error <- Some (Test_exec_failure "Aucun vecteur n'a été renvoyé");

  test_report ();
;;


let () =
  test_reset_report ();  (* Effacer tout état de test précédent *)
  test_make_vec2 ();     (* Test pour make_vec2 *)
  test_vec2_add ();      (* Test pour vec2_add *)
  test_vec2_add_scalar (); (* Test pour vec2_add_scalar *)
  test_vec2_mult ();     (* Test pour vec2_mult *)
  test_vec2_mult_scalar (); (* Test pour vec2_mult_scalar *)
  test_report ();        
;;