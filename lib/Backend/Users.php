<?php 
    class utilisateur{
        private $id_utilisateur;
        private $nom_utilisateur;
        private $prenom_utilisateur;
        private $email_utilisateur;
        private $mot_de_passe_utilisateur;
        private $telephone_utilisateur;
        private $role_utilisateur = 'supporter';
        private $date_inscription;

        //----------------------------constucteur----------------------------
        public function __construct($nom, $prenom, $email, $mot_de_passe, $telephone, $role = "supporter") {
            $this->nom_utilisateur = $nom;
            $this->prenom_utilisateur = $prenom;
            $this->email_utilisateur = $email;
            $this->mot_de_passe_utilisateur = password_hash($mot_de_passe, PASSWORD_DEFAULT);
            $this->telephone_utilisateur = $telephone;
            $this->role_utilisateur = $role;
            $this->date_inscription = date("Y-m-d H:i:s");
        }

        //----------------------------geters----------------------------
        public function getId() {
            return $this->id_utilisateur;
        }

        public function getNom() {
            return $this->nom_utilisateur;
        }

        public function getPrenom() {
            return $this->prenom_utilisateur;
        }

        public function getEmail() {
            return $this->email_utilisateur;
        }

        // public function getMotDePasse() {
        //     return $this->mot_de_passe_utilisateur;
        // }

        public function getTelephone() {
            return $this->telephone_utilisateur;
        }

        public function getRole() {
            return $this->role_utilisateur;
        }

        public function getDateInscription() {
            return $this->date_inscription;
        }

        //----------------------------seters----------------------------
        public function setNom($nom) {
            $this->nom_utilisateur = $nom;
        }

        public function setPrenom($prenom) {
            $this->prenom_utilisateur = $prenom;
        }

        public function setEmail($email) {
            $this->email_utilisateur = $email;
        }

        public function setMotDePasse($mot_de_passe) {
            $this->mot_de_passe_utilisateur = password_hash($mot_de_passe, PASSWORD_DEFAULT) ;
        }

        public function setTelephone($telephone) {
            $this->telephone_utilisateur = $telephone;
        }

        //----------------------------virifier la connection----------------------------
        public function verification($odc, $email, $passe){
            $query = "SELECT * FROM utilisateur WHERE email_utilisateur = ?";
            $stmt = $odc->prepare($query);
            if (!$stmt) return false;
            $stmt->bind_param("s", $email);
            $stmt->execute();
            $result = $stmt->get_result();
            if ($result->num_rows == 0) {
                return false;
            }
            $user = $result->fetch_assoc();
            if (password_verify($passe, $user['mot_de_passe_utilisateur'])) {
                return true;
            }
                return false;
            }

            public function supprimerCompte($odc, $id){
                $query = "DELETE FROM utilisateur WHERE id_utilisateur = ?";
                $stmt = $odc->prepare($query);
                if (!$stmt) return false;
                $stmt->bind_param("i", $id);
                if ($stmt->execute()) {
                    if ($stmt->affected_rows > 0) {
                        return "Compte supprimé avec succès.";
                    } else {
                        return "Aucun utilisateur trouvé avec cet ID.";
                    }
                }
            }
    }

    
?>