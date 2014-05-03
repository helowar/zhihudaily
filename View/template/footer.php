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

    ?>
    <br><div class="txt">© 2013-2014 知乎 &middot; Powered by <a href="https://github.com/faceair/zhihudaily">faceair</a></div>
</div>
</body>
</html>