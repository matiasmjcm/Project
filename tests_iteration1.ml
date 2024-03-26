(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Test unitaire pour vérifier l'initialisation de t_vec2 *)
let test_initialization () =
  let v = { x = 3; y = 4 } in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)

(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Définition de la fonction make_vec2 *)
let make_vec2 (x, y : int * int) : t_vec2 = 
  { x = x; y = y }

(* Test unitaire pour vérifier make_vec2 *)
let test_make_vec2 () =
  let v = make_vec2 (3, 4) in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)


(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Définition de la fonction vec2_add *)
let vec2_add (a, b : t_vec2 * t_vec2) : t_vec2 =
  { x = a.x + b.x; y = a.y + b.y }

(* Définition du test unitaire pour vérifier vec2_add *)
let test_vec2_add () =
  let v1 = { x = 3; y = 4 } in
  let v2 = { x = 1; y = 2 } in
  let result = vec2_add (v1, v2) in
  assert (result.x = 4);
  assert (result.y = 6)

(* Test unitaire pour vérifier l'initialisation de t_vec2 *)
let test_initialization () =
  let v = { x = 3; y = 4 } in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)


(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Définition de la fonction vec2_add_scalar *)
let vec2_add_scalar (a, x, y : t_vec2 * int * int) : t_vec2 =
  (* Création du vecteur scalaire à partir de (x, y) *)
  let scalar_vector = { x = x; y = y } in
  (* Addition des composantes *)
  let result_x = a.x + scalar_vector.x in
  let result_y = a.y + scalar_vector.y in
  { x = result_x; y = result_y }

(* Définition du test unitaire pour vérifier vec2_add_scalar *)
let test_vec2_add_scalar () =
  let v = { x = 3; y = 4 } in
  let x = 1 in
  let y = 2 in
  let result = vec2_add_scalar (v, x, y) in
  assert (result.x = 4);
  assert (result.y = 6)

(* Test unitaire pour vérifier l'initialisation de t_vec2 *)
let test_initialization () =
  let v = { x = 3; y = 4 } in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)

(* Exécution de tous les tests *)
let () =
  print_endline "Exécution des tests...";
  test_initialization ();
  test_access_fields ();
  test_vec2_add_scalar ();
  print_endline "Tous les tests ont réussi."


(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Définition de la fonction vec2_mult *)
let vec2_mult (a, b : t_vec2 * t_vec2) : t_vec2 =
  { x = a.x * b.x; y = a.y * b.y }

(* Définition du test unitaire pour vérifier vec2_mult *)
let test_vec2_mult () =
  let v1 = { x = 3; y = 4 } in
  let v2 = { x = 2; y = 5 } in
  let result = vec2_mult (v1, v2) in
  assert (result.x = 6);
  assert (result.y = 20)

(* Test unitaire pour vérifier l'initialisation de t_vec2 *)
let test_initialization () =
  let v = { x = 3; y = 4 } in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)


(* Définition de la structure t_vec2 *)
type t_vec2 = {
  x : int; (** Composante en x du vecteur *)
  y : int; (** Composante en y du vecteur *)
}

(* Définition de la fonction vec2_mult_scalar *)
let vec2_mult_scalar (a, x, y : t_vec2 * int * int) : t_vec2 =
  (* Création du vecteur scalaire à partir de (x, y) *)
  let scalar_vector = { x = x; y = y } in
  (* Multiplication des composantes *)
  let result_x = a.x * scalar_vector.x in
  let result_y = a.y * scalar_vector.y in
  { x = result_x; y = result_y }

(* Définition du test unitaire pour vérifier vec2_mult_scalar *)
let test_vec2_mult_scalar () =
  let v = { x = 3; y = 4 } in
  let x = 2 in
  let y = 3 in
  let result = vec2_mult_scalar (v, x, y) in
  assert (result.x = 6);
  assert (result.y = 12)

(* Test unitaire pour vérifier l'initialisation de t_vec2 *)
let test_initialization () =
  let v = { x = 3; y = 4 } in
  assert (v.x = 3);
  assert (v.y = 4)

(* Test unitaire pour vérifier l'accès aux champs de t_vec2 *)
let test_access_fields () =
  let v = { x = 3; y = 4 } in
  assert (v.x + v.y = 7)


(* Définition du type t_camlbrick_param *)
type t_camlbrick_param = {
  mutable world_width : int;
  mutable world_bricks_height : int;
  mutable world_empty_height : int;
  mutable brick_width : int;
  mutable brick_height : int;
  mutable paddle_init_width : int;
  mutable paddle_init_height : int;
  mutable time_speed : int ref;
}

(* Définition du type t_camlbrick *)
type t_camlbrick = {
  mutable param : t_camlbrick_param; (** Paramètres du jeu *)
}

(* Fonction de création d'un t_camlbrick_param *)
let make_camlbrick_param () : t_camlbrick_param =
  {
    world_width = 800;
    world_bricks_height = 600;
    world_empty_height = 200;
    brick_width = 40;
    brick_height = 20;
    paddle_init_width = 100;
    paddle_init_height = 20;
    time_speed = ref 20;
  }

(* Fonction de création d'un t_camlbrick *)
let make_camlbrick () : t_camlbrick =
  let params = make_camlbrick_param () in
  { param = params }

(* Test unitaire pour vérifier la création et la mutation des paramètres d'un t_camlbrick *)
let test_make_camlbrick_creation_and_mutation () =
  let brick = make_camlbrick () in
  assert (brick.param.world_width = 800);
  assert (brick.param.world_bricks_height = 600);
  assert (brick.param.world_empty_height = 200);
  assert (brick.param.brick_width = 40);
  assert (brick.param.brick_height = 20);
  assert (brick.param.paddle_init_width = 100);
  assert (brick.param.paddle_init_height = 20);
  assert (!brick.param.time_speed = 20);
  (* Mutabilité des champs *)
  brick.param.world_width <- 1000;
  brick.param.time_speed := 30;
  assert (brick.param.world_width = 1000);
  assert (!brick.param.time_speed = 30)



(* Exécution de tous les tests *)
let () =
  print_endline "Exécution des tests...";
  test_make_camlbrick_creation_and_mutation ();
  test_initialization ();
  test_access_fields ();
  test_vec2_mult_scalar ();
  test_vec2_mult ();
  test_vec2_add ();
  test_make_vec2 ();
  print_endline "Tous les tests ont réussi."

