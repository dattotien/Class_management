# --------------------------------------------------------------------
# 1.Tự động cập nhập số lượng nhóm bài tập khi thêm một nhóm bài tập
DELIMITER $$
CREATE TRIGGER trg_update_so_nhom_bt
AFTER INSERT ON nhom_bai_tap
FOR EACH ROW
BEGIN
    UPDATE lop_hoc_phan
    SET So_nhom_bai_tap = So_nhom_bai_tap + 1
    WHERE Ma_lhp = NEW.Ma_lhp;
END $$
DELIMITER ;
#----------------------------------------------------------------------
# 2. Tự động điền mã trợ giảng khi insert lịch bài tập
DELIMITER $$
CREATE TRIGGER auto_insert_ma_tro_giang 
BEFORE INSERT ON lich_bai_tap
FOR EACH ROW
BEGIN
    DECLARE ma_tro_giang CHAR(5);
    SELECT nbt.Ma_tro_giang INTO ma_tro_giang
    FROM nhom_bai_tap nbt
    WHERE nbt.Ma_nhom = NEW.Ma_nhom;
    SET NEW.Ma_tro_giang = ma_tro_giang;
END $$
DELIMITER ;
DELIMITER $$
#-----------------------------------------------------------------------
# 3. Kiểm tra nhóm bài tập đã tồn tại chưa trước khi thêm lịch bài tập
CREATE TRIGGER check_nhom_bai_tap_exists
BEFORE INSERT ON lich_bai_tap
FOR EACH ROW
BEGIN
    DECLARE nhom_exists INT;

    SELECT COUNT(*) INTO nhom_exists
    FROM nhom_bai_tap
    WHERE Ma_nhom = NEW.Ma_nhom;
    IF nhom_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nhóm bài tập không tồn tại!';
    END IF;
END $$

DELIMITER ;
#-----------------------------------------------------------------
# 4. Tự động điền mã giảng viên khi insert lịch học
DELIMITER $$
CREATE TRIGGER auto_insert_ma_giang_vien 
BEFORE INSERT ON lich_hoc
FOR EACH ROW
BEGIN
    DECLARE ma_giang_vien CHAR(5);
    
    SELECT lhp.Ma_giang_vien INTO ma_giang_vien
    FROM lop_hoc_phan lhp
    WHERE lhp.Ma_lhp = NEW.Ma_lhp;
    SET NEW.Ma_giang_vien = ma_giang_vien;
END $$

DELIMITER ;
#-----------------------------------------------------------------
# 5. Kiểm tra lớp học phần đã tồn tại chưa trước khi phân lịch học
DELIMITER $$
CREATE TRIGGER check_lop_hoc_phan_exists
BEFORE INSERT ON lich_hoc
FOR EACH ROW
BEGIN
    DECLARE lop_exists INT;
    SELECT COUNT(*) INTO lop_exists
    FROM lop_hoc_phan
    WHERE Ma_lhp = NEW.Ma_lhp;
    IF lop_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lớp học phần không tồn tại!';
    END IF;
END $$

DELIMITER ;
#-----------------------------------------------------------------
# 6. Kiểm tra trùng lịch giảng viên trước khi insert thêm lịch học
DELIMITER $$
CREATE TRIGGER check_giang_vien_trung_lich 
BEFORE INSERT ON lich_hoc
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM lich_hoc lhp
        WHERE lhp.Ma_giang_vien = NEW.Ma_giang_vien
          AND lhp.Ngay_hoc = NEW.Ngay_hoc
          AND lhp.Tiet_bat_dau < NEW.Tiet_ket_thuc
          AND lhp.Tiet_ket_thuc > NEW.Tiet_bat_dau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lịch dạy giảng viên trùng lịch, không thể thêm lịch học mới!';
    END IF;
END $$

DELIMITER ;
#-----------------------------------------------------------------
# 7. Kiểm tra lịch rảnh của trợ giảng trước khi insert lịch bài tập
DELIMITER $$
CREATE TRIGGER check_tro_giang_trung_lich 
BEFORE INSERT ON lich_bai_tap
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM lich_bai_tap lbt
        WHERE lbt.Ma_tro_giang = NEW.Ma_tro_giang
          AND lbt.Ngay_hoc = NEW.Ngay_hoc
          AND lbt.Tiet_bat_dau < NEW.Tiet_ket_thuc
          AND lbt.Tiet_ket_thuc > NEW.Tiet_bat_dau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lịch trợ giảng bị trùng, không thể thêm lịch bài tập!';
    END IF;
END $$
DELIMITER ;
#-------------------------------------------------------------------------
# 8. Kiểm tra lịch trống của giảng đường trước khi thêm lịch bài tập.
DELIMITER $$
CREATE TRIGGER check_phong_trong_lich_bai_tap
BEFORE INSERT ON lich_bai_tap
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT Ma_phong, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc FROM lich_bai_tap
            UNION ALL
            SELECT Ma_phong, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc FROM lich_hoc
        ) AS lich_su_dung
        WHERE lich_su_dung.Ma_phong = NEW.Ma_phong
          AND lich_su_dung.Ngay_hoc = NEW.Ngay_hoc
          AND lich_su_dung.Tiet_bat_dau < NEW.Tiet_ket_thuc
          AND lich_su_dung.Tiet_ket_thuc > NEW.Tiet_bat_dau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giảng đường đã được sử dụng trong khoảng thời gian này!';
    END IF;
END $$
DELIMITER ;
#----------------------------------------------------------------------
# 9 Kiểm tra lịch trống của giảng đường trước khi thêm lịch học
DELIMITER $$
CREATE TRIGGER check_phong_trong_lich_hoc
BEFORE INSERT ON lich_hoc
FOR EACH ROW
BEGIN
    -- Kiểm tra xem giảng đường có trống không
    IF EXISTS (
        SELECT 1
        FROM (
            SELECT Ma_phong, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc FROM lich_hoc
            UNION ALL
            SELECT Ma_phong, Ngay_hoc, Tiet_bat_dau, Tiet_ket_thuc FROM lich_bai_tap
        ) AS lich_su_dung
        WHERE lich_su_dung.Ma_phong = NEW.Ma_phong
          AND lich_su_dung.Ngay_hoc = NEW.Ngay_hoc
          AND lich_su_dung.Tiet_bat_dau < NEW.Tiet_ket_thuc
          AND lich_su_dung.Tiet_ket_thuc > NEW.Tiet_bat_dau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giảng đường đã được sử dụng trong khoảng thời gian này!';
    END IF;
END $$
DELIMITER ;


