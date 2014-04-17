<?php
defined('INAF') or exit('Access Denied');

$GLOBALS['config']['router']['index'] = 'view/day';
$GLOBALS['config']['router']['story'] = 'view/story';
$GLOBALS['config']['router']['list'] = 'view/day';

$GLOBALS['config']['DB']['host'] = 'localhost';
$GLOBALS['config']['DB']['username'] = '';
$GLOBALS['config']['DB']['password'] = '';
$GLOBALS['config']['DB']['database'] = '';
$GLOBALS['config']['DB']['charset'] = 'utf8';