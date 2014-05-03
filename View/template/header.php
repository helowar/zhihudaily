<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title><?php if(isset($title)) print $title . " - 知乎日报";else print "知乎日报 - 满足你的好奇心";?></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php
    if(!$is_mobile && $type == 'day'){
        print '<link rel="stylesheet" href="/Static/css/bootstrap.min.css">';
        print '<link rel="stylesheet" href="/Static/css/day.css">';
    }elseif($type == 'story' || $is_mobile && $type == 'day')
        print '<link rel="stylesheet" href="/Static/css/story.css">';
    ?>
    <base target="_self">
</head>
<body class="home">