<?php
defined('INAF') or exit('Access Denied');
class OP{
    public function view($path, $data = ''){
        if(!empty($data)){
            foreach ($data as $key => $value)
                $$key = $value;
        }

        if(file_exists(AFROOT . '/View/' . $path . '.php'))
            include(AFROOT . '/View/' . $path . '.php');
        else
            die('Not Found Template ' . AFROOT . '/View/' . $path . '.php');
    }
}



