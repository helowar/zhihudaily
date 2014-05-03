<?php
defined('INAF') or exit('Access Denied');
class UA extends AF{
    private $mobiles = array(
                // legacy array, old values commented out
            'mobileexplorer'	=> 'Mobile Explorer',
            //  'openwave'			=> 'Open Wave',
            //	'opera mini'		=> 'Opera Mini',
            //	'operamini'			=> 'Opera Mini',
            //	'elaine'			=> 'Palm',
            'palmsource'		=> 'Palm',
            //	'digital paths'		=> 'Palm',
            //	'avantgo'			=> 'Avantgo',
            //	'xiino'				=> 'Xiino',
            'palmscape'			=> 'Palmscape',
            //	'nokia'				=> 'Nokia',
            //	'ericsson'			=> 'Ericsson',
            //	'blackberry'		=> 'BlackBerry',
            //	'motorola'			=> 'Motorola'

                // Phones and Manufacturers
            'motorola'		=> 'Motorola',
            'nokia'			=> 'Nokia',
            'palm'			=> 'Palm',
            'iphone'		=> 'Apple iPhone',
            'ipad'			=> 'iPad',
            'ipod'			=> 'Apple iPod Touch',
            'sony'			=> 'Sony Ericsson',
            'ericsson'		=> 'Sony Ericsson',
            'blackberry'	=> 'BlackBerry',
            'cocoon'		=> 'O2 Cocoon',
            'blazer'		=> 'Treo',
            'lg'			=> 'LG',
            'amoi'			=> 'Amoi',
            'xda'			=> 'XDA',
            'mda'			=> 'MDA',
            'vario'			=> 'Vario',
            'htc'			=> 'HTC',
            'samsung'		=> 'Samsung',
            'sharp'			=> 'Sharp',
            'sie-'			=> 'Siemens',
            'alcatel'		=> 'Alcatel',
            'benq'			=> 'BenQ',
            'ipaq'			=> 'HP iPaq',
            'mot-'			=> 'Motorola',
            'playstation portable'	=> 'PlayStation Portable',
            'playstation 3'		=> 'PlayStation 3',
            'playstation vita'  	=> 'PlayStation Vita',
            'hiptop'		=> 'Danger Hiptop',
            'nec-'			=> 'NEC',
            'panasonic'		=> 'Panasonic',
            'philips'		=> 'Philips',
            'sagem'			=> 'Sagem',
            'sanyo'			=> 'Sanyo',
            'spv'			=> 'SPV',
            'zte'			=> 'ZTE',
            'sendo'			=> 'Sendo',
            'nintendo dsi'	=> 'Nintendo DSi',
            'nintendo ds'	=> 'Nintendo DS',
            'nintendo 3ds'	=> 'Nintendo 3DS',
            'wii'			=> 'Nintendo Wii',
            'open web'		=> 'Open Web',
            'openweb'		=> 'OpenWeb',

                // Operating Systems
            'android'		=> 'Android',
            'symbian'		=> 'Symbian',
            'SymbianOS'		=> 'SymbianOS',
            'elaine'		=> 'Palm',
            'series60'		=> 'Symbian S60',
            'windows ce'	=> 'Windows CE',

                // Browsers
            'obigo'			=> 'Obigo',
            'netfront'		=> 'Netfront Browser',
            'openwave'		=> 'Openwave Browser',
            'mobilexplorer'	=> 'Mobile Explorer',
            'operamini'		=> 'Opera Mini',
            'opera mini'	=> 'Opera Mini',
            'opera mobi'	=> 'Opera Mobile',
            'fennec'		=> 'Firefox Mobile',

                // Other
            'digital paths'	=> 'Digital Paths',
            'avantgo'		=> 'AvantGo',
            'xiino'			=> 'Xiino',
            'novarra'		=> 'Novarra Transcoder',
            'vodafone'		=> 'Vodafone',
            'docomo'		=> 'NTT DoCoMo',
            'o2'			=> 'O2',

                // Fallback
            'mobile'		=> 'Generic Mobile',
            'wireless'		=> 'Generic Mobile',
            'j2me'			=> 'Generic Mobile',
            'midp'			=> 'Generic Mobile',
            'cldc'			=> 'Generic Mobile',
            'up.link'		=> 'Generic Mobile',
            'up.browser'	=> 'Generic Mobile',
            'smartphone'	=> 'Generic Mobile',
            'cellphone'		=> 'Generic Mobile'
            );

    public function is_mobile(){
        foreach ($this->mobiles as $key => $val){
            if (FALSE !== (stripos(trim($_SERVER['HTTP_USER_AGENT']), $key))){
                return $val;
            }
        }

        return FALSE;
    }
}