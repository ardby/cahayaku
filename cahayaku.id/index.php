<?
/// ===================================================
/// Global Variables
/// ===================================================
$nama_pt = "PT Cahaya Usaha Amanah Nusantara";
$domain  = "cahayaku.id";
$teks    = ["Kopi Duriat merupakan kopi yang memiliki ciri khas Aroma yang wangi yang tumbuh pada daerah yang dingin dan sejuk,
            memiliki rasa yang sedikit Asam, rasa kental di mulut, pahit dan juga memiliki tekstur lebih halus yang menjadikan
            citra rasa nikmat melekat di lidah dan di hati sehingga setiap penikmat susah melupakan.",
            "AlmaPlus air pH tinggi adalah produk unggulan yang fenomenal, sebuah produk air minum pH tinggi yang didesain sesuai untuk tubuh,
            menjadikannya salah satu air pH tinggi terbaik yang pernah ada."];
$sosmed  = ["fb","ig","tw","in"];

include_once("common.php");

/// ===================================================
/// Global Functions
/// ===================================================
function duriat_picture() { ?>
  <div class="top_coffee">
    <img src="img/duriat_home_1.png" style="height:100%">
  </div>
  <?
}
function login_fancy($orient="") {
  $css = $orient=="portrait"?"_narrow":"";
  ?>
  <div class="login_fancy<?=$css?>">
    <img src="img/login_fancy.png" style="height:100%">
  </div>
  <?
}
function register_fancy($orient="") {
  $css = $orient=="portrait"?"_narrow":"";
  ?>
  <div class="register_fancy<?=$css?>">
    <img src="img/register_fancy.png" style="height:100%">
  </div>
  <?
}
function coffee_bean() { ?>
  <div class="coffee_bean">
    <img src="img/coffee_bean.png" style="width:100%">
  </div>
  <?
}
function almaplus_picture($orient="") {
  $css = $orient=="portrait"?"_narrow":"";
  ?>
  <div class="almaplus_splash<?=$css?>">
    <img src="img/almaplus_splash.png" style="height:100%">
  </div>
  <?
}
function duriat_and_almaplus_desc() {
  global $teks;
  ?>
  <div class="product_desc">
    <p><?=$teks[0]?></p>
    <br>
    <p><?=$teks[1]?></p>
  </div>
  <?
}
function duriat_desc_portrait() {
  global $teks;
  ?>
  <div class="col-12 col1">
    <div class="product_desc_narrow1">
      <p><?=$teks[0]?></p>
    </div>
  </div>
  <?
}
function almaplus_desc_portrait() {
  global $teks;
  ?>
  <div class="product_desc_narrow2">
    <p><?=$teks[1]?></p>
  </div> <?
}
function footer() {
  global $nama_pt,$domain,$sosmed;
  ?>
  <div class="container-fluid">
    <div class="row">
      <div class="col-1"></div>
      <div class="col-md-2 footer">
        Komplek Cluster Bali 2<br>
        Blok A-51<br>
        Kiaracondong, Bandung
      </div>
      <div class="col-md-2 footer">
        Phone : 0821-1234-5678<br>
        Email : cs@<?=$domain?>
      </div>
      <div class="col-md-2 footer">
        <table>
          <tr>
            <td class="footer2" rowspan="3"><img src="img/logo.png" style="width:min(4vmax,4rem)"></td>
            <td class="footer2" nowrap colspan="4"><?=$nama_pt?></td>
          </tr>
          <tr>
            <td class="footer2" colspan="4" style="padding-bottom:0.5rem;">https://<?=$domain?></td>
          </tr>
          <tr>
            <? foreach($sosmed as $k=>$v) { ?>
              <td class="footer2"><img src="img/<?=$v?>.png"></td>
            <? } ?>
          </tr>
        </table>
      </div>
      <div class="col-3"></div>
    </div>
  </div>
  <?
}

/// ===================================================
/// START OF PAGE
/// ===================================================
page_start();
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <? head_metas(); ?>
    <? head_links(); ?>
    <? head_scripts(); ?>
    <? head_title($nama_pt); ?>
  </head>
  <body>
    <? duriat_picture(); ?>
    <? top_menu("Beranda"); ?>
    <? ///=== START OF RESPONSIVE LANDSCAPE SECTION === ?>
    <div id="horz" class="container-fluid">
      <table style="width:100%;">
        <tr class="rowatas">
          <td class="cellkiri cellatas cellkiriatas">
            <? duriat_and_almaplus_desc(); ?>
          </td>
          <td class="cellkanan cellatas cellkananatas"></td>
        </tr>
        <tr class="rowbawah">
          <td class="cellkiri cellbawah cellkiribawah">
            <? login_fancy(); ?>
            <? register_fancy(); ?>
            <? coffee_bean(); ?>
          </td>
          <td class="cellkanan cellbawah cellkananbawah">
            <? almaplus_picture(); ?>
          </td>
        </tr>
      </table>
    </div>
    <? ///==== END OF RESPONSIVE LANDSCAPE SECTION ===== ?>
    <? ///==== START OF RESPONSIVE PORTRAIT SECTION ==== ?>
    <div id="vert" class="container-fluid">
      <? greetings_portrait(); ?>
      <? duriat_desc_portrait(); ?>
      <div class="col-12 col2">
        <div class="col2-upper">
          <? login_fancy("portrait"); ?>
          <? register_fancy("portrait"); ?>
          <? coffee_bean(); ?>
        </div>
      </div>
      <div class="col-12 col3">
        <? almaplus_picture("portrait"); ?>
        <? almaplus_desc_portrait(); ?>
      </div>
    </div>
    <!--- END OF RESPONSIVE PORTRAIT SECTION --->
    <? footer(); ?>
    <? scripts(); ?>
  </body>
</html>
<? ///==== END OF PAGE ====//// ?>

