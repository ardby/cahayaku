<?
function page_start() {
  date_default_timezone_set("Asia/Jakarta");
  ?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <?
}
function head_metas() { ?>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <?
}
function head_links() { ?>
  <link rel="icon" type="image/x-icon" href="img/favicon.ico">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
  <link rel="stylesheet" href="css/sansation/specimen_files/specimen_stylesheet.css" type="text/css" charset="utf-8" />
  <link rel="stylesheet" href="css/sansation/stylesheet.css" type="text/css" charset="utf-8" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Josefin Sans" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Caveat" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Squada One" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Knewave" />
  <link rel="stylesheet" href="css/localstyle.css" type="text/css" charset="utf-8" />
  <?
}
function head_scripts() { ?>
  <script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
  <?
}
function head_title($title) { ?>
  <title><?=$title?></title>
  <?
}
function greetings_portrait() {
  $t = [
        "malam       <br>lepas penat, tetap sehat",
        "sore        <br>berkah hasil hari ini",
        "siang       <br>tetap semangat raih mimpi",
        "pagi        <br>mari mencari berkah",
        "memulai hari<br>semangat sambut sukses",
        "istirahat   <br>bertemu esok yang cerah"
       ];
  ?>
  <div class="col-12 title-narrow">
    Selamat <?=date('H')>18?$t[0]:(date('H')>15?$t[1]:(date('H')>11?$t[2]:(date('H')>8?$t[3]:(date('H')>0?$t[4]:$t[5]))))?>
  </div>
  <?
}
function top_menu($menu) { ?>
  <div class="container-fluid">
    <div class="row">
      <div class="col">
        <nav class="navbar navbar-expand-lg navbarku">
          <span class="navbar-brand">&nbsp;</span>
        </nav>
      </div>
      <div class="col">
        <nav class="navbar navbar-expand-lg navbarku">
          <div class="container-fluid">
            <span class="navbar-brand">&nbsp;</span>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#cuanMenu" aria-controls="cuanMenu" aria-expanded="false">
              <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="cuanMenu">
              <ul class="navbar-nav ml-auto">
                <? if($menu=="Beranda") menu_item("Beranda","navbarku","active","#"); else menu_item("Beranda","navbarku","tulisan1","index.php","pertama"); ?>
                <? if($menu=="Informasi") menu_item("Informasi","navbarku","active","#"); else menu_item("Informasi","navbarku","tulisan1","info.php"); ?>
                <? menu_item("Produk","navbarku","tulisan1","#"); ?>
                <? menu_item("Kemitraan","navbarku","tulisan1","#"); ?>
                <? menu_item("Profil","navbarku","tulisan1","#"); ?>
                <span class="batas" id="batas"></span>
                <? menu_item("Daftar","menu-lain kiri","tulisan2","#","kiri"); ?>
                <? menu_item("Login","menu-lain kanan","tulisan2","#"); ?>
              </ul>
            </div>
          </div>
        </nav>
      </div>
    </div>
  </div>
  <?
}

function menu_item($text,$class1,$class2,$link,$id="") { ?>
  <li <?=($id=='')?'':'id="'.$id.'"'?> class="nav-item <?=$class1?>">
    <a class="nav-link <?=$class2?>" <?=$class2=="active"?'aria-current="page"':''?> href="<?=$link?>"><?=$text?></a>
  </li>
  <?
}
function scripts() { ?>
  <script>
    $(document).ready(function() {
      function showWide() {
        $("#vert").hide();
        $("#horz").show();
      }
      function showNarrow() {
        $("#vert").show();
        $("#horz").hide();
      }
      function updateSize() {
        $(".cellkiri").width($('#batas').offset().left+16);
        $(".cellkanan").width($(window).width()-$('#batas').offset().left-16);
      }
      function refresh() {
        if ($('.navbar-toggler').is(':hidden')) {
          $('.kanan').removeClass('bulet');
          $('.menu-lain').addClass('menu-lain-horz');
          $('#kiri').addClass('kiri');
          $('#pertama').removeClass('navbarku');
          updateSize();
          showWide();
        } else {
          $('.kanan').addClass('bulet');
          $('.menu-lain').removeClass('menu-lain-horz');
          $('#kiri').removeClass('kiri');
          $('#pertama').addClass('navbarku');
          showNarrow();
        }
      }
      setTimeout(function() {refresh();}, 100);
      setTimeout(function() {refresh();}, 500);
      setTimeout(function() {refresh();}, 2000);
      $(window).on('resize', function() {
        refresh();
        setTimeout(function() {refresh();}, 2000);
      });
    });
  </script>
  <?
}

?>
