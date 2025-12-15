<?php
class Chauffeur {
    private $nom;
    private $prenom;
    private $email;
    private $password;
    private $telephone;
    private $numero_permis;
    private $date_expiration;
    private $statut;

    // Constructor
    public function __construct($nom, $prenom, $email, $password, $telephone, $numero_permis, $date_expiration, $statut = "disponible") {
        $this->nom = $nom;
        $this->prenom = $prenom;
        $this->email = $email;
        // We hash the password immediately when creating the object
        $this->password = password_hash($password, PASSWORD_DEFAULT); 
        $this->telephone = $telephone;
        $this->numero_permis = $numero_permis;
        $this->date_expiration = $date_expiration;
        $this->statut = $statut;
    }

    // -----------------------
    //      SIGNUP (Ajouter)
    // -----------------------
    public function ajouter($odc) {
        // 1. Check if email exists
        $check = "SELECT * FROM chauffeurs WHERE email_chauffeur = ?";
        $stmtCheck = $odc->prepare($check);
        $stmtCheck->bind_param("s", $this->email);
        $stmtCheck->execute();
        if($stmtCheck->get_result()->num_rows > 0) return "Cet email est déjà utilisé.";

        // 2. Insert into chauffeurs table
        $sql = "INSERT INTO chauffeurs 
                (nom_chauffeur, prenom_chauffeur, email_chauffeur, mot_de_passe_chauffeur, telephone_chauffeur, numero_permis, date_expiration_permis, statut_chauffeur)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $stmt = $odc->prepare($sql);
        if (!$stmt) return "Erreur SQL: " . $odc->error;

        $stmt->bind_param("ssssssss",
            $this->nom,
            $this->prenom,
            $this->email,
            $this->password, // Uses the hashed password from constructor
            $this->telephone,
            $this->numero_permis,
            $this->date_expiration,
            $this->statut
        );

        if ($stmt->execute()) return true;
        return "Erreur Insert: " . $stmt->error;
    }

    // -----------------------
    //      LOGIN (Verification) <--- THIS WAS MISSING
    // -----------------------
    public function verification($odc, $email, $password) {
        // 1. Get user by email
        $query = "SELECT * FROM chauffeurs WHERE email_chauffeur = ?";
        $stmt = $odc->prepare($query);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        // 2. If user exists, check password
        if ($result->num_rows > 0) {
            $chauffeur = $result->fetch_assoc();
            // Check the hashed password from database against the login password
            if (password_verify($password, $chauffeur['mot_de_passe_chauffeur'])) {
                return $chauffeur; // Success: Return user data
            }
        }
        return false; // Failed
    }
}
?>