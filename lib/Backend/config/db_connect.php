<?php 
    class Connection {
        private $serverName = "localhost";
        private $username = "root";
        private $password = "root"; // MAMP default password
        public $conn;

        public function __construct($dbName) {
            $this->conn = mysqli_connect($this->serverName, $this->username, $this->password, $dbName);
            
            if (!$this->conn) {
                die("Connection failed: " . mysqli_connect_error());
            }
            
            // Force UTF-8 for special characters
            mysqli_set_charset($this->conn, "utf8");
        }

        public function createTable($query) {
            // FIX: Only run the query once inside the check
            if (!mysqli_query($this->conn, $query)) {
                die("Error creating table: " . mysqli_error($this->conn));
            }
        }
    }
?>