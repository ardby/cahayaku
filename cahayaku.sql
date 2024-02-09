/* DROP */

drop table transaksi;
drop table "order";
drop table coa;
drop table tacc;
drop table agen;
drop table wilayah;
drop table pin;
drop table harga;
drop table brgjasa;
drop table user_has_roles;
drop table model_has_roles;
drop table model_has_permissions;
drop table role_has_permissions;
drop table users;
drop table roles;
drop table permissions;
drop table member_struct;
drop table "member";

drop type orderstate;
drop type journalitem;
drop type business;
drop type bank;
drop type person;
drop type personalid;
drop type contact;
drop type fixedlocation;
drop type geolocation;
drop type logfull;
drop type logsimple;
drop function mbid;
drop type memberid;
drop type packagetype;
drop type partytype;
drop type pinstatus;
drop type assetstatus;
drop type status;
drop type personalidtype;
drop type gender;

/* CREATE */
create type gender AS enum ('L', 'P');

create type personalidtype AS enum ('NIK', 'PASPOR');

create type status AS enum ('PRE-ACTIVATED', 'ACTIVE', 'EXPIRED', 'SUSPENDED', 'BLOCKED', 'DELETED');

create type assetstatus AS enum ('PRE-STOCK', 'IN STOCK', 'SOLD', 'UNDER REPAIR', 'DISPOSED');

create type pinstatus AS enum ('GENERATED', 'SOLD', 'USED', 'EXPIRED', 'RECYCLED');

create type partytype as enum ('MEMBER','STOKIS','MASTER STOKIS','PERUSAHAAN','PEMASOK','PENYEDIA JASA','PAJAK');

create type packagetype as enum ('BASIC','SILVER','GOLD');

create type memberid as (
	type char(1),
	no integer
);
create function mbid(memberid) returns varchar as 'select concat($1.type,lpad(cast($1.no as varchar), 9, ''0''))' language sql;

create type logsimple as (
	by varchar,
	at timestamp
);

create type logfull as (
	created logsimple,
	updated logsimple
);

create type geolocation as (
	latitude float,
	longitude float
);

create type fixedlocation as (
	alamat text,
	wilayah varchar(50),
	posisi geolocation
);

create type contact as (
	nama varchar(50),
	hp varchar(20),
	email varchar(50)
);

create type personalid as (
	type personalidtype,
	no varchar(20)
);

create type person as (
	id personalid,
	tplahir varchar(50),
	tglahir date,
	jkel gender,
	telp varchar(20),
	lokasi fixedlocation
);

create type bank as (
	nama varchar(50),
	rek varchar(30),
	cabang varchar(50),
	nasabah varchar(50)
);

create type business as (
	npwp varchar(20),
	bank bank,
	ahliwaris varchar(50),
	hubwaris varchar(20)
);

create type journalitem as (
	id_coa varchar(25),
	nilai float,
	tarif money,
	id_pihak integer
);

create type orderstate as (
	id_tran integer,
	waktu timestamp
);

/* === Tabel member ===  */
create table "member" (
	id_member memberid primary key,
	id_sponsor memberid,
	id_upline memberid,
	profil person,
	bisnis business,
	tipepaket packagetype,
	tgaktif timestamp
);

/* 
Struktur tabel member
1. id_member --> function mbid (untuk menggabungkan type dan no menjadi 10 digit ID)
	1.1 type
	1.2 no
2. id_sponsor
	2.1 type
	2.2 no
3. id_upline
	3.1 type
	3.2 no
4. profil
	4.1 kontak
		4.1.1 nama
		4.1.2 hp
		4.1.3 email
	4.2 id
		4.2.1 type --> ('NIK', 'PASPOR')
		4.2.2 no
	4.3 tplahir
	4.4 tglahir
	4.5 jkel --> ('L', 'P')
	4.6 telp
	4.7 lokasi
		4.7.1 alamat
		4.7.2 wilayah --> like ke kodekec di tabel wilayah
		4.7.3 posisi
			4.7.3.1 latitude
			4.7.3.2 longitude
5. bisnis
	5.1 npwp
	5.2 bank
		5.2.1 nama
		5.2.2 rek
		5.2.3 cabang
		5.2.4 nasabah
	5.3 ahliwaris
	5.4 hubwaris
6. tipemember --> link ke tabel tipe, kategori member
7. tipepaket  --> link ke tabel tipe, kategori paket
8. tgaktif
9. status --> ('ACTIVE', 'DORMANT', 'SUSPENDED', 'BLOCKED')
10. log
	10.1 created_by
	10.2 created_at
	10.3 updated_by
	10.4 updated_by
----------------------------------------------------------------
Penamaan kolom:

id_member.type			\ panggil function mbid(id_member) untuk mendapatkan ID dalam format 10 digit, misalnya B000000123
id_member.no			/
id_sponsor.type			--> sama seperti id_member
id_sponsor.no
id_upline.type			--> sama seperti id_member
id_upline.no
profil.kontak.nama
profil.kontak.hp
profil.kontak.email
profil.id.type			--> ('NIK', 'PASPOR')
profil.id.no
profil.tplahir
profil.tglahir
profil.jkel				--> ('L', 'P')
profil.telp
profil.lokasi.alamat
profil.lokasi.wilayah	--> like ke kodekec di tabel wilayah
profil.lokasi.posisi.latitude
profil.lokasi.posisi.longitude
bisnis.npwp
bisnis.bank.nama
bisnis.bank.rek
bisnis.bank.cabang
bisnis.bank.nasabah
bisnis.ahliwaris
bisnis.hubwaris
tipemember				--> link ke tabel tipe, kategori member
tipepaket				--> link ke tabel tipe, kategori paket
tgaktif
status					--> ('ACTIVE', 'DORMANT', 'SUSPENDED', 'BLOCKED')
log.created_by
log.created_at
log.updated_by
log.updated_by
*/

/* === Tabel member_struct === */
create table member_struct (
	id_member memberid primary key,
	tree_kiri integer,
	tree_kanan integer,
	tree_level integer,
	sponsor_kiri integer,
	sponsor_kanan integer,
	sponsor_level integer,
	created_at timestamp
);
comment on table member_struct is 'Struktur jaringan member, baik jaringan biner (st) maupun jaringan sponsorisasi (sp).
Semua downline akan berada di antara titik kiri dan kanan dari member. Ini akan mempercepat dan mempermudah pemrosesan yang mencakup satu group sekaligus.
Isi tabel ini dihitung ulang secara periodik, misalnya setiap 5 menit sekali menggunakan tabel temporary yang setelah selsai diproses akan direplace ke sini.';

/* === Tabel permissions === */
create table permissions (
	id serial primary key,
	name varchar,
	guard_name varchar,
	log logfull
);

/* === Tabel roles === */
create table roles (
	id serial primary key,
	name varchar,
	guard_name varchar,
	log logfull
);

/* === Tabel users === */
create table users (
	id serial primary key,
	name varchar,
	guard_name varchar,
	id_member memberid,
	log logfull
);

/* === Tabel role_has_permissions === */
create table role_has_permissions (
	permission_id integer,
	role_id integer,
	created logsimple,
	primary key (permission_id, role_id)
);

/* === Tabel model_has_permissions === */
create table model_has_permissions (
	permission_id integer,
	model_type varchar,
	model_id integer,
	created logsimple,
	primary key (permission_id, model_type, model_id)
);

/* === Tabel model_has_roles === */
create table model_has_roles (
	role_id integer,
	model_type varchar,
	model_id integer,
	created logsimple,
	primary key (role_id, model_type, model_id)
);

/* === Tabel user_has_roles === */
create table user_has_roles (
	role_id integer,
	user_id varchar,
	created logsimple,
	primary key (role_id, user_id)
);

/* === Tabel brgjasa === */
create table brgjasa (
	id_brgjasa varchar(25) primary key,
	brgjasa offeringtype,
	nama varchar(50),
	satuan varchar(10)
);

/* === Tabel harga === */
create table harga (
	id_harga serial primary key,
	id_brgjasa varchar(25),
	pembeli partytype,
	zona varchar(2),
	id_agen integer default 0,
	nominal money,
	status status,
	mulai date,
	sampai date,
	log logfull
);
comment on column harga.id_agen is 'Hanya diisi apabila master stokis atau stokis menetapkan harga khusus yang disetujui oleh perusahaan. Default akan berisi nol. ';

/* === Tabel pin === */
create table pin (
	id_pin serial primary key,
	id_jproduk varchar(25),
	gen_id memberid,
	gen_pin varchar(100),
	status pinstatus,
	log logfull
);

/* === Tabel wilayah === */
create table wilayah(
	id_wil serial primary key,
	kodepro varchar(50),
	kodekab varchar(50),
	kodekec varchar(50),
	kodedes varchar(50),
	pulau varchar(150),
	propinsi varchar(150),
	jeniskab varchar(150),
	kabupaten varchar(150),
	kecamatan varchar(150),
	desakelurahan varchar(150),
	kodepos varchar(10),
	gmap_kab text,
	gmap_kec text,
	gmap_des text,
	zona varchar(2),
	log logfull
);

/* === Tabel agen === */
create table agen (
	id_agen serial primary key,
	id_member memberid,
	status status,
	gudang fixedlocation,
	zona varchar(2),
	log logfull
);

/* === Tabel tacc (tipe account) === */
create table tacc (
	id_tacc integer primary key,
	nama_en varchar(50),
	nama_id varchar(50),
	dc char(1),
	report varchar(25)
);

/* === Tabel coa === */
create table coa (
	id_coa varchar(25) primary key,
	id_tacc integer,
	akun_en varchar(100),
	akun_id varchar(100),
	catatan text
);

/* === Tabel order === */
create table "order" (
	id_order serial primary key,
	waktu timestamp,
	penjual varchar(25),
	pembeli varchar(25),
	product varchar(25),
	qty float,
	tarif money,
	ongkir money,
	konfirmasi orderstate,
	pengiriman orderstate,
	serahterima orderstate,
	pembayaran orderstate,
	selesai orderstate,
	log logfull
);

/* === Tabel transaksi === */
create table transaksi (
	id_tran serial primary key,
	waktu timestamp,
	debit journalitem,
	credit journalitem,
	log logfull
);

insert into tacc values (1,'ASSETS','KEKAYAAN','D','BALANCE SHEET');
insert into tacc values (2,'LIABILITIES','KEWAJIBAN','C','BALANCE SHEET');
insert into tacc values (3,'EQUITY','MODAL','D','BALANCE SHEET');
insert into tacc values (4,'OPERATING REVENUES','PENDAPATAN OPERASIONAL','C','PROFIT/LOSS');
insert into tacc values (5,'COGS','HPP','D','PROFIT/LOSS');
insert into tacc values (6,'OPERATING EXPENSES','BEBAN OPERASIONAL','D','PROFIT/LOSS');
insert into tacc values (7,'NON-OPERATING REVENUES','PENDAPATAN NON-OPERASIONAL','C','PROFIT/LOSS');
insert into tacc values (8,'NON-OPERATING EXPENSES','BEBAN NON-OPERASIONAL','D','PROFIT/LOSS');
insert into tacc values (9,'ADDITIONAL JOURNAL','JURNAL TAMBAHAN','','');

insert into coa values ('1.01.00',1,'Cash or Bank','Kas atau Bank','');
insert into coa values ('1.02.00',1,'Time Deposits','Deposito Berjangka','');
insert into coa values ('1.03.00',1,'Account Receivables','Piutang Usaha','Nilai yang akan ditagih dari kegiatan usaha');
insert into coa values ('1.04.00',1,'Merchandise Inventory','Persediaan Produk','Nilai dari barang dagangan yang disimpan');
insert into coa values ('1.05.00',1,'Advances','Uang Muka','Biasanya dipegang oleh karyawan atau pihak lain dulu untuk dipertanggungjawabkan kemudian, atau sebagai pengurang dari utang usaha');
insert into coa values ('1.06.00',1,'Accrued / Unearned Revenue','Pendapatan Tertunda','Diakui sebagai pendapatan namun belum ada pembayaran');
insert into coa values ('1.07.00',1,'Prepaid Tax','Pajak Dibayar di Muka','Biaya pajak yang sudah dibayarkan terlebih dulu sebelum akhir periode');
insert into coa values ('1.08.00',1,'Prepaid Expenses','Biaya Dibayar di Muka','Sudah dibayar namun barang atau jasa belum diberikan');
insert into coa values ('1.09.00',1,'Long Term Investment','Investasi Jangka Panjang','Misalnya saham, obligasi, property');
insert into coa values ('1.10.01',1,'Fixed Assets - Land','Kekayaan Tetap - Tanah','');
insert into coa values ('1.10.02',1,'Fixed Assets - Building','Kekayaan Tetap - Bangunan','');
insert into coa values ('1.10.03',1,'Fixed Assets - Vehicle','Kekayaan Tetap - Kendaraan','');
insert into coa values ('1.10.04',1,'Fixed Assets - Equipment','Kekayaan Tetap - Peralatan','');
insert into coa values ('1.11.00',1,'Accumulated Fixed Assets Depreciation','Akumulasi Penyusutan Kekayaan Tetap','Nominal yang dialokasikan untuk biaya penyusutan, dikumpulkan sejak awal');
insert into coa values ('1.12.00',1,'Intangible Assets','Kekayaan Non-Fisik','Contoh: paten, merk, hak cipta, metodologi, franchise');
insert into coa values ('1.13.00',1,'Other Assets','Kekayaan Lain-Lain','Kekayaan yang beragam dan bernilai kecil, biasanya disatukan di sini');
insert into coa values ('2.01.00',2,'Accounts Payable','Utang Usaha','');
insert into coa values ('2.02.00',2,'Advance from Customer','Uang Muka dari Pelanggan','Pembayaran dari pelanggan sebelum barang atau jasa diberikan');
insert into coa values ('2.04.00',2,'Accrued Expenses','Kewajiban yang Masih Berjalan','Kewajiban yang timbul dari pembelanjaan. Barang atau jasa sudah diterima dari supplier atau penyedia jasa, namun belum dilakukan pembayaran');
insert into coa values ('2.05.00',2,'Current Liabilities','Kewajiban Lancar / Jangka Pendek','Kewajiban yang akan dilunasi dalam 1 tahun atau kurang, mis. gaji karyawan, utang usaha, utang bank dll');
insert into coa values ('2.06.00',2,'Long Term Debt','Kewajiban Jangka Panjang','Kewajiban yang akan dilunasi di atas 1 tahun. Misal: cicilan kendaraan');
insert into coa values ('3.01.11',3,'Owners Capital','Modal Usaha','');
insert into coa values ('3.02.01',3,'Retained Earnings','Laba Ditahan','Laba yang tidak dibagikan ke pemilik modal dan digunakan untuk menambah modal usaha');
insert into coa values ('3.02.02',3,'Current Earnings','Laba Bersih','Akumulasi laba dalam satu tahun yang akan dinolkan lagi setiap pergantian tahun');
insert into coa values ('4.01.00',4,'Revenue from the Sale of Goods','Pendapatan Penjualan Produk','');
insert into coa values ('4.02.00',4,'Revenue from the Rendering of Services','Pendapatan Penjualan Jasa','');
insert into coa values ('5.01.00',5,'Cost of Goods Sold','Harga Pokok Penjualan','Seluruh biaya yang dikeluarkan untuk memperoleh produk yang akan dijual');
insert into coa values ('6.01.01',6,'Salaries Expense','Beban Gaji','');
insert into coa values ('6.01.02',6,'Wages Expense','Beban Upah','');
insert into coa values ('6.02.01',6,'Bonus Expense','Beban Bonus Mitra','');
insert into coa values ('6.02.02',6,'Reward Expense','Beban Reward Mitra','');
insert into coa values ('6.03.00',6,'Shipping Expense','Biaya Pengiriman Barang','');
insert into coa values ('6.04.00',6,'Education Expense','Beban Edukasi Mitra','');
insert into coa values ('6.05.00',6,'Promotion Expense','Beban Promosi','');
insert into coa values ('6.06.00',6,'Travel Expense','Beban untuk Perjalanan','');
insert into coa values ('6.07.00',6,'Licensing and Membership','Beban Perizinan dan Keanggotaan','');
insert into coa values ('6.08.00',6,'IT Services Expense','Beban Layanan IT','');
insert into coa values ('6.09.00',6,'Supplies Expense','Beban Barang Habis','');
insert into coa values ('6.10.00',6,'Rent Expense','Beban Sewa','');
insert into coa values ('6.11.01',6,'Utilities Expense','Beban Listrik dan Air','');
insert into coa values ('6.12.02',6,'Telephone Expense','Beban Telepon','');
insert into coa values ('6.12.03',6,'Internet Expense','Beban Internet','');
insert into coa values ('6.13.00',6,'Depreciation Expense','Beban Penyusutan','');
insert into coa values ('7.01.00',7,'Interest Revenues','Pendapatan Bunga','');
insert into coa values ('7.02.00',7,'Gain on Sale of Assets','Keuntungan dari Penjualan Aset','');
insert into coa values ('7.03.00',7,'Currency Gain','Keuntungan Selisih Kurs','');
insert into coa values ('7.04.00',7,'Other Revenues','Pendapatan Lain-Lain','');
insert into coa values ('8.01.00',8,'Interest Expense','Beban Bunga','');
insert into coa values ('8.02.00',8,'Tax on Saving Interest','Pajak dari Bunga Simpanan','');
insert into coa values ('8.03.00',8,'Loss on Sale of Assets','Kerugian dari Penjualan Aset','');
insert into coa values ('8.04.00',8,'Currency Loss','Kerugian Selisih Kurs','');
insert into coa values ('8.05.00',8,'Other Expenses','Beban Lain-Lain','');
insert into coa values ('9.01.00',9,'Correction','Koreksi','Digunakan untuk koreksi atas kesalahan input, stock opname, atau dari perubahan lainnya');
insert into coa values ('9.02.00',9,'Distributor’s Inventory','Inventori Stokis/Master Stokis','Digunakan untuk menghitung inventori produk yang ada di stokis/master stokis. Di sini yang diisi adalah qty (kuantitas) dari produk saja dan bukan nominalnya. Tidak diikutkan dalam perhitungan laporan keuangan perusahaan');
insert into coa values ('9.03.00',9,'Moving Inventory','Inventori dalam Perjalanan','Digunakan untuk menandai inventori produk yang sedang dalam perjalanan perjalanan pengiriman. Ini perlu dicatat karena bisa saja ada pengiriman menggunakan kapal yang membutuhkan waktu beberapa hari. Yang dicatat adalah kuantitasnya saja');