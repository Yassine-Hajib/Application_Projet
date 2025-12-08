<?php
    // CORS Headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') { http_response_code(200); exit(); }

    // Include DB & Class
    if (file_exists('../config/db_connect.php')) {
        include_once '../config/db_connect.php';
        include_once '../Users.php';
    } else {
        include_once 'db_connect.php';
        include_once 'Users.php';
    }

    $db = new Connection("caf_db");
    $odc = $db->conn;

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->old_email) && !empty($data->nom) && !empty($data->email)) {
        
        // Create user object with NEW data
        // (We leave password empty/dummy because we aren't updating it here)
        $user = new utilisateur(
            $data->nom,
            $data->prenom,
            $data->email, // New Email
            "dummy_pass", 
            $data->phone
        );

        // Call the update function
        $result = $user->modifierInfo($odc, $data->old_email);

        if($result === true){
            http_response_code(200);
            echo json_encode(array("message" => "Profil mis à jour.", "success" => true));
        } else {
            http_response_code(200);
            echo json_encode(array("message" => $result, "success" => false));
        }
    } else {
        echo json_encode(array("message" => "Données manquantes", "success" => false));
    }
?>