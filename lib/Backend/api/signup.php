<?php
    // -------------------------------------------------------------------------
    // CORS HEADERS (MUST BE THE VERY FIRST LINES)
    // -------------------------------------------------------------------------
    header("Access-Control-Allow-Origin: *");
    // Explicitly allow Content-Type (This fixes your specific error)
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Allow-Methods: POST, OPTIONS");

    // Handle the Preflight (Browser checking permission)
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    // -------------------------------------------------------------------------
    // LOGIC START
    // -------------------------------------------------------------------------
    ini_set('display_errors', 0);
    error_reporting(E_ALL);

    function sendResponse($success, $message) {
        echo json_encode(array("success" => $success, "message" => $message));
        exit();
    }

    // Include Files
    $paths = ['../config/db_connect.php', '../Users.php', '../Chauffeur.php'];
    foreach ($paths as $path) {
        if (file_exists($path)) {
            include_once $path;
        } else {
            $alt = str_replace('../', '', $path);
            if (file_exists($alt)) include_once $alt;
        }
    }

    if (!class_exists('Connection')) sendResponse(false, "Erreur Connection DB.");
    $db = new Connection("caf_db");
    $odc = $db->conn; 

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->nom) && !empty($data->email) && !empty($data->password)) {

        // --- CHAUFFEUR LOGIC (Table: chauffeurs) ---
        if ($data->role == 'Chauffeur') {
            
            $permis = $data->numero_permis ?? "";
            $expiration = $data->date_expiration ?? "";

            if (!class_exists('Chauffeur')) sendResponse(false, "Classe Chauffeur introuvable.");

            $chauffeur = new Chauffeur(
                $data->nom, $data->prenom, $data->email, $data->password, 
                $data->phone, $permis, $expiration, "disponible"
            );

            $res = $chauffeur->ajouter($odc);

            if($res === true) {
                http_response_code(201);
                sendResponse(true, "Compte Chauffeur créé.");
            } else {
                sendResponse(false, $res);
            }

        } 
        // --- SUPPORTER LOGIC (Table: utilisateur) ---
        else {
            $user = new utilisateur(
                $data->nom, $data->prenom, $data->email, 
                $data->password, $data->phone, $data->role
            );

            $res = $user->inscrire($odc);

            if($res === true) {
                http_response_code(201);
                sendResponse(true, "Compte Supporter créé.");
            } else {
                sendResponse(false, $res);
            }
        }

    } else {
        sendResponse(false, "Données incomplètes.");
    }
?>