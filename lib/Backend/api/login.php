<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        http_response_code(200);
        exit();
    }

    ini_set('display_errors', 0);
    error_reporting(E_ALL);

    function sendResponse($success, $message, $user = null) {
        $response = array("success" => $success, "message" => $message);
        if ($user) $response['user'] = $user;
        echo json_encode($response);
        exit();
    }

    // Includes
    $paths = ['../config/db_connect.php', '../Users.php', '../Chauffeur.php'];
    foreach ($paths as $path) {
        if (file_exists($path)) include_once $path;
        else {
            $alt = str_replace('../', '', $path);
            if (file_exists($alt)) include_once $alt;
        }
    }

    if (!class_exists('Connection')) sendResponse(false, "Erreur Serveur: Classe Connection manquante.");
    
    $db = new Connection("caf_db");
    $odc = $db->conn;

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->email) && !empty($data->password) && !empty($data->role)) {
        
        // =====================================================================
        // LOGIC SPLIT BASED ON SELECTED ROLE
        // =====================================================================

        if ($data->role == 'Chauffeur') {
            // --- CASE 1: Check ONLY Chauffeurs Table ---
            if (class_exists('Chauffeur')) {
                // Pass empty strings to constructor to avoid crash
                $chauffeurObj = new Chauffeur("", "", "", "", "", "", ""); 
                
                $chauffeur = $chauffeurObj->verification($odc, $data->email, $data->password);

                if($chauffeur) {
                    $chauffeur['role_utilisateur'] = 'Chauffeur';
                    
                    // Map Chauffeur columns to generic user keys for Frontend
                    $formattedUser = array(
                        'id_utilisateur' => $chauffeur['id_chauffeur'],
                        'nom_utilisateur' => $chauffeur['nom_chauffeur'],
                        'prenom_utilisateur' => $chauffeur['prenom_chauffeur'],
                        'email_utilisateur' => $chauffeur['email_chauffeur'],
                        'telephone_utilisateur' => $chauffeur['telephone_chauffeur'],
                        'role_utilisateur' => 'Chauffeur'
                    );
                    
                    sendResponse(true, "Connexion Chauffeur réussie.", $formattedUser);
                } else {
                    sendResponse(false, "Compte Chauffeur introuvable ou mot de passe incorrect.");
                }
            }
        } 
        else {
            // --- CASE 2: Check ONLY Utilisateur Table (Supporteur) ---
            if (class_exists('utilisateur')) {
                $userObj = new utilisateur("", "", "", "", "", "");
                $user = $userObj->verification($odc, $data->email, $data->password);

                if($user) {
                    $user['role_utilisateur'] = 'Supporteur'; 
                    sendResponse(true, "Connexion réussie.", $user);
                } else {
                    sendResponse(false, "Compte Supporteur introuvable ou mot de passe incorrect.");
                }
            }
        }

    } else {
        sendResponse(false, "Données incomplètes (Email, Password ou Role manquant).");
    }
?>