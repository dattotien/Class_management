USE quan_li_lop_hoc;
#Query sử dụng inner join
# Trả về các giảng đường có lịch dạy vào thứ 2
SELECT ph.Ma_phong, ph.So_phong, ph.Giang_duong, ph.Suc_chua, lh.Tiet_bat_dau,lh.Tiet_ket_thuc
FROM phong_hoc ph
INNER JOIN lich_hoc lh ON ph.Ma_phong = lh.Ma_phong
WHERE lh.Ngay_hoc = '2'
ORDER BY(Ma_phong);

# Trả về các giảng viên có lớp dạy

SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, lhp.Ma_lhp, lhp.Ten_lhp
FROM giang_vien gv
INNER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien;

# Trả về tất cả các lớp học phần của giảng viên Nguyễn Thị Hậu

SELECT gv.Ma_giang_vien 'Mã giảng viên', concat(gv.hoc_vi,'.',gv.Ho_dem,' ',gv.Ten) 'Giảng viên', 
lhp.Ma_lhp 'Mã LHP', lhp.Ten_lhp 'Tên học phần', lh.Ngay_hoc 'Ngày học', lh.Tiet_bat_dau 'Tiết bắt đầu', 
lh.Tiet_ket_thuc 'Tiết kết thúc', gd.So_phong 'Phòng', gd.Giang_duong 'Giảng đường'
FROM giang_vien gv
INNER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien
INNER JOIN lich_hoc lh ON lhp.Ma_lhp = lh.Ma_lhp
INNER JOIN phong_hoc gd ON gd.Ma_phong= lh.Ma_phong
WHERE gv.Ho_dem = 'Nguyễn Thị' AND gv.Ten = 'Hậu';

# Trả về các trợ giảng có lớp bài tập

SELECT tg.Ma_tro_giang, tg.Ho_dem, tg.Ten, lhp.Ma_lhp, lhp.Ten_lhp
FROM tro_giang tg
INNER JOIN nhom_bai_tap nt ON tg.Ma_tro_giang = nt.Ma_tro_giang
INNER JOIN lop_hoc_phan lhp ON nt.Ma_lhp = lhp.Ma_lhp;

# Truy vấn lịch bài tập và phòng học tương ứng

SELECT 
    lich_bai_tap.Ma_nhom, 
    lich_bai_tap.Ngay_hoc, 
    lich_bai_tap.Tiet_bat_dau, 
    lich_bai_tap.Tiet_ket_thuc, 
    phong_hoc.So_phong, 
    phong_hoc.Giang_duong
FROM lich_bai_tap
INNER JOIN phong_hoc ON lich_bai_tap.Ma_phong = phong_hoc.Ma_phong;

# Truy vấn thông tin lịch học và phòng học

SELECT 
    lich_hoc.Ma_lhp, 
    lich_hoc.Ngay_hoc, 
    lich_hoc.Tiet_bat_dau, 
    lich_hoc.Tiet_ket_thuc, 
    phong_hoc.So_phong, 
    phong_hoc.Suc_chua
FROM lich_hoc
INNER JOIN phong_hoc ON lich_hoc.Ma_phong = phong_hoc.Ma_phong;

# Truy vấn giảng viên và số lượng nhóm bài tập do họ phụ trách

SELECT 
    giang_vien.Ho_dem, 
    giang_vien.Ten, 
    COUNT(nhom_bai_tap.Ma_nhom) AS So_nhom_bai_tap
FROM giang_vien
INNER JOIN lop_hoc_phan 
ON giang_vien.Ma_giang_vien = lop_hoc_phan.Ma_giang_vien
INNER JOIN nhom_bai_tap 
ON lop_hoc_phan.Ma_lhp = nhom_bai_tap.Ma_lhp
GROUP BY giang_vien.Ma_giang_vien, giang_vien.Ho_dem, giang_vien.Ten
ORDER BY So_nhom_bai_tap DESC;

# Truy vấn thông tin lịch học kèm số lượng buổi học trong từng phòng học

SELECT 
    phong_hoc.Ma_phong, 
    phong_hoc.So_phong, 
    COUNT(lich_hoc.Ma_lhp) AS So_buoi_hoc
FROM 
    phong_hoc
INNER JOIN lich_hoc 
ON phong_hoc.Ma_phong = lich_hoc.Ma_phong
GROUP BY phong_hoc.Ma_phong, phong_hoc.So_phong
HAVING COUNT(lich_hoc.Ma_lhp) > 1 -- Chỉ lấy phòng học có hơn 1 buổi học
ORDER BY So_buoi_hoc DESC;

# Truy vấn thông tin phòng học có lịch học vào tiết chẵn và giảng viên có học vị "TS"

SELECT 
    phong_hoc.Ma_phong, 
    lich_hoc.Ngay_hoc, 
    giang_vien.Ho_dem, 
    giang_vien.Ten, 
    giang_vien.Hoc_vi
FROM 
    phong_hoc
INNER JOIN lich_hoc 
ON phong_hoc.Ma_phong = lich_hoc.Ma_phong
INNER JOIN giang_vien 
ON lich_hoc.Ma_giang_vien = giang_vien.Ma_giang_vien
WHERE (lich_hoc.Tiet_bat_dau % 2 = 0) -- Tiết học chẵn 
AND giang_vien.Hoc_vi = 'TS'
ORDER BY lich_hoc.Ngay_hoc, lich_hoc.Tiet_bat_dau;

# Truy vấn theo các điều kiện: Ngày học = Thứ 2 hoặc Thứ 4, tiết bắt đầu từ 3 đến 5, sức chứa phòng học > 50.
SELECT 
    giang_vien.Ho_dem, 
    giang_vien.Ten, 
    phong_hoc.So_phong, 
    phong_hoc.Suc_chua, 
    lich_hoc.Ngay_hoc, 
    lich_hoc.Tiet_bat_dau, 
    lich_hoc.Tiet_ket_thuc
FROM lich_hoc
INNER JOIN giang_vien 
ON lich_hoc.Ma_giang_vien = giang_vien.Ma_giang_vien
INNER JOIN phong_hoc 
ON lich_hoc.Ma_phong = phong_hoc.Ma_phong
WHERE 
    (lich_hoc.Ngay_hoc = '2' OR lich_hoc.Ngay_hoc = '4')
    AND lich_hoc.Tiet_bat_dau BETWEEN 3 AND 5
    AND phong_hoc.Suc_chua > 50
ORDER BY lich_hoc.Ngay_hoc, lich_hoc.Tiet_bat_dau;


#Query sử dụng outer join
#Trả về tất cả các giảng viên, dù có hay không có lớp
SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, lhp.Ma_lhp,lhp.Ten_lhp
FROM giang_vien gv
LEFT JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien;

#Trả về tất cả các trợ giảng, dù có hay không có nhóm bài tập
SELECT tg.Ma_tro_giang, tg.Ho_dem, tg.Ten, lhp.Ma_lhp, lhp.Ten_lhp
FROM tro_giang tg
LEFT JOIN nhom_bai_tap nt ON tg.Ma_tro_giang = nt.Ma_tro_giang
LEFT JOIN lop_hoc_phan lhp ON nt.Ma_lhp = lhp.Ma_lhp;

# Query sử dụng subquery trong WHERE
#Trả về các giảng viên có số lớp dạy trên 3
SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten
FROM giang_vien gv
WHERE gv.Ma_giang_vien IN (
    SELECT lhp.Ma_giang_vien
    FROM lop_hoc_phan lhp
    GROUP BY lhp.Ma_giang_vien
    HAVING COUNT(lhp.Ma_lhp) > 3
);

#Query sử dụng subquery trong from
#Trả về các phòng học còn trống ngày thứ 3 lúc 9h
SELECT ph.Ma_phong, ph.So_phong, ph.Giang_duong, ph.Suc_chua
FROM phong_hoc ph
LEFT JOIN (
    SELECT lh.Ma_phong
    FROM lich_hoc lh
    WHERE lh.Ngay_hoc = '3'  -- Thứ 3
    AND lh.Tiet_bat_dau <= 9
    AND lh.Tiet_ket_thuc >= 9
) AS lich_thu_3 ON ph.Ma_phong = lich_thu_3.Ma_phong
WHERE lich_thu_3.Ma_phong IS NULL;

#Query sử dụng group by và  aggregate functions
#Trả về số lớp học mà giảng viên dạy trong học kỳ
SELECT gv.Ma_giang_vien AS 'Mã giảng viên', concat(gv.Hoc_vi,'.',gv.Ho_dem,' ',gv.Ten) AS 'Giảng viên',COUNT(*) AS 'Số lớp dạy'
FROM lop_hoc_phan lhp
INNER JOIN giang_vien gv ON lhp.Ma_giang_vien = gv.Ma_giang_vien
GROUP BY gv.Ma_giang_vien, gv.Ten;
