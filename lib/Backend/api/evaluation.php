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

    if(!empty($data->id_reservation) && !empty($data->id_chauffeur) && !empty($data->note) && !empty($data->commentaire)) {
        
        $sql = "INSERT INTO avis (id_reservation, id_chauffeur, note, commentaire) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        
        if($stmt) {
            // Bind params: i = integer, s = string
            $stmt->bind_param("iiis", $data->id_reservation, $data->id_chauffeur, $data->note, $data->commentaire);
            
            if($stmt->execute()) {
                echo json_encode(array("success" => true, "message" => "Évaluation envoyée avec succès !"));
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