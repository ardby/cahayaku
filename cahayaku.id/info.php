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
function footer() {
  global $nama_pt,$domain,$sosmed;
  ?>
  <div class="container-fluid">
    <div class="row">
      <div class="col-1"></div>
      <div class="col-md-3 footer">
        Komplek Cluster Bali 2<br>
        Blok A-51<br>
        Kiaracondong, Bandung
      </div>
      <div class="col-md-3 footer">
        Phone : 0821-1234-5678<br>
        Email : cs@<?=$domain?>
      </div>
      <div class="col-md-3 footer">
        <table>
          <tr>
            <td nowrap colspan="4"><?=$nama_pt?></td>
          </tr>
          <tr>
            <td colspan="4" style="padding-bottom:0.5rem;">https://<?=$domain?></td>
          </tr>
          <tr>
            <? foreach($sosmed as $k=>$v) { ?>
              <td><img src="img/<?=$v?>.png"></td>
            <? } ?>
          </tr>
        </table>
      </div>
    </div>
  </div>
  <?
}
function top_label() {
  global $nama_pt;
  ?>
  <div class="top-label navbarku">
    <img src="img/logo.png" class="top-logo">
    <br>
    <span class="top-company"><?=$nama_pt?></span>
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
    <? top_menu("Informasi"); ?>
    <? ///=== START OF RESPONSIVE CONTENT SECTION === ?>
    <div class="container-fluid container-info">
      <div style="padding:1vmax;">
        <div class="navbarku" style="padding:3vmax;border-radius:2vmax;">
          <span style="font-family:Caveat;font-size:2.5rem;color:#99784C;">Bisnis air </span>
          <!-- <span style="font-family:Squada One;font-size:1.8rem;color:#5A2052;"> ALMAplus </span> -->
          <span style="font-family:Squada One;font-size:1.8rem;color:#802D74;"> ALMAplus </span>
          <span style="font-family:Caveat;font-size:2.5rem;color:#99784C;">dapat <b>Cash Back</b>&nbsp;</span>
          <span style="font-family:Knewave;font-size:2rem;color:green;">100%</span>
          <div style="padding-top:2rem;text-align:left;font-size:1rem;color:#1E1E1E;">
              Air ALMAplus sebagai Media Terapi Beragam Penyakit Tanpa Meninggalkan Endapan/Metabolit Pada Ginjal.<br><br>

              IKHTIARKAN Pengobatan Penyakit Anda dengan konsumsi ALMAplus<br>
              Produk ini bukan Suplement, TIDAK akan meninggalkan ampas di ginjal Karena TDS nya d bwah 50 ppm asli<br>

              ALMAplus adalah Air Minum kemasan ber-Alkali >PH9+ terbaik dan terlengkap kandungan nya di Indonesia yang diproses dengan Teknologi Ultrafitrasi, Ionisasi,  Magnetasi & Ultraviolet<br>
              👉 Hidrogen Aktif<br>
              👉 Ion Negatif<br>
              👉 Hexagonal<br>
              👉 Tds Rendah (dibawah <40ppm) <br>
              👉 Oksigen <br>
              👉 Antioksidan <br>
              👉 Mikro Water<br><br>

              BISNIS AIR ALMAplus modal 3.500.000 dapat :<br>
              👉 Air ALMAplus 16 kotak , 1 kotak 12 botol @ 600ml<br>
              👉 Cash Back 💯% senilai 3.5 Juta <br>
              👉 Bonus Sponsor 450.000<br>
              👉 Bonus Pasangan 125.000 (1 juta/hari)<br>
              👉 Reward dari 1 jt - 500 jt <br><br>

              ☎️ : Tomi 081818188388<br>
          </div>
        </div>
      </div>
    </div>
    <? ///==== END OF RESPONSIVE CONTENT SECTION ===== ?>

    <? ///=== START OF RESPONSIVE CONTENT SECTION === ?>
    <div class="container-fluid container-info">
      <div style="padding:1vmax;">
        <div class="navbarku" style="padding:3vmax;border-radius:2vmax;">
          <div style="text-align:left;font-size:1rem;color:#1E1E1E;">
            👉 Ngopi Bisnis ku...<br>
            <br>
            👉 Bisnis ku Ngopi...<br>
            <br>
            👉 Ngopi Sumber Penghasilanku...<br>
            <br>
            BISNIS PASTI UNTUNG 💯%<br>
            ☕🇰‌‌🇴‌‌🇵‌‌🇮‌ 🇩‌‌🇺‌‌🇷‌‌🇮‌‌🇦‌‌🇹‌ ☕ Produk Dapat Modal Balik Lagi 💯%<br>
            <br>
            ☕🇰‌‌🇴‌‌🇵‌‌🇮‌ 🇩‌‌🇺‌‌🇷‌‌🇮‌‌🇦‌‌🇹☕   Arabica Java Puntang , Winner Of APVA Paris 2020<br>
            <br>
            BISNIS KOPI DURIAT modal 3.500.000 dapat :<br>
            👉 Kopi 16 kotak , 1 kotak 15 sachet @12 gram<br>
            👉 Cash Back 💯% senilai 3.5 Juta <br>
            👉 Bonus Sponsor 450.000<br>
            👉 Bonus Pasangan 125.000 (1 juta/hari)<br>
            👉 Reward dari 1 jt - 500 jt <br>
            <br>
            ☎️ : Tomi<br>
          </div>
        </div>
      </div>
    </div>
    <? ///==== END OF RESPONSIVE CONTENT SECTION ===== ?>

    <? footer(); ?>
    <? scripts(); ?>
    <? top_label(); ?>

  </body>
</html>
<? ///==== END OF PAGE ====//// ?>

