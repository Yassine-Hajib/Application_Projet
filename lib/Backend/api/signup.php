<?php
    // -------------------------------------------------------------
    // CORS HEADERS (REQUIRED FOR FLUTTER WEB)
    // -------------------------------------------------------------
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Allow-Methods: POST, OPTIONS");

    // Handle Preflight Request (The browser checks if it's safe first)
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    // -------------------------------------------------------------
    // REGULAR LOGIC
    // -------------------------------------------------------------
    ini_set('display_errors', 1);
    error_reporting(E_ALL);

    // Adjust paths based on your folder structure in htdocs
    if (file_exists('../config/db_connect.php')) {
        include_once '../config/db_connect.php';
        include_once '../Users.php';
    } else {
        include_once 'db_connect.php';
        include_once 'Users.php';
    }

    // Initialize Database
    $db = new Connection("caf_db");
    $odc = $db->conn; 

    // Get Data
    $data = json_decode(file_get_contents("php://input"));

    if(
        !empty($data->nom) && 
        !empty($data->email) && 
        !empty($data->password)
    ){
        $user = new utilisateur(
            $data->nom,
            $data->prenom,
            $data->email,
            $data->password,
            $data->phone,
            $data->role
        );

        $result = $user->inscrire($odc);

        if($result === true){
            http_response_code(201);
            echo json_encode(array("message" => "Compte créé avec succès.", "success" => true));
        } else {
            http_response_code(200); 
            echo json_encode(array("message" => $result, "success" => false));
        }
    } else {
        http_response_code(400);
        echo json_encode(array("message" => "Données incomplètes.", "success" => false));
    }
?>