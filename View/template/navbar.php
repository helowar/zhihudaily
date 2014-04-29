<?php
if($type == 'day')
    print <<< HTML
<div class="header navbar-fixed-top">
    <div class="container-fixed-width clearfix">
        <h1 class="logo">
            <a href="/" title="知乎" class="link-logo" target="_self"></a>
        </h1>
        <div class="about-us">
             <a href="https://www.google.com.hk/search?q=%E7%9E%8E%E6%89%AF+site%3Adaily.zhihu.com" title="搜索" class="link-search"><i class="ico"></i></a>
             <a href="/rss.xml" title="订阅RSS" class="link-rss"><i class="ico"></i></a>
        </div>
    </div>
</div>
<div class="main-content">
    <div class="container-fixed-width">
HTML;
elseif($type == 'story')
    print <<< HTML
<div class="global-header">
	<div class="main-wrap">
		<a href="/day/{$date}" target="_self" title="知乎日报"><i class="web-logo"></i></a>
	</div>
</div>
HTML;
