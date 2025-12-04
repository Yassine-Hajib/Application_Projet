<?php
class Chauffeur {

    private $nom;
    private $prenom;
    private $numero_permis;
    private $date_expiration;
    private $telephone;
    private $email;
    private $statut;
    public function __construct($nom = "", $prenom = "", $numero_permis = "", $date_expiration = "", $telephone = "", $email = "", $statut = "") {
         $this->nom = $nom;
        $this->prenom = $prenom;
        $this->numero_permis = $numero_permis;
        $this->date_expiration = $date_expiration;
        $this->telephone = $telephone;
        $this->email = $email;
        $this->statut = $statut;
    }
    public function __destruct()
    {
        
    }

    // -----------------------
    //      SETTERS
    // -----------------------
    public function setNom($nom) { 
        $this->nom = $nom; 
    }
    public function setPrenom($prenom) {
         $this->prenom = $prenom; 
        }
    public function setNumeroPermis($numero_permis) {
         $this->numero_permis = $numero_permis;
         }
    public function setDateExpiration($date_expiration) {
         $this->date_expiration = $date_expiration; 
        }
    public function setTelephone($telephone) {
         $this->telephone = $telephone;
         }
    public function setEmail($email) {
         $this->email = $email;
         }
    public function setStatut($statut) { 
        $this->statut = $statut;
     }

    // -----------------------
    //      GETTERS
    // -----------------------
    public function getNom() { return $this->nom;
     }
    public function getPrenom() { return $this->prenom; 
    }
    public function getNumeroPermis() { return $this->numero_permis; 
    }
    public function getDateExpiration() { return $this->date_expiration;
     }
    public function getTelephone() { return $this->telephone;
     }
    public function getEmail() { return $this->email;
     }
    public function getStatut() { return $this->statut;
     }


    // -----------------------
    //      CRUD
    // -----------------------

    // Ajouter
    public function ajouter($pdo) {
        $sql = "INSERT INTO chauffeurs 
                (nom_chauffeur, prenom_chauffeur, numero_permis, date_expiration_permis, telephone_chauffeur, email_chauffeur, statut_chauffeur)
                VALUES (?, ?, ?, ?, ?, ?, ?)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $this->nom,
            $this->prenom,
            $this->numero_permis,
            $this->date_expiration,
            $this->telephone,
            $this->email,
            $this->statut
        ]);

        return $pdo->lastInsertId();
    }

    // Supprimer
    public function supprimer($pdo, $id) {
        $sql = "DELETE FROM chauffeurs WHERE id_chauffeur = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->rowCount() > 0;
    }
//afficher
    public function afficher() {
        echo "Nom : " . $this->nom ."<br>";
        echo "Prénom : ". $this->prenom ."<br>";
        echo "Numéro de permis : ". $this->numero_permis ."<br>";
        echo "Date d'expiration : ". $this->date_expiration ."<br>";
        echo "Téléphone : ". $this->telephone ."<br>";
        echo "Email : ". $this->email ."<br>";
        echo "Statut : ". $this->statut ."<br>";
    }
    //switch chauffeur
      private function switchChauffeur($pdo, $id_chauffeur) {
    $sql = "UPDATE chauffeurs SET statut_chauffeur = 'occupé' WHERE id_chauffeur = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id_chauffeur]);
}

    // switch véhicule

   private function switchVehicule($pdo, $id_vehicule) {
    $sql = "UPDATE vehicules SET disponibilite_vehicule = 'occupé' WHERE id_vehicule = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id_vehicule]);
}


    //fct qui lie entre chauffeur et véhicule 
  public function lierChauffeurVehicule($pdo, $id_chauffeur, $id_vehicule) {

    
    $sql = "SELECT statut_chauffeur FROM chauffeurs WHERE id_chauffeur = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id_chauffeur]);
    $chauffeur = $stmt->fetch();

    if ($chauffeur['statut_chauffeur'] !== 'disponible') {
        echo "Le chauffeur n'est pas disponible.";
        return;
    }

   
    $sql = "SELECT disponibilite_vehicule FROM vehicules WHERE id_vehicule = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$id_vehicule]);
    $vehicule = $stmt->fetch();

    if ($vehicule['disponibilite_vehicule'] !== 'disponible') {
        echo "Le véhicule n'est pas disponible.";
        return;
    }

  
    echo "Le chauffeur est affecté au véhicule.";

  
    $this->switchChauffeur($pdo, $id_chauffeur);
    $this->switchVehicule($pdo, $id_vehicule);
}

}
?>
