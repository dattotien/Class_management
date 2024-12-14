CREATE DATABASE IF NOT EXISTS quan_li_lop_hoc;
USE quan_li_lop_hoc;

CREATE TABLE IF NOT EXISTS giang_vien(
  Ma_giang_vien CHAR(5) NOT NULL,
  Ho_dem VARCHAR(20) NOT NULL,
  Ten VARCHAR(10) NOT NULL,
  Hoc_vi VARCHAR(20) NOT NULL,
  PRIMARY KEY (Ma_giang_vien)
);

CREATE TABLE IF NOT EXISTS lop_hoc_phan (
  Ma_lhp CHAR(10) NOT NULL,
  Ten_lhp TEXT NOT NULL,
  Ma_giang_vien CHAR(5) NOT NULL,
  So_nhom_bai_tap INT NULL DEFAULT 0,
  PRIMARY KEY (Ma_lhp)
);

CREATE TABLE IF NOT EXISTS tro_giang (
  Ma_tro_giang CHAR(5) NOT NULL,
  Ho_dem VARCHAR(20) NOT NULL,
  Ten VARCHAR(10) NOT NULL,
  Hoc_vi VARCHAR(20) NOT NULL,
  PRIMARY KEY (Ma_tro_giang)
);

CREATE TABLE IF NOT EXISTS nhom_bai_tap (
  Ma_nhom CHAR(20) NOT NULL,
  Ma_lhp CHAR(10) NOT NULL,
  Ma_tro_giang CHAR(5) NOT NULL,
  PRIMARY KEY (Ma_nhom)
);

CREATE TABLE IF NOT EXISTS phong_hoc (
  Ma_phong VARCHAR(20) NOT NULL,
  So_phong VARCHAR(6) NOT NULL,
  Giang_duong VARCHAR(20) NOT NULL,
  Suc_chua INT NOT NULL,
  PRIMARY KEY (Ma_phong)
);

CREATE TABLE IF NOT EXISTS lich_bai_tap (
  Ma_nhom CHAR(20) NOT NULL,
  Ma_tro_giang CHAR(5) NOT NULL,
  Ngay_hoc CHAR(1) NOT NULL,
  Tiet_bat_dau INT NOT NULL,
  Tiet_ket_thuc INT NOT NULL,
  Ma_phong VARCHAR(20) NOT NULL,
  PRIMARY KEY (Ma_nhom)
);

CREATE TABLE IF NOT EXISTS lich_hoc (
  Ma_lhp CHAR(10) NOT NULL,
  Ma_giang_vien CHAR(5) NOT NULL,
  Ngay_hoc CHAR(1) NOT NULL,
  Tiet_bat_dau INT NOT NULL,
  Tiet_ket_thuc INT NOT NULL,
  Ma_phong VARCHAR(20) NOT NULL,
  PRIMARY KEY (Ngay_hoc, Tiet_bat_dau,Tiet_ket_thuc, Ma_phong)
);
DROP DATABASE quan_li_lop_hoc;