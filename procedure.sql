#--------------------------------------------------
# 1. Cập nhập lịch học
DELIMITER $$
CREATE PROCEDURE UpdateLichHoc(
    IN p_Ma_lhp CHAR(10),              
    IN p_Ngay_hoc CHAR(1),             
    IN p_Tiet_bat_dau INT,             
    IN p_Tiet_ket_thuc INT,           
    IN p_Ma_phong VARCHAR(20)       
)
BEGIN
    START TRANSACTION;
        UPDATE lich_hoc
        SET Tiet_bat_dau = p_Tiet_bat_dau,
            Tiet_ket_thuc = p_Tiet_ket_thuc,
            Ma_phong = p_Ma_phong
        WHERE Ma_lhp = p_Ma_lhp AND Ngay_hoc = p_Ngay_hoc;
        COMMIT;
END $$
DELIMITER ;
#-------------------------------------------------------------------
# 2. Xem danh sách lớp học phần và lịch dạy của một giảng viên
DELIMITER $$
CREATE PROCEDURE GV (
    IN p_Ma_giang_vien VARCHAR(50)
)
BEGIN
    SELECT concat(gv.hoc_vi, '.', gv.Ho_dem, ' ', gv.Ten) AS 'Giảng viên', 
           lhp.Ma_lhp AS 'Mã LHP', 
           lhp.Ten_lhp AS 'Tên học phần', 
           lh.Ngay_hoc AS 'Ngày học', 
           lh.Tiet_bat_dau AS 'Tiết bắt đầu', 
           lh.Tiet_ket_thuc AS 'Tiết kết thúc', 
           gd.So_phong AS 'Phòng', 
           gd.Giang_duong AS 'Giảng đường'
    FROM giang_vien gv
    INNER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien
    INNER JOIN lich_hoc lh ON lhp.Ma_lhp = lh.Ma_lhp
    INNER JOIN phong_hoc gd ON gd.Ma_phong = lh.Ma_phong
    WHERE gv.Ma_giang_vien = p_Ma_giang_vien
    ORDER BY lh.Ngay_hoc,lh.Tiet_bat_dau;
    END $$
DELIMITER ;
CALL GV('GV004');
#-------------------------------------------------------------------
# 3.  Xem danh sách lớp học phần và lịch dạy của trợ giảng
DELIMITER $$
CREATE PROCEDURE TG (
    IN p_Ma_tro_giang VARCHAR(50)
)
BEGIN
    SELECT concat(tg.hoc_vi, '.', tg.Ho_dem, ' ', tg.Ten) AS 'Trợ giảng', 
           lhp.Ma_lhp AS 'Mã LHP', 
           lhp.Ten_lhp AS 'Tên học phần', 
           nbt.Ma_nhom AS 'Mã nhóm bài tập',
           lbt.Ngay_hoc AS 'Ngày học', 
           lbt.Tiet_bat_dau AS 'Tiết bắt đầu', 
           lbt.Tiet_ket_thuc AS 'Tiết kết thúc', 
           gd.So_phong AS 'Phòng', 
           gd.Giang_duong AS 'Giảng đường'
    FROM tro_giang tg
    INNER JOIN nhom_bai_tap nbt ON tg.Ma_tro_giang = nbt.Ma_tro_giang
    INNER JOIN lop_hoc_phan lhp ON lhp.Ma_lhp=nbt.Ma_lhp
    INNER JOIN lich_bai_tap lbt ON lbt.Ma_nhom=nbt.Ma_nhom
    INNER JOIN phong_hoc gd ON gd.Ma_phong = lbt.Ma_phong
    WHERE tg.Ma_tro_giang = p_Ma_tro_giang
    ORDER BY lbt.Ngay_hoc, lbt.Tiet_bat_dau;
END $$
DELIMITER ;
CALL TG('TG001');
#--------------------------------------------------------------------------------------------------------
# 4. Trả về lịch học lý thuyết, lịch học các nhóm bài tập và giảng viên đảm nhiệm của một lớp học phần.
DELIMITER $$
CREATE PROCEDURE LichHoc(
    IN p_Ma_lhp VARCHAR(50)
)
BEGIN
    (SELECT 'Lý thuyết' AS Loai_lich,
           lh.Ma_lhp AS 'Mã LHP/ Mã nhóm',
           lhp.Ten_lhp AS 'Tên môn học',
           CONCAT(gv.Hoc_vi,'.',gv.Ho_dem,' ',gv.Ten) AS 'Tên giảng viên/ trợ giảng',
           lh.Ngay_hoc AS 'Ngày học',
           lh.Tiet_bat_dau AS 'Tiết bắt đầu',
           lh.Tiet_ket_thuc AS 'Tiết kết thúc',
           ph.So_phong AS 'Phòng',
           ph.Giang_duong AS 'Giảng đường'
    FROM lich_hoc lh
             INNER JOIN phong_hoc ph ON lh.Ma_phong = ph.Ma_phong
             INNER JOIN lop_hoc_phan lhp ON lh.Ma_lhp = lhp.Ma_lhp
             INNER JOIN giang_vien gv ON gv.Ma_giang_vien = lhp.Ma_giang_vien
    WHERE lh.Ma_lhp = p_Ma_lhp ORDER BY lh.Ngay_hoc,lh.Tiet_bat_dau)
    UNION ALL
    (SELECT 'Nhóm thực hành' AS Loai_lich,
           nbt.Ma_nhom AS 'Mã LHP/ Mã nhóm',
           lhp.Ten_lhp AS 'Tên môn học',
           CONCAT(tg.Hoc_vi,'.',tg.Ho_dem,' ',tg.Ten) AS 'Tên giảng viên/ trợ giảng',
           lbt.Ngay_hoc AS 'Ngày học',
           lbt.Tiet_bat_dau AS 'Tiết bắt đầu',
           lbt.Tiet_ket_thuc AS 'Tiết kết thúc',
           ph.So_phong AS 'Phòng',
           ph.Giang_duong AS 'Giảng đường'
    FROM nhom_bai_tap nbt
             INNER JOIN lich_bai_tap lbt ON nbt.Ma_nhom = lbt.Ma_nhom
             INNER JOIN phong_hoc ph ON lbt.Ma_phong = ph.Ma_phong
            INNER JOIN lop_hoc_phan lhp ON lhp.Ma_lhp = nbt.Ma_lhp
            INNER JOIN tro_giang tg ON tg.Ma_tro_giang = nbt.Ma_tro_giang
    WHERE nbt.Ma_lhp = p_Ma_lhp ORDER BY lbt.Ngay_hoc,lbt.Tiet_bat_dau);
END $$
DELIMITER ;
CALL LichHoc('INT2211_1');

#--------------------------------------------------------------------------------------------------------------
# 5. Tra ve cac lich hoc tai mot phong hoc trong ngay
DELIMITER $$
CREATE PROCEDURE PH(
    IN p_Ma_phong VARCHAR(50),
    IN p_Ngay CHAR(1)
)
BEGIN
    SELECT 'Lịch học' AS Loai_lich,
           lh.Ma_lhp AS 'Mã lhp/ nhóm',
           lhp.Ten_lhp AS 'Tên môn học',
           lh.Tiet_bat_dau AS 'Tiết bắt đầu',
           lh.Tiet_ket_thuc AS 'Tiết kết thúc',
           ph.So_phong AS 'Số phòng',
           ph.Giang_duong AS 'Giảng đường'
    FROM lich_hoc lh
             INNER JOIN phong_hoc ph ON lh.Ma_phong = ph.Ma_phong
             INNER JOIN lop_hoc_phan lhp ON lh.Ma_lhp = lhp.Ma_lhp
    WHERE lh.Ma_phong = p_Ma_phong AND lh.Ngay_hoc = p_Ngay

    UNION ALL

    SELECT 'Thuc hành' AS Loai_lich,
           nbt.Ma_nhom AS `Mã lhp/ nhóm`,
           lhp.Ten_lhp AS 'Tên môn học',
           lbt.Tiet_bat_dau AS 'Tiết bắt đầu',
           lbt.Tiet_ket_thuc AS 'Tiết kết thúc',
           ph.So_phong AS 'Số phòng',
           ph.Giang_duong AS 'Giảng đường'
    FROM nhom_bai_tap nbt
             INNER JOIN lich_bai_tap lbt ON nbt.Ma_nhom = lbt.Ma_nhom
             INNER JOIN phong_hoc ph ON lbt.Ma_phong = ph.Ma_phong
             INNER JOIN lop_hoc_phan lhp ON nbt.Ma_lhp = lhp.Ma_lhp
    WHERE lbt.Ma_phong = p_Ma_phong AND lbt.Ngay_hoc = p_Ngay
    ORDER BY `Tiết bắt đầu`;
END $$
DELIMITER ;
CALL PH('101_G2', 2);

#--------------------------------------------------------------------------------------------------------------
