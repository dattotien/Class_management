# Lệnh 1: Thêm một giảng viên và hoàn tác
START TRANSACTION;
INSERT INTO giang_vien (Ma_giang_vien, Ho_dem, Ten, Hoc_vi)
VALUES ('GV100', 'Tran Ngoc', 'Bich', 'TS');
rollback;

# Lệnh 2: Thêm một trợ giảng và hoàn tác
START TRANSACTION;
INSERT INTO tro_giang (Ma_tro_giang, Ho_dem, Ten, Hoc_vi)
VALUES ('TG100', 'Le', 'Minh', 'ThS');
rollback;

#Lệnh 3: Thêm phòng học và hoàn tác
START TRANSACTION;
INSERT INTO phong_hoc (Ma_phong, So_phong, Giang_duong, Suc_chua)
VALUES ('401_GĐ4', '401', 'Giảng đường 4', 50);
ROLLBACK;

#Lệnh 4: Điều chỉnh lịch học và hoàn tác
START TRANSACTION;
UPDATE lich_hoc
SET Tiet_bat_dau = 2, Tiet_ket_thuc = 4, Ma_phong = 'P101_G2'
WHERE Ma_lhp = 'INT2211_1' AND Ngay_hoc = '2' AND Ma_phong = 'P101_G2';
ROLLBACK;

#Lệnh 5:Di chuyển một lớp học phần sang phòng khác
START TRANSACTION;
UPDATE lich_hoc
SET Ma_phong = '303_GĐ2'
WHERE Ma_lhp = 'INT2204_3' AND Ngay_hoc = '3' AND Tiet_bat_dau = 5 AND Tiet_ket_thuc = 9;
ROLLBACK;

#Lệnh 6: Thêm mới một lớp học phần cùng với lịch học tương ứng
START TRANSACTION;
INSERT INTO lop_hoc_phan (Ma_lhp, Ten_lhp, Ma_giang_vien)
VALUES ('INT2204_6', 'Lập trình hướng đối tượng', 'GV002');

INSERT INTO lich_hoc (Ma_lhp, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc, Ma_phong)
VALUES
    ('INT2204_6', '2', 7, 9, '303_GĐ2'),
    ('INT2204_6', '4', 7, 9, '301_GĐ2');
ROLLBACK;
ROLLBACK;

#Lệnh 7: Thêm mới trợ giảng và phân công lớp bài tập cho trợ giảng mới
START TRANSACTION;
INSERT INTO tro_giang (Ma_tro_giang, Ho_dem, Ten, Hoc_vi)
VALUES ('TG007', 'Nguyễn Phương', 'Linh', 'ThS');
INSERT INTO nhom_bai_tap (Ma_nhom, Ma_lhp, Ma_tro_giang)
VALUES ('INT2204_4_1', 'INT2204_4', 'TG007');
ROLLBACK;
ROLLBACK;
#Lệnh 8: Thêm mới thông tin giảng viên và phân công lớp học phần, lịch học
START TRANSACTION;
INSERT INTO giang_vien (Ma_giang_vien, Ho_dem, Ten, Hoc_vi)
VALUES ('GV008', 'Lê Minh', 'Hiếu', 'PGS.TS');
INSERT INTO lop_hoc_phan (Ma_lhp, Ten_lhp, Ma_giang_vien)
VALUES ('INT3301_1', 'Trí tuệ nhân tạo', 'GV008');
INSERT INTO lich_hoc (Ma_lhp, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc, Ma_phong)
VALUES
    ('INT3301_1', '2', 7, 9, '202_G2'),
    ('INT3301_1', '3', 7, 9, '201_G2');
ROLLBACK;
ROLLBACK;
ROLLBACK;