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

    include_once '../config/db_connect.php';

    $db = new Connection("caf_db");
    $conn = $db->conn;

    $data = json_decode(file_get_contents("php://input"));

    if(!empty($data->email) && !empty($data->trajet) && !empty($data->type_reservation) && !empty($data->type_vehicule)) {
        
        $sql = "INSERT INTO reservations (email_utilisateur, trajet, type_reservation, type_vehicule) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        
        if($stmt) {
            $stmt->bind_param("ssss", $data->email, $data->trajet, $data->type_reservation, $data->type_vehicule);
            
            if($stmt->execute()) {
                echo json_encode(array("success" => true, "message" => "Réservation confirmée !"));
            } else {
                echo json_encode(array("success" => false, "message" => "Erreur lors de l'enregistrement."));
            }
        } else {
            echo json_encode(array("success" => false, "message" => "Erreur SQL."));
        }
    } else {
        echo json_encode(array("success" => false, "message" => "Données incomplètes."));
    }
?>