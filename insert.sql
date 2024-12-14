USE quan_li_lop_hoc;

INSERT INTO phong_hoc (Ma_phong, So_phong, Giang_duong, Suc_chua) VALUES
('101_G2', '101', 'Giảng đường G2', 80),
('102_G2', '102', 'Giảng đường G2', 80),
('103_G2', '103', 'Giảng đường G2', 60),
('201_G2', '201', 'Giảng đường G2', 80),
('202_G2', '202', 'Giảng đường G2', 80),
('203_G2', '203', 'Giảng đường G2', 60),
('301_GĐ2', '301', 'Giảng đường GĐ2', 80),
('302_GĐ2', '302', 'Giảng đường GĐ2', 80),
('303_GĐ2', '303', 'Giảng đường GĐ2', 60);

INSERT INTO giang_vien (Ma_giang_vien, Ho_dem, Ten, Hoc_vi) VALUES
('GV001', 'Tô Văn', 'Khánh', 'TS'),
('GV002', 'Trần Thu', 'Hà', 'PGS.TS'),
('GV003', 'Nguyễn Thị', 'Hậu', 'TS'),
('GV004', 'Trần Hồng', 'Việt', 'TS'),
('GV005', 'Dư Phương', 'Hạnh', 'TS'),
('GV006', 'Lê Phê', 'Đô', 'TS'),
('GV007', 'Vũ Thị Hồng', 'Nhạn', 'TS');

INSERT INTO tro_giang (Ma_tro_giang, Ho_dem, Ten, Hoc_vi) VALUES
('TG001', 'Kiều Văn', 'Tuyên', 'CN'),
('TG002', 'Phạm Tiến', 'Du', 'CN'),
('TG003', 'Trịnh Ngọc', 'Huỳnh', 'CN'),
('TG004', 'Dương Thị Thanh', 'Hương', 'ThS'),
('TG005', 'Kiều Hải', 'Đăng', 'ThS'),
('TG006', 'Vũ Bá', 'Duy', 'ThS');

INSERT INTO lop_hoc_phan (Ma_lhp, Ten_lhp, Ma_giang_vien) VALUES
('INT2211_1', 'Cơ Sở Dữ Liệu', 'GV004'),
('INT2211_2', 'Cơ Sở Dữ Liệu', 'GV005'),
('INT2211_3', 'Cơ Sở Dữ Liệu', 'GV003'),
('INT2204_1', 'Lập trình hướng đối tượng', 'GV001'),
('INT2204_2', 'Lập trình hướng đối tượng', 'GV003'),
('INT2204_3', 'Lập trình hướng đối tượng', 'GV003'),
('INT2204_4', 'Lập trình hướng đối tượng', 'GV003'),
('INT2204_5', 'Lập trình hướng đối tượng', 'GV007');

INSERT INTO lich_hoc (Ma_lhp, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc, Ma_phong) VALUES
('INT2211_1', '2', 1, 3, '101_G2'),
('INT2211_1', '3', 1, 3, '102_G2'),
('INT2211_1', '4', 1, 3, '103_G2'),
('INT2211_2', '2', 1, 3, '201_G2'),
('INT2211_2', '3', 1, 3, '202_G2'),
('INT2211_3', '2', 2, 4, '203_G2'),
('INT2211_3', '3', 2, 4, '201_G2'),
('INT2204_1', '2', 1, 3, '301_GĐ2'),
('INT2204_1', '3', 1, 3, '302_GĐ2'),
('INT2204_2', '4', 1, 3, '303_GĐ2'),
('INT2204_2', '5', 1, 3, '301_GĐ2'),
('INT2204_3', '2', 9, 10, '201_G2'),
('INT2204_3', '3', 5, 9, '202_G2'),
('INT2204_4', '4', 4, 5, '203_G2'),
('INT2204_4', '5', 4, 6, '102_G2');

INSERT INTO nhom_bai_tap (Ma_nhom, Ma_lhp, Ma_tro_giang) VALUES
('INT2211_1_1', 'INT2211_1', 'TG001'),
('INT2211_1_2', 'INT2211_1', 'TG002'),
('INT2211_1_3', 'INT2211_1', 'TG003'),
('INT2211_2_1', 'INT2211_2', 'TG004'),
('INT2211_2_2', 'INT2211_2', 'TG005'),
('INT2211_3_1', 'INT2211_3', 'TG006'),
('INT2211_3_2', 'INT2211_3', 'TG001'),
('INT2204_1_1', 'INT2204_1', 'TG002'),
('INT2204_1_2', 'INT2204_1', 'TG003'),
('INT2204_2_1', 'INT2204_2', 'TG004'),
('INT2204_2_2', 'INT2204_2', 'TG005'),
('INT2204_3_1', 'INT2204_3', 'TG006');

INSERT INTO lich_bai_tap (Ma_nhom, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc, Ma_phong)
VALUES 
('INT2211_1_1', '2', 3, 5, '101_G2'),
('INT2211_1_2', '3', 3, 5, '102_G2'),
('INT2211_1_3', '4', 5, 7, '103_G2'),
('INT2211_2_1', '2', 5, 7, '201_G2'),
('INT2211_2_2', '3', 3, 5, '202_G2'),
('INT2211_3_1', '2', 1, 2, '203_G2'),
('INT2211_3_2', '3', 1, 2, '201_G2'),
('INT2204_1_1', '2', 5,7, '301_GĐ2'),
('INT2204_1_2', '3', 5, 7, '302_GĐ2'),
('INT2204_2_1', '4', 5, 7, '303_GĐ2'),
('INT2204_2_2', '5', 5, 7, '301_GĐ2'),
('INT2204_3_1', '2', 10, 12, '201_G2');
