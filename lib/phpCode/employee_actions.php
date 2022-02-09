<?php

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "TestDB";
    $table = "Employees";   // Lets create a table named Employees

    // We will get actions from app to do operations in the database...
    $action = $_POST["action"];

    // Create connexion
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connexion
    if($conn->connect_error){
        die("Connexion failed: " . $conn->connect_error);
        return;
    }

    // If connexion is OK..

    // If the app sends an action to create the table...
    if("CREATE_TABLE" == $action){
        $sql = "CREATE TABLE IF NOT EXISTS $table (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            first_name VARCHAR(30) NOT NULL,
            last_name VARCHAR(30) NOT NULL 
            )";

        if($conn->query($sql) === TRUE){
            // Send back success message
            echo "Success";
        }else{
            echo "Error";
        }
        $conn->close();
        return;
    }

    // Get all employee records from the database    
    if("GET_ALL" == $action){
        $db_data = array();
        $sql = "SELECT id, first_name, last_name FROM $table ORDER By id DESC";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

    // Add an Employee
    if("ADD_EMP" == $action){
        // App will be posting these values to this server
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];
        $sql = "INSERT INTO $table (first_name, last_name) VALUES ('$first_name', '$last_name')";
        $result = $conn->query($sql);
        echo "Success";
        $conn->close();
        return;
    }

    // Update an Employee
    if("UPDATE_EMP" == $action){
        // App will be posting these values to this server
        $emp_id = $_POST["emp_id"];
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];
        $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' WHERE id = $emp_id";
        if($conn->query($sql) === TRUE){
            echo "Success";
        }else{
            echo "Error";
        }
        $conn->close();
        return;
    }

    // Delete an Employee
    if("DELETE_EMP" == $action){
        $emp_id = $_POST["emp_id"];
        $sql = "DELETE FROM $table WHERE id = $emp_id";
    }


?>