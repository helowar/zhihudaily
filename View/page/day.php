<div style="margin-top: 47px;" class="row">
    <div class="col-6">
        <h2 class="section-title">
            <?php
                print '今日热闻';
            ?>
        </h2>
    </div>
</div>
<div class="row features">
    <?php
    $i = 0;
    $col = '';
    while (isset($$i)) {
        print_r($$i);
        $col += <<< HTML
        <div class="col-md-4">
            <div href="{$$i['share_url']}" class="feature">
                <div class="mask"></div>
                <img src="{$$i['image']}">
                <a href="{$$i['share_url']}">
                    <h3>{$$i['title']}</h3>
                </a>
            </div>
        </div>
HTML;
        $i++;
    }
    print $col;
    ?>
</div>