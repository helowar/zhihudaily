<?php
defined('INAF') or exit('Access Denied');
class view extends AF{
    public function __construct(){
        $this->DB;
        $this->OP;
    }

    public function story($id){
        $data = $this->DB->getData("SELECT * FROM `daily` WHERE `id` = '{$id}'");
        $data[0]['type'] = 'story';
        $this->OP->view('template/header',$data[0]);
        $this->OP->view('template/navbar',$data[0]);
        $this->OP->view('page/story',$data[0]);
        $this->OP->view('template/footer',$data[0]);
    }

    public function day($day = 'today'){
        $day = date('Ymd');
        $data = $this->DB->getData("SELECT * FROM `daily` WHERE `date` = '{$day}' ORDER BY - `date_index`");
        $data['type'] = 'day';
        $this->OP->view('template/header',$data);
        $this->OP->view('template/navbar',$data);
        $this->OP->view('page/day',$data);
        $this->OP->view('template/footer',$data);
    }
}