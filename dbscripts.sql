/* === Tabel member === */
drop type gender;
create type gender AS enum ('L', 'P');

drop type personalidtype;
create type personalidtype AS enum ('NIK', 'PASPOR');

drop type memberstatus;
create type memberstatus AS enum ('ACTIVE', 'DORMANT', 'SUSPENDED', 'BLOCKED');

drop type memberid;
create type memberid as (
	type char(1),
	no integer
);
drop function mbid;
create function mbid(memberid) returns varchar as 'select concat($1.type,$1.no)' language sql;

drop type logging;
create type logging as (
	created_by varchar(25),
	created_at timestamp,
	updated_by varchar(25),
	updated_at timestamp
);

drop type geolocation;
create type geolocation as (
	latitude float,
	longitude float
);

drop type fixedlocation;
create type fixedlocation as (
	alamat text,
	wilayah varchar(50),
	posisi geolocation
);

drop type contact;
create type contact as (
	nama varchar(50),
	hp varchar(20),
	email varchar(50)
);

drop type personalid;
create type personalid as (
	type personalidtype,
	no varchar(20)
);

drop type person;
create type person as (
	kontak contact,
	id personalid,
	tplahir varchar(50),
	tglahir date,
	jkel gender,
	telp varchar(20),
	lokasi fixedlocation
);

drop type bank;
create type bank as (
	nama varchar(50),
	rek varchar(30),
	cabang varchar(50),
	nasabah varchar(50)
);

drop type business;
create type business as (
	npwp varchar(20),
	bank bank,
	ahliwaris varchar(50),
	hubwaris varchar(20)
);

drop table member;
create table member (
	id_member memberid primary key,
	id_sponsor memberid,
	id_upline memberid,
	profil person,
	bisnis business,
	tipemember varchar(20),
	tipepaket varchar(20),
	tgaktif timestamp,
	status memberstatus,
	log logging
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
drop table member_struct;
create table member_struct (
	id_member memberid primary key,
	tree_kiri integer,
	tree_kanan integer,
	tree_level integer,
	sponsor_kiri integer,
	sponsor_kanan integer,
	sponsor_level integer,
	create_at timestamp
);
comment on table member_struct is 'Struktur jaringan member, baik jaringan biner (st) maupun jaringan sponsorisasi (sp).
Semua downline akan berada di antara titik kiri dan kanan dari member. Ini akan mempercepat dan mempermudah pemrosesan yang mencakup satu group sekaligus.
Isi tabel ini dihitung ulang secara periodik, misalnya setiap 5 menit sekali menggunakan tabel temporary yang setelah selsai diproses akan direplace ke sini.';

/* === Tabel permissions === */
drop table permissions;
create table permissions (
	id serial primary key,
	name varchar,
	guard_name varchar,
	log logging
);

/* === Tabel roles === */
drop table roles;
create table roles (
	id serial primary key,
	name varchar,
	guard_name varchar,
	log logging
);

/* === Tabel role_has_permissions === */
drop table role_has_permissions;
create table role_has_permissions (
	permission_id integer,
	role_id integer,
	primary key (permission_id, role_id)
);

/* === Tabel model_has_permissions === */
drop table model_has_permissions;
create table model_has_permissions (
	permission_id integer,
	model_type varchar,
	model_id integer,
	primary key (permission_id, model_id, model_type)
);

/* === Tabel model_has_roles === */
drop table model_has_roles;
create table model_has_roles (
	role_id integer,
	model_type varchar,
	model_id integer,
	primary key (role_id, model_id, model_type)
);

/* === Tabel product_type === */
drop table product_type;
create table product_type (
	pt_id varchar(25) primary key,
	pt_name varchar(50)
);

/* === Tabel pin === */
drop table pin;
create table pin (
	pin_id serial primary key,
	pt_id varchar(25),
	generated_id memberid,
	generated_pin varchar(100),
	status varchar(10),
	log logging
);

drop type agentype;
create type agentype as enum ('MASTER STOKIS','STOKIS');

/* === Tabel agen === */
drop table agen;
create table agen (
	id_agen serial primary key,
	id_member memberid,
	tipe_agen agentype,
	status memberstatus,
	gudang fixedlocation,
	zona varchar(2),
	log logging
);

/* === Tabel wilayah === */
drop table wilayah;
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
	log logging
);

/* === Tabel order === */
drop type journalitem;
create type journalitem as (
	acc varchar(25),
	val float,
	rate money,
	party varchar(25)
);

drop type journalstate;
create type journalstate as (
	acc varchar(25),
	waktu timestamp
);

drop table "order";
create table "order" (
	id_order serial primary key,
	waktu timestamp,
	penjual varchar(25),
	pembeli varchar(25),
	product varchar(25),
	qty float,
	rate money,
	ongkir money,
	konfirmasi journalstate,
	pengiriman journalstate,
	serahterima journalstate,
	pembayaran journalstate,
	selesai journalstate,
	log logging
);

/* === Tabel transaksi === */
drop table transaksi;
create table transaksi (
	id_tran serial primary key,
	waktu timestamp,
	debit journalitem,
	credit journalitem,
	log logging
);

/* === Tabel coa_type === */
drop table acc_type;
create table acc_type (
	id integer primary key,
	name varchar(50),
	nama varchar(50),
	dc char(1),
	report varchar(25)
);

/* === Tabel coa === */
drop table coa;
create table coa (
	coa_no varchar(25) primary key,
	acc_type integer,
	account varchar(100),
	akun varchar(100),
	catatan text
);

insert into acc_type values (1,'ASSETS','KEKAYAAN','D','BALANCE SHEET');
insert into acc_type values (2,'LIABILITIES','KEWAJIBAN','C','BALANCE SHEET');
insert into acc_type values (3,'EQUITY','MODAL','D','BALANCE SHEET');
insert into acc_type values (4,'OPERATING REVENUES','PENDAPATAN OPERASIONAL','C','PROFIT/LOSS');
insert into acc_type values (5,'COGS','HPP','D','PROFIT/LOSS');
insert into acc_type values (6,'OPERATING EXPENSES','BEBAN OPERASIONAL','D','PROFIT/LOSS');
insert into acc_type values (7,'NON-OPERATING REVENUES','PENDAPATAN NON-OPERASIONAL','C','PROFIT/LOSS');
insert into acc_type values (8,'NON-OPERATING EXPENSES','BEBAN NON-OPERASIONAL','D','PROFIT/LOSS');
insert into acc_type values (9,'ADDITIONAL JOURNAL','JURNAL TAMBAHAN','','');

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




