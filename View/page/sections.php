<?php if(!$is_mobile){ ?>
    <div class="main-content">
        <div class="container-fixed-width">
            <div style="margin-top: 47px;" class="row">
                <div class="col-6">
                    <h2 class="section-title">
                        专题
                    </h2>
                </div>
            </div>
            <div class="row features">
                <?php
                $i = 0;
                $col = '';
                while (isset($$i)) {
                    $data = $$i;
                    if($data['count'] > 5){
                        $data['section_url'] = urlencode($data['section']);
                        $col = <<< HTML
                    <div class="col-md-4">
                        <div href="/section/{$data['section_url']}" class="feature">
                            <div class="mask"></div>
                            <img src="{$data['image']}">
                            <a href="/section/{$data['section_url']}">
                                <h3>{$data['section']}</h3>
                            </a>
                        </div>
                    </div>
HTML;
                        print $col;
                    }
                    $i++;
                }
                ?>
            </div>
        </div>
    </div>
<?php }?>