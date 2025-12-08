<?php
    class Vehicules{
        private $id_vehicule;
        private $matricule;
        private $type;
        private $capacite;
        private $disponibilite;
        private $etat;

     //----------------------------constucteur----------------------------
        public function __construct($mat, $type, $capa, $dispo = "1", $etat = "good") {
            $this->matricule = $mat;
            $this->type = $type;
            $this->capacite = $capa;
            $this->disponibilite = $dispo;
            $this->etat = $etat;
        }

        //---------------------------Disponibilité véhicule-----------------------
        public function suppresion($odc, $id_vehicule){
             $query = "DELETE FROM vehicule WHERE Id_Vehicule = ?";
                $stmt = $odc->prepare($query);
                if (!$stmt) return false;
                $stmt->bind_param("i", $id_vehicule);
                if ($stmt->execute()) {
                    if ($stmt->affected_rows > 0) {
                        return "véhicule supprimé avec succès.";
                    } else {
                        return "Aucun véhicule trouvé avec cet ID.";
                    }
                }
        }

        //--------------------------seters pour la modification---------------------------
        public function setCapacite($capa) {
            $this->capacite = $capa;
        }

        public function setEtat($etat) {
            $this->etat = $etat;
        }
        
        //---------------------------------switch availability (disponibilité)-------------------------------
        public function switchDispo() {
            $this->disponibilite = $this->disponibilite ? 0 : 1;
            return $this->disponibilite;
        }

        //----------------------------------affichage vehicule-------------------------------------------
        public function affichierVehicule($odc, $id_vehicule){
            $query = "SELECT Matricule, Type, Capacite, Disponibilite, Etat FROM vehicule WHERE Id_Vehicule = ?";
            $stmt = $odc->prepare($query);
            $stmt->bind_param("i", $id_vehicule);
            $stmt->execute();
            $result = $stmt->get_result();
            if ($result->num_rows == 0) {
                echo "Aucun véhicule trouvé avec cet ID.<br>";
                return;
            }
            $row = $result->fetch_assoc();
            echo "Matricule : " . $row['Matricule'] . "<br>";
            echo "Type : " . $row['Type'] . "<br>";
            echo "Capacité : " . $row['Capacite'] . "<br>";
            echo "Disponibilité : " . ($row['Disponibilite'] ? "Disponible" : "Indisponible") . "<br>";
            echo "État : " . $row['Etat'] . "<br>";
        }

        // ------------------------------ Getters ------------------------------
        public function getId() { return $this->id_vehicule; }
        public function getMatricule() { return $this->matricule; }
        public function getType() { return $this->type; }
        public function getCapacite() { return $this->capacite; }
        public function getDisponibilite() { return $this->disponibilite; }
        public function getEtat() { return $this->etat; }
    }
?>