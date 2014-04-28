<?php
preg_match('/[^\/\\\\]+$/',$image,$imgnames);
$image = "/Static/img/" . substr($imgnames[0],0,2) . "/" . substr($imgnames[0],2,2) . "/" .$imgnames[0];

preg_match_all('/http:\/\/[\w-]+\.zhimg([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/',$body,$urlnames);
foreach($urlnames[0] as $urlname){
    preg_match('/[^\/\\\\]+$/',$urlname,$imgnames);
    $imageurl = "/Static/img/" . substr($imgnames[0],0,2) . "/" . substr($imgnames[0],2,2) . "/" .$imgnames[0];
    $body = str_replace($urlname,$imageurl,$body);
}

$imgwrap = <<< HTML
<div class="img-wrap">
    <h1 class="headline-title">{$title}</h1>
    <span class="img-source">图片：{$image_source}</span>
    <img src="{$image}" alt="">
    <div class="img-mask"></div>
</div>
HTML;

$body = str_replace('<div class="img-place-holder"></div>',$imgwrap,$body);

print $body;