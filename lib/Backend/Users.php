<?php 
    class utilisateur {
        private $nom_utilisateur;
        private $prenom_utilisateur;
        private $email_utilisateur;
        private $mot_de_passe_utilisateur;
        private $telephone_utilisateur;
        private $role_utilisateur; 
        private $date_inscription;

        public function __construct($nom, $prenom, $email, $mot_de_passe, $telephone, $role = 'supporteur') {
            $this->nom_utilisateur = $nom;
            $this->prenom_utilisateur = $prenom;
            $this->email_utilisateur = $email;
            $this->mot_de_passe_utilisateur = password_hash($mot_de_passe, PASSWORD_DEFAULT);
            $this->telephone_utilisateur = $telephone;
            $this->role_utilisateur = $role;
            $this->date_inscription = date("Y-m-d H:i:s");
        }

        public function inscrire($odc) {
            $checkQuery = "SELECT * FROM utilisateur WHERE email_utilisateur = ?";
            $stmtCheck = $odc->prepare($checkQuery);
            $stmtCheck->bind_param("s", $this->email_utilisateur);
            $stmtCheck->execute();
            if ($stmtCheck->get_result()->num_rows > 0) {
                return "Cet email est déjà utilisé.";
            }

            $query = "INSERT INTO utilisateur (nom_utilisateur, prenom_utilisateur, email_utilisateur, mot_de_passe_utilisateur, telephone_utilisateur, role_utilisateur, date_inscription) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            $stmt = $odc->prepare($query);
            if (!$stmt) return "Erreur SQL: " . $odc->error;

            $stmt->bind_param("sssssss", 
                $this->nom_utilisateur, $this->prenom_utilisateur, $this->email_utilisateur, 
                $this->mot_de_passe_utilisateur, $this->telephone_utilisateur, 
                $this->role_utilisateur, $this->date_inscription
            );

            if ($stmt->execute()) return true;
            return "Erreur d'insertion: " . $stmt->error;
        }

        public function verification($odc, $email, $passe){
            $query = "SELECT * FROM utilisateur WHERE email_utilisateur = ?";
            $stmt = $odc->prepare($query);
            if (!$stmt) return false;
            
            $stmt->bind_param("s", $email);
            $stmt->execute();
            $result = $stmt->get_result();
            
            if ($result->num_rows == 0) {
                return false; // User not found
            }
            
            $user = $result->fetch_assoc();
            $hashFromDB = $user['mot_de_passe_utilisateur'];

            if (password_verify($passe, $hashFromDB)) {
                return $user;
            }
            return false;
        }

        // ---------------------------- MISE À JOUR (UPDATE) ----------------------------
        public function modifierInfo($odc, $oldEmail) {
            // Update Name, Surname, Phone, and potentially Email (if you allow it)
            // For safety, we look up the user by their OLD email
            $query = "UPDATE utilisateur SET nom_utilisateur=?, prenom_utilisateur=?, email_utilisateur=?, telephone_utilisateur=? WHERE email_utilisateur=?";
            
            $stmt = $odc->prepare($query);
            if (!$stmt) return "Erreur SQL: " . $odc->error;

            $stmt->bind_param("sssss", 
                $this->nom_utilisateur, 
                $this->prenom_utilisateur, 
                $this->email_utilisateur, 
                $this->telephone_utilisateur, 
                $oldEmail // The email currently saved in the app
            );

            if ($stmt->execute()) return true;
            return "Erreur de mise à jour: " . $stmt->error;
        }
    }
?>