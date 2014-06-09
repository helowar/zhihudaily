<?php
defined('INAF') or exit('Access Denied');

$GLOBALS['config']['router']['default'] = 'view/day';
$GLOBALS['config']['router']['story'] = 'view/story';
$GLOBALS['config']['router']['day'] = 'view/day';
$GLOBALS['config']['router']['sections'] = 'view/sections';
$GLOBALS['config']['router']['section'] = 'view/section';

$GLOBALS['config']['DB']['host'] = 'localhost';
$GLOBALS['config']['DB']['username'] = '';
$GLOBALS['config']['DB']['password'] = '';
$GLOBALS['config']['DB']['database'] = '';
$GLOBALS['config']['DB']['charset'] = 'utf8';