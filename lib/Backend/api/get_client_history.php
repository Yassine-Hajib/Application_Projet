<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/db_connect.php';
    $db = new Connection("caf_db");
    $conn = $db->conn;

    // Get email from URL parameters (e.g. ?email=user@test.com)
    if(isset($_GET['email'])) {
        $email = $_GET['email'];

        // Fetch completed trips (You can add "AND id_reservation NOT IN (SELECT id_reservation FROM avis)" to hide rated ones)
        // We ensure id_chauffeur IS NOT NULL meaning a driver accepted it
        $sql = "SELECT * FROM reservations WHERE email_utilisateur = ? AND id_chauffeur IS NOT NULL ORDER BY date_creation DESC";
        
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        $trips = array();
        while($row = $result->fetch_assoc()) {
            $trips[] = $row;
        }

        echo json_encode(array("success" => true, "data" => $trips));
    } else {
        echo json_encode(array("success" => false, "message" => "Email manquant"));
    }
?>