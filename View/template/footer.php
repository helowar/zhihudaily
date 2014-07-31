<div class="footer">
    <?php
    if($is_mobile && $type == 'day'){
        $i = 0;
        $data = $$i;
        $preDay = date('Ymd',strtotime($data['date']) - 3600*24);
        print <<< HTML
            <div class="f">
                <a target="_self" href="/day/{$preDay}" class="page-btn">前一天</a>
            </div>
HTML;
    }

    if(!$is_mobile){ ?>
        <br><div class="txt">内容转载自 知乎日报 ，项目开源于 <a href="https://github.com/faceair/zhihudaily">Github</a> ，感谢 <a href="http://tietuku.com/">贴图库</a> 提供图片外链</div>
    <?php }else{ ?>
        <br><div class="txt">内容转载自 知乎日报 ，项目开源于 <a href="https://github.com/faceair/zhihudaily">Github</a></div>
    <?php }?>
</div>
<script>
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?339d749938744acd9bea875d1d494696";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
</body>
</html>