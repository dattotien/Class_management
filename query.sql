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

#Query sử dụng subquery trong WHERE
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
