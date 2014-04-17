<?php
defined('INAF') or exit('Access Denied');

$GLOBALS['config']['router']['index'] = 'view/day';
$GLOBALS['config']['router']['story'] = 'view/story';
$GLOBALS['config']['router']['list'] = 'view/day';

$GLOBALS['config']['DB']['host'] = 'localhost';
$GLOBALS['config']['DB']['username'] = 'faceair';
$GLOBALS['config']['DB']['password'] = 'ml285714285';
$GLOBALS['config']['DB']['database'] = 'faceair_zhihu';
$GLOBALS['config']['DB']['charset'] = 'utf8';