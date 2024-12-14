# Lệnh 1: Thêm một giảng viên và lớp học phần mới và hoàn tác
START TRANSACTION;
INSERT INTO giang_vien (Ma_giang_vien, Ho_dem, Ten, Hoc_vi)
VALUES ('GV', 'Tran Ngoc', 'Bich', 'TS');
INSERT INTO lop_hoc_phan (Ma_lhp, Ten_lhp, Ngay_bat_dau, Ngay_ket_thuc, Ma_giang_vien)
VALUES ('AIT1000_1', 'Lập trình Python', '2024-9-16', '2024-12-1', 'GV100');
rollback;

# Lệnh 2: Thêm một trợ giảng và lớp bài tập mới và hoàn tác
START TRANSACTION;
INSERT INTO tro_giang (Ma_tro_giang, Ho_dem, Ten, Hoc_vi)
VALUES ('TG100', 'Le', 'Minh', 'ThS');

INSERT INTO nhom_bai_tap (Ma_nhom, Ma_lhp, Ma_tro_giang, Ngay_bat_dau, Ngay_ket_thuc)
VALUES ('MAT1041_1_4', 'MAT1041_1', 'TG100', '2024-12-16', '2024-12-16');
rollback;

#Lệnh 3: Thêm phòng học và lịch học
START TRANSACTION;
INSERT INTO phong_hoc (Ma_phong, So_phong, Giang_duong, Suc_chua)
VALUES ('401_GĐ4', '401', 'Giảng đường 4', 50);
INSERT INTO lich_hoc (Ma_lhp, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc, Ma_phong)
VALUES ('MAT1041_1', '7', 1, 3, '401_GĐ4');
ROLLBACK;

#Lệnh 4: Điều chỉnh lịch học và hoàn tác
START TRANSACTION;
UPDATE lich_hoc
SET Tiet_bat_dau = 2, Tiet_ket_thuc = 4, Ma_phong = 'P101_G2'
WHERE Ma_lhp = 'INT2211_1' AND Ngay_hoc = '2' AND Ma_phong = 'P101_G2';
ROLLBACK