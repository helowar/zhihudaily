<?php
defined('INAF') or exit('Access Denied');
class OP{
    public function __construct(){

    }

    public function view($path,$data = ''){
        if(file_exists(AFROOT . '/View/' . $path . '.php'))
            $content = file_get_contents(AFROOT . '/View/' . $path . '.php');
    }
}



