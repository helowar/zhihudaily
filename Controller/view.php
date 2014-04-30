<?php
defined('INAF') or exit('Access Denied');
class view extends AF{
    public function __construct(){
        $this->DB;
        $this->OP;
    }

    public function story($id){
        $data = $this->DB->getData("SELECT * FROM `daily` WHERE `id` = '{$id}'");
        if(count($data) == 0)
            $this->OP->view('error/404');
        else{
            $data[0]['type'] = 'story';
            $this->OP->view('template/header',$data[0]);
            $this->OP->view('template/navbar',$data[0]);
            $this->OP->view('page/story',$data[0]);
            $this->OP->view('template/footer',$data[0]);
        }
    }

    public function day($day = 'today'){
        if($day == 'today'){
            $day = date('Ymd');
            $data = $this->DB->getData("SELECT * FROM `daily` WHERE `date` = '{$day}' ORDER BY - `date_index`");
            if(count($data) == 0){
                $day = date('Ymd', time() - 60 * 60 * 24);
                $data = $this->DB->getData("SELECT * FROM `daily` WHERE `date` = '{$day}' ORDER BY - `date_index`");
            }
        }else{
            $data = $this->DB->getData("SELECT * FROM `daily` WHERE `date` = '{$day}' ORDER BY - `date_index`");
        }
        $preDay = date('Ymd',strtotime($day) - 3600*24);
        $preData = $this->DB->getData("SELECT image FROM daily WHERE `date` = '{$preDay}' ORDER BY rand() LIMIT 1");
        if(count($preData) != 0)
            $data["preImage"] = $preData[0]["image"];

        if(count($data) == 0)
            $this->OP->view('error/404');
        else{
            $data['type'] = 'day';
            $this->OP->view('template/header',$data);
            $this->OP->view('template/navbar',$data);
            $this->OP->view('page/day',$data);
            $this->OP->view('template/footer',$data);
        }
    }
}