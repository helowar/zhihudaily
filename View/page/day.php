<div style="margin-top: 47px;" class="row">
    <div class="col-6">
        <h2 class="section-title">
            <?php
            $i = 0;
            if(isset($$i)){
                $data = $$i;
                if($data['date'] == date('Ymd'))
                    print '今日热闻';
                else{
                    $weekarray = array("日","一","二","三","四","五","六");
                    print date('Y.m.d',strtotime($data['date'])) . " 星期".$weekarray[date("w",strtotime($data['date']))];
                }
            }
            ?>
        </h2>
    </div>
</div>
<div class="row features">
    <?php
    $i = 0;
    $col = '';
    while (isset($$i)) {
        $data = $$i;
        $data['image'] = preg_replace('/http:\/\/.+\.zhimg\.com/',"http://zhihudaily.2local.tk/Static/img",$data['image']);
        $col = <<< HTML
        <div class="col-md-4">
            <div href="/story/{$data['id']}" class="feature">
                <div class="mask"></div>
                <img src="{$data['image']}">
                <a href="/story/{$data['id']}">
                    <h3>{$data['title']}</h3>
                </a>
            </div>
        </div>
HTML;
        print $col;
        $i++;
    }
    ?>
</div>
