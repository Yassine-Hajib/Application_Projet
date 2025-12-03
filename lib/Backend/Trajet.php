


<?php
class Trajet {

    private int $idTrajet;
    private string $pointDepart;
    private string $pointArrivee;
    private float $distance;
    private string $dureeEstimee;     
    private string $heureDepart;      
    private string $heureArrivee;    

    public function __construct(
        int $idTrajet,
        string $pointDepart,
        string $pointArrivee,
        float $distance,
        string $dureeEstimee,
        string $heureDepart,
        string $heureArrivee
    ) {
        $this->idTrajet     = $idTrajet;
        $this->pointDepart  = $pointDepart;
        $this->pointArrivee = $pointArrivee;
        $this->distance     = $distance;
        $this->dureeEstimee = $dureeEstimee;
        $this->heureDepart  = $heureDepart;
        $this->heureArrivee = $heureArrivee;
    }
    public function __destruct()
    {
        
    }

   // GETTERS
public function getIdTrajet(){
    return $this->idTrajet;
}

public function getPointDepart(){
    return $this->pointDepart;
}

public function getPointArrivee(){
    return $this->pointArrivee;
}

public function getDistance(){
    return $this->distance;
}

public function getDureeEstimee(){
    return $this->dureeEstimee;
}

public function getHeureDepart(){
    return $this->heureDepart;
}

public function getHeureArrivee(){
    return $this->heureArrivee;
}


// SETTERS
public function setPointDepart(string $pointDepart){
    $this->pointDepart = $pointDepart;
}

public function setPointArrivee(string $pointArrivee){
    $this->pointArrivee = $pointArrivee;
}

public function setDistance(float $distance){
    $this->distance = $distance;
}

public function setDureeEstimee(string $dureeEstimee){
    $this->dureeEstimee = $dureeEstimee;
}

public function setHeureDepart(string $heureDepart){
    $this->heureDepart = $heureDepart;
}

public function setHeureArrivee(string $heureArrivee){
    $this->heureArrivee = $heureArrivee;
}






    //  AJOUTER
    public function ajouter($pdo) {
        $sql = "INSERT INTO trajets 
                (point_depart, point_arrivee, distance, duree_estimee, heure_depart, heure_arrivee)
                VALUES (?, ?, ?, ?, ?, ?)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $this->pointDepart,
            $this->pointArrivee,
            $this->distance,
            $this->dureeEstimee,
            $this->heureDepart,
            $this->heureArrivee
        ]);

        $this->idTrajet = $pdo->lastInsertId();
        return $this->idTrajet;
    }


    //  SUPPRIMER
    public function supprimer($pdo, $id) {
        $sql = "DELETE FROM trajets WHERE id_trajet = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$id]);
        return $stmt->rowCount() > 0;
    }


    //  MODIFIER
    public function modifier($pdo) {
        $sql = "UPDATE trajets SET 
                    point_depart = ?,
                    point_arrivee = ?,
                    distance = ?,
                    duree_estimee = ?,
                    heure_depart = ?,
                    heure_arrivee = ?
                WHERE id_trajet = ?";

        $stmt = $pdo->prepare($sql);

        return $stmt->execute([
            $this->pointDepart,
            $this->pointArrivee,
            $this->distance,
            $this->dureeEstimee,
            $this->heureDepart,
            $this->heureArrivee,
            $this->idTrajet
        ]);
    }
// affichage
 public function __toString(){
 return "Trajet $this->idTrajet <br>". "Départ : $this->pointDepart<br>". "Arrivée : $this->pointArrivee<br>"
  . "Distance : $this->distance km<br>". "Durée estimée : $this->dureeEstimee <br>"
  . "Heure départ : $this->heureDepart<br>"
            . "Heure arrivée : $this->heureArrivee <br>";
    }  
 

   
}
