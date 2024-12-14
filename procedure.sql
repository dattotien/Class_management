#--------------------------------------------------
# 1. Procedure cập nhập lịch học
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
\# 2. Xem danh sách lớp học phần và lịch dạy của một giảng viên
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

# 2.  Xem danh sách lớp học phần và lịch dạy của trợ giảng
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

