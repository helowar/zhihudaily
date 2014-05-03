<?php
preg_match('/[^\/\\\\]+$/',$image,$imgnames);
if(isset($imgnames[0]))
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
if(isset($image))
    $body = str_replace('<div class="img-place-holder"></div>',$imgwrap,$body);

if(strpos($body,"禁止转载"))
    print <<< HTML
<center><h3>本答案禁止转载，正在跳转到原链接</h3></center>
<script language="javascript" type="text/javascript">
       window.setTimeout("location='{$share_url}'", 1000);
</script>
HTML;
else{
    print $body;
}