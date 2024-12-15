USE quan_li_lop_hoc;
ALTER TABLE Phong_hoc
ADD CONSTRAINT CK_Suc_chua CHECK (Suc_chua > 0);

ALTER TABLE Lop_hoc_phan
ADD CONSTRAINT FK_LopHP_GiangVien FOREIGN KEY (Ma_giang_vien) REFERENCES Giang_vien (Ma_giang_vien);

ALTER TABLE Lich_hoc
ADD CONSTRAINT FK_LichHoc_LopHP FOREIGN KEY (Ma_lhp) REFERENCES Lop_hoc_phan (Ma_lhp);

ALTER TABLE Lich_hoc
ADD CONSTRAINT FK_LichHoc_Phong FOREIGN KEY (Ma_phong) REFERENCES Phong_hoc (Ma_phong);

ALTER TABLE Lich_hoc
ADD CONSTRAINT CK_Tiet CHECK (Tiet_bat_dau < Tiet_ket_thuc);

ALTER TABLE Lich_hoc
ADD CONSTRAINT CK_Ngay_hoc CHECK (Ngay_hoc BETWEEN '2' AND '8');

ALTER TABLE Nhom_bai_tap
ADD CONSTRAINT FK_NhomBaiTap_LopHP FOREIGN KEY (Ma_lhp) REFERENCES Lop_hoc_phan (Ma_lhp);

ALTER TABLE Nhom_bai_tap
ADD CONSTRAINT FK_NhomBaiTap_TroGiang FOREIGN KEY (Ma_tro_giang) REFERENCES Tro_giang (Ma_tro_giang);

ALTER TABLE Lich_bai_tap
ADD CONSTRAINT FK_LichBaiTap_Nhom FOREIGN KEY (Ma_nhom) REFERENCES Nhom_bai_tap (Ma_nhom);

ALTER TABLE Lich_bai_tap
ADD CONSTRAINT FK_LichBaiTap_Phong FOREIGN KEY (Ma_phong) REFERENCES Phong_hoc (Ma_phong);

ALTER TABLE Lich_bai_tap
ADD CONSTRAINT CK_LichBaiTap_Tiet CHECK (Tiet_bat_dau < Tiet_ket_thuc);

ALTER TABLE Lich_bai_tap
ADD CONSTRAINT CK_LichBaiTap_Ngay CHECK (Ngay_hoc BETWEEN '2' AND '8');
