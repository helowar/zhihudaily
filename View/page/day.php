<div style="margin-top: 47px;" class="row">
    <div class="col-6">
        <h2 class="section-title">
            <?php
            $weekarray = array("日","一","二","三","四","五","六");
            $i = 0;
            if(isset($$i)){
                $data = $$i;
                if($data['date'] == date('Ymd'))
                    print '今日热闻';
                else{
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
        preg_match('/[^\/\\\\]+$/',$data['image'],$imgnames);
        if(isset($imgnames[0]))
            $data['image'] = "/Static/img/" . substr($imgnames[0],0,2) . "/" . substr($imgnames[0],2,2) . "/" .$imgnames[0];
        else
            $data['image'] = "";

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

    preg_match('/[^\/\\\\]+$/',$preImage,$imgnames);
    $preImage = "/Static/img/" . substr($imgnames[0],0,2) . "/" . substr($imgnames[0],2,2) . "/" .$imgnames[0];

    $preDay = date('Ymd',strtotime($data['date']) - 3600*24);
    $preDisplay = date('Y.m.d',strtotime($preDay)) . " 星期".$weekarray[date("w",strtotime($preDay))];

    $preHtml = <<< HTML
        <div class="col-md-4">
            <div href="/day/{$preDay}" class="feature">
                <div class="mask"></div>
                <img src="{$preImage}">
                <a href="/day/{$preDay}">
                    <h3>{$preDisplay}</h3>
                </a>
            </div>
        </div>
HTML;
    print $preHtml;

    ?>
</div>