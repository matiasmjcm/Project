(*
ocamlc -o tests_iteration2 camlbrick.ml CPtest.ml tests_iteration2.ml
./tests_iteration2
*)
(* tests_iteration2.ml *)

open Camlbrick
open CPtest
  
(* /////////////////////////// MAKES /////////////////////////////////// *)

let test_make_camlbrick () =
  let camlbrick = make_camlbrick () in

  (* Comprueba si hay bolas en la lista directamente en la condición *)
  match camlbrick.balls with
  | [] -> 
    failwith "Expected at least one ball, found none" 
  | ball :: _ ->  (* Accède au premier élément de manière sécurisée en utilisant le filtrage de motifs.*)
    Printf.printf "Testing ball at position (%d, %d) with velocity (%d, %d)\n"
      ball.position.x ball.position.y ball.velocity.x ball.velocity.y;
    Printf.printf "%s\n" "Je pense que j'utilise mal le CPtest pour le test de make_camlbrick, mais tous les autres tests fonctionnent normalement";


    (* Assertions sur les propriétés de la balle *)
    assert_equals (ball.position.x, camlbrick.paddle.paddle_x + (camlbrick.param.paddle_init_width / 2));
    assert_equals (ball.position.y, camlbrick.param.world_bricks_height - camlbrick.param.brick_height + 50);
    assert_equals (ball.velocity.x, 0);
    assert_equals (ball.velocity.y, 10);
    assert_equals (ball.size, BS_SMALL);
    assert_equals (camlbrick.state, PAUSING);

    (* Vérification des types de briques *)
    let valid_brick_type brick = match brick with
      | BK_empty | BK_simple | BK_double | BK_block | BK_bonus -> true
    in
    let all_bricks_valid = Array.for_all (fun row -> Array.for_all valid_brick_type row) camlbrick.bricks in
    assert_true all_bricks_valid;

    test_report () 
;;




let test_make_paddle () =
  let paddle = make_paddle () in  (* Appel de la fonction que nous voulons tester *)
  let params = make_camlbrick_param() in  (* Obtention des paramètres nécessaires *)
  let expected_x = (params.world_width / 2) - (params.paddle_init_width / 2) in
  
  (* Vérification que la position horizontale de la palette est celle attendue *)
  assert_equals (paddle.paddle_x, expected_x);

  (* Vérification que la taille de la palette est PS_MEDIUM *)
  assert_equals (paddle.paddle_size, PS_MEDIUM);

  (* Appel à test_report pour afficher les résultats des tests *)
  test_report ()
;;

let test_make_ball () =
  (* Tester plusieurs cas *)
  let test_cases = [(10, 20, 1, BS_SMALL); (30, 40, 2, BS_MEDIUM); (50, 60, 3, BS_BIG); (70, 80, 999, BS_MEDIUM)] in
  List.iter (fun (x, y, size_input, expected_size) ->
    let ball = make_ball(x, y, size_input) in
    (* Test de la position *)
    assert_equals (ball.position.x, x); 
    assert_equals (ball.position.y, y);
    (* Test de la vélocité *)
    assert_equals (ball.velocity.x, 0);
    assert_equals (ball.velocity.y, 0);
    (* Test de la taille *)
    assert_equals (ball.size, expected_size);
  ) test_cases;

  test_report ()
;;

let test_string_of_gamestate () =
  let bricks_array : Camlbrick.t_brick_kind array array =
    [|
      [| BK_simple; BK_empty; BK_simple |];
      [| BK_empty; BK_simple; BK_empty |];
      [| BK_simple; BK_empty; BK_simple |]
    |] in
  let game1 = {
    state = GAMEOVER;
    param = make_camlbrick_param();
    balls = [];
    paddle = make_paddle ();
    bricks = bricks_array;
  } in
  let game2 = {
    state = PAUSING;
    param = make_camlbrick_param ();
    balls = [];
    paddle = make_paddle ();
    bricks = bricks_array;
  } in
  let game3 = {
    state = PLAYING;
    param = make_camlbrick_param ();
    balls = [];
    paddle = make_paddle ();
    bricks = bricks_array;
  } in
    
  let result1 = string_of_gamestate(game1) in
  let result2 = string_of_gamestate(game2) in
  let result3 = string_of_gamestate(game3) in
    
  assert_equals ( "GAME OVER",  result1);
  assert_equals ( "PLAYING",  result2);
  assert_equals ( "PAUSING",  result3)
;;

(* /////////////////////////// BRICKS /////////////////////////////////// *)
(* Définition d'une fonction de test *)
let test_brick_functions () =
  let game = make_camlbrick () in  (* Initialisation de l'état du jeu *)

  (* Configuration de certains briques spécifiques pour le test *)
  game.bricks.(1).(1) <- BK_simple;
  game.bricks.(1).(2) <- BK_double;
  game.bricks.(1).(3) <- BK_bonus;
  game.bricks.(1).(4) <- BK_block;

  (* Test pour obtenir le type de brique à plusieurs positions *)
  let test_get1 = test_exec (brick_get, "Test get: Récupération de BK_simple à (1, 1)", (game, 1, 1)) in
  assert_equals_result (BK_simple, test_get1);

  let test_get2 = test_exec (brick_get, "Test get: Récupération de BK_double à (1, 2)", (game, 1, 2)) in
  assert_equals_result (BK_double, test_get2);

  let test_get3 = test_exec (brick_get, "Test get: Récupération de BK_bonus à (1, 3)", (game, 1, 3)) in
  assert_equals_result (BK_bonus, test_get3);

  let test_get4 = test_exec (brick_get, "Test get: Récupération de BK_block à (1, 4)", (game, 1, 4)) in
  assert_equals_result (BK_block, test_get4);

  (* Test pour frapper et changer le type de brique *)
  let test_hit1 = test_exec (brick_hit, "Test hit: Frapper BK_simple à (1, 1)", (game, 1, 1)) in
  assert_equals_result (BK_simple, test_hit1);
  assert_equals_result (BK_empty, test_exec (brick_get, "Vérification de l'état après le coup à (1, 1)", (game, 1, 1)));

  let test_hit2 = test_exec (brick_hit, "Test hit: Frapper BK_double à (1, 2)", (game, 1, 2)) in
  assert_equals_result (BK_double, test_hit2);
  assert_equals_result (BK_simple, test_exec (brick_get, "Vérification de l'état après le coup à (1, 2)", (game, 1, 2)));

  let test_hit3 = test_exec (brick_hit, "Test hit: Frapper BK_bonus à (1, 3)", (game, 1, 3)) in
  assert_equals_result (BK_bonus, test_hit3);
  assert_equals_result (BK_empty, test_exec (brick_get, "Vérification de l'état après le coup à (1, 3)", (game, 1, 3)));

  (* Générer le rapport des résultats *)
  test_report ()
;;

(* Definición de una función de test *)
let test_brick_color () =
  let game = make_camlbrick () in  (* Nous initialisons l'état du jeu avec la configuration de base *)

  (* Nous configurons quelques briques spécifiques pour le test. *)
  game.bricks.(1).(1) <- BK_simple;
  game.bricks.(1).(2) <- BK_double;
  game.bricks.(1).(3) <- BK_block;
  game.bricks.(1).(4) <- BK_bonus;
  game.bricks.(1).(5) <- BK_empty;  

  (* Test pour obtenir la couleur de différents types de briques. *)
  let test_color1 = test_exec (brick_color, "Test color: ORANGE for BK_simple at (1, 1)", (game, 1, 1)) in
  assert_equals_result (ORANGE, test_color1);

  let test_color2 = test_exec (brick_color, "Test color: BLUE for BK_double at (1, 2)", (game, 1, 2)) in
  assert_equals_result (BLUE, test_color2);

  let test_color3 = test_exec (brick_color, "Test color: GREEN for BK_block at (1, 3)", (game, 1, 3)) in
  assert_equals_result (GREEN, test_color3);

  let test_color4 = test_exec (brick_color, "Test color: YELLOW for BK_bonus at (1, 4)", (game, 1, 4)) in
  assert_equals_result (YELLOW, test_color4);

  let test_color5 = test_exec (brick_color, "Test color: WHITE for BK_empty at (1, 5)", (game, 1, 5)) in
  assert_equals_result (WHITE, test_color5);

  test_report ()
;;


(* /////////////////////////// PADDLE /////////////////////////////////// *)

(* Fonction de test pour les opérations de la palette *)
let test_paddle_operations () =
  let game = make_camlbrick () in  (* Initialisons l'état du jeu *)

  (* Test initial de la position de la palette *)
  let initial_paddle_x = test_exec (paddle_x, "Test position initiale de la palette", game) in
  assert_equals_result (game.param.world_width / 2 - game.param.paddle_init_width / 2, initial_paddle_x);

  (* Test de la taille de la palette *)
  let paddle_size = test_exec (paddle_size_pixel, "Test taille de la palette en pixels", game) in
  assert_equals_result (75, paddle_size);  (* En supposant que la palette initiale est de taille moyenne *)

  (* Déplacer la palette vers la gauche jusqu'à la limite *)
  let () = paddle_move_left game in
  let moved_left_paddle_x = test_exec (paddle_x, "Test position déplacée de la palette vers la gauche", game) in
  assert_equals_result (0, moved_left_paddle_x);  (* Nous supposons que la palette ne peut pas se déplacer au-delà du bord gauche du monde *)

  (* Configurer la palette dans une position permettant le déplacement vers la droite *)
  game.paddle.paddle_x <- game.param.world_width / 2;
  let () = paddle_move_right game in
  let moved_right_paddle_x = test_exec (paddle_x, "Test position déplacée de la palette vers la droite", game) in
  (* Vérifier que la palette se déplace correctement sans dépasser les limites du monde *)
  assert_equals_result (min (game.param.world_width - 75) (game.param.world_width / 2 + 10), moved_right_paddle_x);

  (* Générer le rapport des résultats *)
  test_report ()
;;


(* /////////////////////////// BALLS //////////////////////////////////// *)

(* Fonction de test pour vérifier la présence de balles dans le jeu *)
let test_has_ball () =
  let game = make_camlbrick () in  (* Initialisons l'état du jeu *)

  (* Cas 1: Vérifier s'il y a des balles *)
  let test_with_balls = test_exec (has_ball, "Test has_ball avec des balles présentes", game) in
  assert_true_result test_with_balls;

  (* Cas 2: Vérifier s'il n'y a pas de balles *)
  game.balls <- [];  (* Supprimons toutes les balles du jeu *)
  let test_without_balls = test_exec (has_ball, "Test has_ball sans aucune balle", game) in
  assert_false_result test_without_balls;

  (* Générer le rapport des résultats *)
  test_report ()
;;


(* Fonction de test pour vérifier le décompte des balles dans le jeu *)
let test_balls_count () =
  let game = make_camlbrick () in  (* Initialisons l'état du jeu avec des balles initiales *)

  (* Cas 1: Vérifier le décompte initial des balles *)
  let initial_count = test_exec (balls_count, "Test décompte initial des balles", game) in
  assert_equals_result (List.length game.balls, initial_count);

  (* Cas 2: Vérifier quand il n'y a pas de balles *)
  game.balls <- [];  (* Supprimons toutes les balles du jeu *)
  let count_no_balls = test_exec (balls_count, "Test décompte des balles sans aucune balle", game) in
  assert_equals_result (0, count_no_balls);

  (* Cas 3: Ajout de plusieurs balles dans le jeu *)
  game.balls <- [{position = {x = 1; y = 2}; velocity = {x = 0; y = -1}; size = BS_SMALL}; 
                 {position = {x = 3; y = 4}; velocity = {x = 1; y = -1}; size = BS_MEDIUM}];
  let count_multiple_balls = test_exec (balls_count, "Test décompte des balles avec plusieurs balles", game) in
  assert_equals_result (2, count_multiple_balls);

  (* Générer le rapport des résultats *)
  test_report ()
;;

(* Fonction de test pour vérifier les opérations sur les balles dans le jeu *)
let test_ball_operations () =
  let game = make_camlbrick () in  (* Initialisons l'état du jeu *)

  (* Configuration de quelques balles dans le jeu pour le test *)
  game.balls <- [{position = {x = 100; y = 150}; velocity = {x = 0; y = -1}; size = BS_SMALL}; 
                 {position = {x = 200; y = 250}; velocity = {x = 1; y = -1}; size = BS_MEDIUM};
                 {position = {x = 300; y = 350}; velocity = {x = 1; y = 1}; size = BS_BIG}];

  (* Test pour obtenir la liste de toutes les balles *)
  let balls_list = test_exec (balls_get, "Test obtenir toutes les balles", game) in
  assert_equals_result (game.balls, balls_list);

  (* Test pour obtenir une balle spécifique par indice *)
  let specific_ball = test_exec (ball_get, "Test obtenir une balle spécifique à l'indice 1", (game, 1)) in
  assert_equals_result (List.nth game.balls 1, specific_ball);

  (* Test pour obtenir les coordonnées X et Y d'une balle spécifique *)
  let ball_x_position = test_exec (ball_x, "Test obtenir la position X de la balle", (game, List.nth game.balls 1)) in
  assert_equals_result (200, ball_x_position);

  let ball_y_position = test_exec (ball_y, "Test obtenir la position Y de la balle", (game, List.nth game.balls 1)) in
  assert_equals_result (250, ball_y_position);

  (* Test pour obtenir la taille en pixels d'une balle spécifique *)
  let ball_size = test_exec (ball_size_pixel, "Test obtenir la taille en pixels d'une balle de taille moyenne", (game, List.nth game.balls 1)) in
  assert_equals_result (20, ball_size);

  (* Test pour obtenir la couleur d'une balle spécifique *)
  let ball_color_test = test_exec (ball_color, "Test obtenir la couleur d'une balle de taille moyenne", (game, List.nth game.balls 1)) in
  assert_equals_result (CYAN, ball_color_test);

  (* Générer le rapport des résultats *)
  test_report ()
;;

(* Test pour vérifier que la vitesse de la balle est mise à jour correctement en utilisant le framework fourni *)
let test_ball_modif_speed_complete() : unit =
  (* Initialisation des données pour le test *)
  let delta_velocity = { x = 0; y = 0 } in
  let ball = make_ball(0, 0, 2) (* position (0, 0) et taille moyenne (BS_MEDIUM) *) in
  let game = make_camlbrick () in
  
  (* Exécuter la fonction à tester et capturer le résultat *)
  let result = test_exec(
    (fun () ->
      ball_modif_speed(game, ball, delta_velocity);
      ball.velocity
    ),
    "Test Ball Modify Speed",
    ()
  ) in
  
  (* Vérifier le résultat attendu *)
  assert_equals_result_m(
    ("La vitesse de la balle devrait avoir été augmentée correctement.",
    { x = 1; y = 1 },
    result)
  );
  
  (* Afficher le rapport de test *)
  test_report()
    ;;
  ;;

let test_ball_modif_speed_sign_complete() : unit =
  let sign_change = { x = -1; y = -1 } in
  let ball = make_ball(0, 0, 2) in
  let game = make_camlbrick () in

  let result = test_exec(
    (fun () ->
      ball_modif_speed_sign(game, ball, sign_change);
      ball.velocity
    ),
    "Test Ball Modify Speed Sign",
    ()
  ) in

  assert_equals_result_m(
    ("La vitesse de la balle devrait changer de signe correctement.",
    { x = -2; y = 2 },
    result)
  );

  test_report();
;;

(* Test pour vérifier si le point se trouve à l'intérieur du cercle *)
let test_is_inside_circle_complete() : unit =
  let cx, cy, rad = (5, 5, 3) in  (* Centre du cercle et rayon *)
  let x, y = (7, 5) in  (* Un point à l'intérieur du cercle *)

  let result = test_exec(
    (fun () -> is_inside_circle(cx, cy, rad, x, y)),
    "Test Point Inside Circle",
    ()
  ) in

  assert_true_result_m(
    "Le point devrait être à l'intérieur du cercle.",
    result
  );

  test_report();
;;

let test_is_inside_quad_complete() : unit =
  let x1, y1, x2, y2 = (1, 1, 10, 10) in  (* Coordonnées du carré *)
  let x, y = (5, 5) in  (* Un point à l'intérieur du carré *)

  let result = test_exec(
    (fun () -> is_inside_quad(x1, y1, x2, y2, x, y)),
    "Test Point Inside Quadrilateral",
    ()
  ) in

  assert_true_result_m(
    "Le point devrait être à l'intérieur du quadrilatère.",
    result
  );

  test_report();
;;

let test_ball_remove_out_of_border_complete() : unit =
  let ball_inside = make_ball(0, 0, 2) in  (* Balle à l'intérieur des limites *)
  let ball_outside = make_ball(0, 100, 2) in  (* Balle à l'extérieur des limites *)
  let game = make_camlbrick () in

  let result = test_exec(
    (fun () -> ball_remove_out_of_border(game, [ball_inside; ball_outside])),
    "Test Remove Ball Out of Border",
    ()
  ) in

  assert_equals_result_m(
    ("Devrait supprimer les balles en dehors de la limite supérieure.",
    [ball_inside],
    result)
  );

  test_report();
;;

let test_ball_hit_paddle_complete() : unit =
  (* Utiliser make_camlbrick_param pour initialiser les paramètres du jeu *)
  let game = make_camlbrick () in
  let paddle = {
    paddle_x = 50;  (* Position X de la raquette *)
    paddle_size = PS_MEDIUM;  (* Taille de la raquette *)
  } in
  let ball = {
    position = { x = 75; y = 170 };  (* Position initiale de la balle juste pour la collision *)
    velocity = { x = 5; y = 10 };  (* Vitesse initiale de la balle *)
    size = BS_MEDIUM;  (* Taille de la balle *)
  } in

  let expected_velocity_after_hit = {
    x = 0;  (* Supposant que la section centrale de la raquette est touchée *)
    y = -10;  (* La vitesse Y est inversée *)
  } in

  let result = test_exec(
    (fun () ->
      ball_hit_paddle(game, ball, paddle);
      ball.velocity
    ),
    "Test Ball Hit Paddle",
    ()
  ) in

  assert_equals_result_m(
    ("La vitesse de la balle après avoir touché la raquette devrait être ajustée correctement.",
    expected_velocity_after_hit,
    result)
  );

  test_report();
;;

let test_ball_hit_corner_brick_complete() : unit =
  let game = make_camlbrick () in
  let ball = {
    position = { x = 120; y = 100 };  (* Position de la balle près du coin supérieur gauche d'un certain brick *)
    velocity = { x = 0; y = 0 };  (* La vitesse n'a pas d'importance dans ce test *)
    size = BS_SMALL;  (* La taille de la balle *)
  } in
  let i, j = (2, 2) in (* Position du brick dans la matrice des briques *)

  let result = test_exec(
    (fun () ->
      ball_hit_corner_brick(game, ball, i, j)
    ),
    "Test Ball Hit Corner of Brick",
    ()
  ) in

  assert_true_result_m(
    "La balle devrait toucher au moins un coin du brick spécifié.",
    result
  );

  test_report();
;;

let test_game_test_hit_balls_complete() : unit =
  let game = make_camlbrick () in

  ignore (test_exec(
    (fun () -> 
      game_test_hit_balls(game, game.balls);
    ),
    "Test Game Hit Balls",
    ()
  ));

  (* Rapport final *)
  test_report();
  ()
;;


let () = 
  test_make_camlbrick ();
  test_make_paddle ();
  test_make_ball ();
  test_string_of_gamestate ();
  test_brick_functions ();
  test_brick_color ();
  test_paddle_operations ();
  test_has_ball () ;
  test_balls_count ();
  test_ball_operations ();
  test_ball_modif_speed_complete() ;
  test_ball_modif_speed_sign_complete() ;
  test_is_inside_circle_complete();
  test_is_inside_quad_complete() ;
  test_ball_remove_out_of_border_complete();
  test_ball_hit_paddle_complete();
  test_ball_hit_corner_brick_complete();
  test_game_test_hit_balls_complete();
;;
