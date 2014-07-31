<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title><?php if(isset($title)) print $title . " - 知乎日报";else print "知乎日报 - 满足你的好奇心";?></title>
    <meta charset="utf-8">
    <meta name="description" content="知乎日报以独有的方式为你提供最高质、最深度、最有收获的阅读体验。每天 3 次，每次 7 分钟，获取最值得看的新闻资讯和深度解读。" />
    <meta name="keywords" content="知乎日报,知乎日报网页版,zhihuribao,zhihudaily,知乎,支护日报,知道日报" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <?php
    if(!$is_mobile && $type == 'day'){
        print '<link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.0.3/css/bootstrap.min.css"><link rel="stylesheet" href="/Static/css/day.css"><base target="_self">';
    }elseif($type == 'story' || $is_mobile && $type == 'day')
        print '<link rel="stylesheet" href="/Static/css/story.css"><base target="_blank">';
    ?>
</head>
<body class="home">