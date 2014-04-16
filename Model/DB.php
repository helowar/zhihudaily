<?php
defined('INAF') or exit('Access Denied');
class DB{
    private $mysql;

    public function __construct($config){
        $this->mysql = mysqli_connect($config['host'],$config['username'],$config['password']) or die ("Database connection error.");
        mysqli_select_db($this->mysql, $config['database']) or die ("Select database error.");
        mysqli_set_charset ($this->mysql , $config['charset'] );
    }

    public function runSql($sql){
        mysqli_query($this->mysql ,$sql[0]) or die(mysqli_error());
    }

    public function getData($sql){
        $result = mysqli_query($this->mysql ,$sql[0]) or die(mysqli_error());
        $array = array();
        while($row = mysqli_fetch_assoc($this->mysql ,$result)) {
            $array[] = $row;
        }
        return $array;
    }

    public function __destruct(){
        mysqli_close($this->mysql);
    }
}