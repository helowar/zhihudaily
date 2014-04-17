<?php
defined('INAF') or exit('Access Denied');
class DB extends AF{
    private $mysql;

    public function __construct($config){
        $this->mysql = mysqli_connect($config['host'],$config['username'],$config['password']) or die ("Database connection error.");
        mysqli_select_db($this->mysql, $config['database']) or die ("Select database error.");
        mysqli_set_charset ($this->mysql , $config['charset'] );
    }

    public function runSql($sql){
        mysqli_query($this->mysql ,$sql) or die(mysqli_error($this->mysql));
    }

    public function getData($sql){
        $result = mysqli_query($this->mysql ,$sql) or die(mysqli_error($this->mysql));
        $array = array();
        while($row = mysqli_fetch_assoc($result)) {
            $array[] = $row;
        }
        return $array;
    }

    public function __destruct(){
        mysqli_close($this->mysql);
    }
}