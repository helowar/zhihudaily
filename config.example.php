<?php
defined('INAF') or exit('Access Denied');

$config = array();

$config['router']['index'] = 'view/day';
$config['router']['story'] = 'view/story';
$config['router']['list'] = 'view/day';

$config['DB']['host'] = 'localhost';
$config['DB']['username'] = '';
$config['DB']['password'] = '';
$config['DB']['database'] = 'zhihu';
$config['DB']['charset'] = 'utf8';

return $config;