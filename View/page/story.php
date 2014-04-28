<?php
$image = preg_replace('/http:\/\/.+\.zhimg\.com/',"http://zhihudaily.2local.tk/Static/img",$image);
$body = preg_replace('/http:\/\/.+\.zhimg\.com/',"http://zhihudaily.2local.tk/Static/img",$body);

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