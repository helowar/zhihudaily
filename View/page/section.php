<?php if(!$is_mobile){ ?>
    <div class="main-content">
        <div class="container-fixed-width">
            <div style="margin-top: 47px;" class="row">
                <div class="col-6">
                    <h2 class="section-title">
                        <?php
                        print $section;
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
                                <h5>{$data['date']}</h5>
                            </a>
                        </div>
                    </div>
HTML;
                    print $col;
                    $i++;
                }
                ?>
            </div>
        </div>
    </div>
<?php }?>