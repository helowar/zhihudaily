<?php if(!$is_mobile){ ?>
    <div class="main-content">
        <div class="container-fixed-width">
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

                if(isset($preImage)){
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
                }
                ?>
            </div>
        </div>
    </div>
<?php }else{ ?>
    <div class="main-wrap content-wrap">
        <div class="headline">
            <?php

            $weekarray = array("日","一","二","三","四","五","六");
            $i = 0;
            if(isset($$i)){
                $data = $$i;
                if($data['date'] == date('Ymd'))
                    $display_date = '今日热闻';
                else{
                    $display_date = date('Y.m.d',strtotime($data['date'])) . " 星期".$weekarray[date("w",strtotime($data['date']))];
                }
            }

            $i = 0;
            $col = '';
            while (isset($$i)) {
                $data = $$i;
                if($i == 0){
                    $image = $data['image'];
                    $image_source = $data['image_source'];
                    print  <<< HTML
                        <div class="img-wrap">
                            <h1 class="headline-title">{$display_date}</h1>
                            <span class="img-source">图片：{$image_source}</span>
                            <img src="{$image}">
                        </div>
HTML;
                }

                $col = <<< HTML
                    <div class="headline-background">
                        <a href="/story/{$data['id']}" class="headline-background-link">
                        <div class="heading-content">{$data['title']}</div>
                        </a>
                    </div>
HTML;
                print $col;
                $i++;
            }
            ?>
        </div>

    </div>
<?php } ?>