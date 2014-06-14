<?php
date_default_timezone_set("Asia/Shanghai");
define('INAF',true);
define('AFROOT',str_replace('\\', '/', dirname(__FILE__)));
spl_autoload_register("my_autoload");

include(AFROOT . '/config.php');

preg_match("/[\w\/%]+/",substr($_SERVER['REQUEST_URI'],1), $matches) or $matches[0] = "";
$urlParam = explode('/',$matches[0]);

if(!isset($urlParam[1])){
    $controllerParam = explode('/',$config['router']['default']);
    if(isset($config[$controllerParam[0]]))
        $Class = new $controllerParam[0]($config[$controllerParam[0]]);
    else
        $Class = new $controllerParam[0]();
    if(isset($controllerParam[1]))
        $Class->$controllerParam[1]();
    else
        $Class->index();
    exit;
}

foreach($config['router'] as $key => $value){
    if($key == $urlParam[0]){
        $controllerParam = explode('/',$value);
        if(isset($config[$controllerParam[0]]))
            $Class = new $controllerParam[0]($config[$controllerParam[0]]);
        else
            $Class = new $controllerParam[0]();
        if(isset($controllerParam[1]))
            $Class->$controllerParam[1]($urlParam[1]);
        else
            $Class->index($urlParam[1]);
    }
}

function my_autoload ($ClassName) {
    if(file_exists(AFROOT . "/Controller/" . $ClassName . ".php"))
        include(AFROOT . "/Controller/" . $ClassName . ".php");
    elseif(AFROOT . "/Model/" . $ClassName . ".php")
        include(AFROOT . "/Model/" . $ClassName . ".php");
    else
        die('Not Found Class ' . $ClassName);
}

class AF{
    public function __get($method){
        if(isset($GLOBALS['config'][$method]) and !isset($this->$method))
            $this->$method = new $method($GLOBALS['config'][$method]);
        elseif(!isset($this->$method))
            $this->$method = new $method();
    }
}