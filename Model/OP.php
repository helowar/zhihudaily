<?php
defined('INAF') or exit('Access Denied');
class OP{
    public function view($path, $data = ''){
        if(file_exists(AFROOT . '/View/' . $path . '.php')){
            include(AFROOT . '/View/' . $path . '.php');
        }else{
            $data = array('msg'=>$path . ' Not Found.');
            include(AFROOT . '/View/error/404.php');
        }
    }
}



