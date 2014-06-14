<?php
if(!$is_mobile && $type == 'day'){
    if(!isset($home)){
        $home = "/";
    }
    print <<< HTML
<div class="header navbar-fixed-top">
    <div class="container-fixed-width clearfix">
        <h1 class="logo">
            <a href="{$home}" title="知乎" class="link-logo" target="_self"></a>
        </h1>

        <div class="link">
             <a href="/sections/" class="button">专题</a>
             <a href="https://www.google.com.hk/search?q=%E7%9E%8E%E6%89%AF+site%3Adaily.zhihu.com" title="搜索" class="link-search"><i class="ico"></i></a>
             <a href="/rss.xml" title="订阅RSS" class="link-rss"><i class="ico"></i></a>
        </div>
    </div>
</div>
HTML;
}elseif($type == 'story' || $is_mobile && $type == 'day'){
    if($type == 'story' && isset($date))
        $home = "/day/{$date}";
    else
        $home = "/";
    print <<< HTML
<div class="global-header">
	<div class="main-wrap">
		<a href="{$home}" target="_self" title="知乎日报"><i class="web-logo"></i></a>
	</div>
</div>
HTML;
}
