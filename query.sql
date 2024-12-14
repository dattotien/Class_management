USE quan_li_lop_hoc;
#--------------------------------------------------------------------------------------------------
#Query sử dụng inner join
# 1. Trả về các giảng đường có lịch dạy vào thứ 2
    SELECT ph.Ma_phong, ph.So_phong, ph.Giang_duong, ph.Suc_chua, lh.Tiet_bat_dau,lh.Tiet_ket_thuc
    FROM phong_hoc ph
    INNER JOIN lich_hoc lh ON ph.Ma_phong = lh.Ma_phong
    WHERE lh.Ngay_hoc = '2'
    ORDER BY(Ma_phong);

# 2. Trả về các giảng viên có lớp dạy
    SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, lhp.Ma_lhp, lhp.Ten_lhp
    FROM giang_vien gv
    INNER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien;

# 3. Trả về tất cả các lớp học phần của giảng viên Nguyễn Thị Hậu
    SELECT gv.Ma_giang_vien 'Mã giảng viên', concat(gv.hoc_vi,'.',gv.Ho_dem,' ',gv.Ten) 'Giảng viên',
    lhp.Ma_lhp 'Mã LHP', lhp.Ten_lhp 'Tên học phần', lh.Ngay_hoc 'Ngày học', lh.Tiet_bat_dau 'Tiết bắt đầu',
    lh.Tiet_ket_thuc 'Tiết kết thúc', gd.So_phong 'Phòng', gd.Giang_duong 'Giảng đường'
    FROM giang_vien gv
    INNER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien
    INNER JOIN lich_hoc lh ON lhp.Ma_lhp = lh.Ma_lhp
    INNER JOIN phong_hoc gd ON gd.Ma_phong= lh.Ma_phong
    WHERE gv.Ho_dem = 'Nguyễn Thị' AND gv.Ten = 'Hậu';

# 4. Trả về các trợ giảng có lớp bài tập
    SELECT tg.Ma_tro_giang, tg.Ho_dem, tg.Ten, lhp.Ma_lhp,nt.Ma_nhom, lhp.Ten_lhp
    FROM tro_giang tg
    INNER JOIN nhom_bai_tap nt ON tg.Ma_tro_giang = nt.Ma_tro_giang
    INNER JOIN lop_hoc_phan lhp ON nt.Ma_lhp = lhp.Ma_lhp
    ORDER BY tg.Ma_tro_giang;

# 5. Truy vấn lịch bài tập và phòng học tương ứng
    SELECT
        lich_bai_tap.Ma_nhom,
        lich_bai_tap.Ngay_hoc,
        lich_bai_tap.Tiet_bat_dau,
        lich_bai_tap.Tiet_ket_thuc,
        phong_hoc.So_phong,
        phong_hoc.Giang_duong
    FROM lich_bai_tap
    INNER JOIN phong_hoc ON lich_bai_tap.Ma_phong = phong_hoc.Ma_phong;

# 6. Truy vấn thông tin lịch học và phòng học
    SELECT
        lich_hoc.Ma_lhp,
        lich_hoc.Ngay_hoc,
        lich_hoc.Tiet_bat_dau,
        lich_hoc.Tiet_ket_thuc,
        phong_hoc.So_phong,
        phong_hoc.Giang_duong,
        phong_hoc.Suc_chua
    FROM lich_hoc
    INNER JOIN phong_hoc ON lich_hoc.Ma_phong = phong_hoc.Ma_phong;


# 7.Truy vấn thông tin phòng học có lịch học vào tiết chẵn và giảng viên có học vị "TS"
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
    WHERE (lich_hoc.Tiet_bat_dau % 2 = 0)
    AND giang_vien.Hoc_vi = 'TS'
    ORDER BY lich_hoc.Ngay_hoc, lich_hoc.Tiet_bat_dau;

# 8.Truy vấn theo các điều kiện: Ngày học = Thứ 2 hoặc Thứ 4, tiết bắt đầu từ 3 đến 5, sức chứa phòng học > 50.
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

# 9. Liệt kê danh sách các lớp học phần cùng với tên giảng viên phụ trách:
    SELECT lhp.Ma_lhp,lhp.Ten_lhp, concat(gv.Ho_dem,' ', gv.Ten) 'Tên giảng vien'
    FROM lop_hoc_phan lhp
    INNER JOIN giang_vien gv ON lhp.Ma_giang_vien = gv.Ma_giang_vien;

#10. Liệt kê các nhóm bài tập cùng với tên lớp học phần và tên trợ giảng:
    SELECT nbt.Ma_nhom, lhp.Ten_lhp, tg.Ho_dem, tg.Ten
    FROM nhom_bai_tap nbt
             INNER JOIN lop_hoc_phan lhp ON nbt.Ma_lhp = lhp.Ma_lhp
             INNER JOIN tro_giang tg ON nbt.Ma_tro_giang = tg.Ma_tro_giang;
#--------------------------------------------------------------------------------------------------
#Query sử dụng outer join
# 1. Trả về tất cả các giảng viên, dù có hay không có lớp
    SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, lhp.Ma_lhp,lhp.Ten_lhp
    FROM giang_vien gv
    LEFT JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien;

# 2. Trả về tất cả các trợ giảng, dù có hay không có nhóm bài tập
    SELECT tg.Ma_tro_giang, tg.Ho_dem, tg.Ten, nt.Ma_nhom, lhp.Ten_lhp
    FROM tro_giang tg
    LEFT JOIN nhom_bai_tap nt ON tg.Ma_tro_giang = nt.Ma_tro_giang
    LEFT JOIN lop_hoc_phan lhp ON nt.Ma_lhp = lhp.Ma_lhp;

# 3. Liệt kê tất cả các phòng học và lịch học trong phòng đó (kể cả phòng không có lịch học):
    SELECT p.giang_duong,p.So_phong, lh.Ngay_hoc, lh.Tiet_bat_dau, lh.Tiet_ket_thuc
    FROM phong_hoc p
             LEFT OUTER JOIN lich_hoc lh ON p.Ma_phong = lh.Ma_phong
    ORDER BY p.So_phong, lh.Ngay_hoc, lh.Tiet_bat_dau;

-- 4. Liệt kê tất cả các lớp học phần và lịch bài tập của các nhóm (kể cả lớp không có lịch bài tập):
    SELECT lhp.Ma_lhp,lhp.Ten_lhp,lbt.Ma_nhom, lbt.Ngay_hoc, lbt.Tiet_bat_dau, lbt.Tiet_ket_thuc
    FROM lop_hoc_phan lhp
             LEFT OUTER JOIN nhom_bai_tap nbt ON lhp.Ma_lhp = nbt.Ma_lhp
             LEFT OUTER JOIN lich_bai_tap lbt ON nbt.Ma_nhom = lbt.Ma_nhom;

# 5. Liệt kê tất cả các giảng viên và số lượng lớp học phần mà họ phụ trách (kể cả giảng viên không phụ trách lớp nào):
    SELECT gv.Ho_dem, gv.Ten, COUNT(lhp.Ma_lhp) AS So_luong_lop
    FROM giang_vien gv
             LEFT OUTER JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien
    GROUP BY gv.Ma_giang_vien, gv.Ho_dem, gv.Ten;
#--------------------------------------------------------------------------------------------------
# Query sử dụng subquery trong WHERE
# 1. Trả về các giảng viên có số lớp dạy trên 3
    SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten
    FROM giang_vien gv
    WHERE gv.Ma_giang_vien IN (
        SELECT lhp.Ma_giang_vien
        FROM lop_hoc_phan lhp
        GROUP BY lhp.Ma_giang_vien
        HAVING COUNT(lhp.Ma_lhp) > 3
    );

-- 2. Liệt kê các lớp học phần có giảng viên tên là 'Tô Văn Khánh':
    SELECT Ma_lhp,Ten_lhp
    FROM lop_hoc_phan
    WHERE Ma_giang_vien IN (SELECT Ma_giang_vien FROM giang_vien WHERE Ho_dem = 'Tô Văn' AND Ten = 'Khánh');

-- 3. Liệt kê lịch học của các lớp học phần có tên là 'Cơ sở dữ liệu':
    SELECT *
    FROM lich_hoc
    WHERE Ma_lhp IN (SELECT Ma_lhp FROM lop_hoc_phan WHERE Ten_lhp = 'Cơ sở dữ liệu');

-- 4. Liệt kê các trợ giảng phụ trách nhóm bài tập có lịch học vào thứ 2:
    SELECT tg.Ho_dem, tg.Ten
    FROM tro_giang tg
    WHERE tg.Ma_tro_giang IN (SELECT nbt.Ma_tro_giang FROM nhom_bai_tap nbt WHERE nbt.Ma_nhom IN (SELECT lbt.Ma_nhom FROM
    lich_bai_tap lbt WHERE lbt.Ngay_hoc = '2'));
-- 5.Tìm các lớp học phần không có lịch học vào thứ 2
    SELECT Ma_lhp, Ten_lhp
    FROM lop_hoc_phan
    WHERE Ma_lhp NOT IN (
        SELECT lh.Ma_lhp
        FROM lich_hoc lh
        WHERE lh.Ngay_hoc = '2'
    );
#--------------------------------------------------------------------------------------------------
#Query sử dụng subquery trong from
# 1. Trả về các phòng học còn trống ngày thứ 3 lúc 9h
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

-- 2. Liệt kê tên giảng viên và số giờ dạy của mỗi giảng viên:
    SELECT gv.Ho_dem, gv.Ten, lh.Tong_gio_day
    FROM giang_vien gv
             INNER JOIN (SELECT Ma_giang_vien, SUM(Tiet_ket_thuc - Tiet_bat_dau + 1) AS Tong_gio_day FROM lich_hoc GROUP BY Ma_giang_vien) AS lh
                        ON gv.Ma_giang_vien = lh.Ma_giang_vien;
-- 3. Liệt kê tên phòng học và số lần được sử dụng trong lịch học:
    SELECT
        p.Ma_phong,
        p.Giang_duong,
        p.So_phong,
        COALESCE(lh.So_lan_su_dung, 0) + COALESCE(lbt.So_lan_su_dung, 0) AS Tong_so_lan_su_dung
    FROM
        phong_hoc p
        LEFT JOIN
        (SELECT Ma_phong, COUNT(*) AS So_lan_su_dung
         FROM lich_hoc
         GROUP BY Ma_phong) AS lh ON p.Ma_phong = lh.Ma_phong
        LEFT JOIN
        (SELECT Ma_phong, COUNT(*) AS So_lan_su_dung
         FROM lich_bai_tap
         GROUP BY Ma_phong) AS lbt ON p.Ma_phong = lbt.Ma_phong
    ORDER BY Tong_so_lan_su_dung DESC;
-- 4. Liệt kê tên trợ giảng và số nhóm bài tập mà họ phụ trách:
    SELECT tg.Ho_dem, tg.Ten, nbt.So_nhom
    FROM tro_giang tg
             INNER JOIN (SELECT Ma_tro_giang, COUNT(*) AS So_nhom FROM nhom_bai_tap GROUP BY Ma_tro_giang) AS nbt
                        ON tg.Ma_tro_giang = nbt.Ma_tro_giang;
#--------------------------------------------------------------------------------------------------
#Query sử dụng group by và  aggregate functions
# 1. Trả về số lớp học mà giảng viên dạy trong học kỳ
    SELECT gv.Ma_giang_vien AS 'Mã giảng viên', concat(gv.Hoc_vi,'.',gv.Ho_dem,' ',gv.Ten) AS 'Giảng viên',COUNT(*) AS 'Số lớp dạy'
    FROM lop_hoc_phan lhp
    INNER JOIN giang_vien gv ON lhp.Ma_giang_vien = gv.Ma_giang_vien
    GROUP BY gv.Ma_giang_vien, gv.Ten;

# 2. Truy vấn thông tin lịch học kèm số lượng buổi học trong từng phòng học
    SELECT
        lh.Ma_phong AS 'Mã phòng',
        ph.Giang_duong AS 'Giảng đường',
        COUNT(*) AS 'Số lượng buổi học',
        GROUP_CONCAT(DISTINCT lh.Ma_lhp ORDER BY lh.Ma_lhp SEPARATOR ', ') AS 'Danh sách lớp học phần'
    FROM lich_hoc lh
             INNER JOIN phong_hoc ph ON lh.Ma_phong = ph.Ma_phong
    GROUP BY lh.Ma_phong, ph.Giang_duong
    ORDER BY 'Số lượng buổi học' DESC;

# 3. Liệt kê các lớp học phần có số nhóm bài tập lớn hơn 1:
    SELECT lhp.Ma_lhp,lhp.Ten_lhp, lhp.So_nhom_bai_tap
    FROM lop_hoc_phan lhp
             INNER JOIN nhom_bai_tap nbt ON lhp.Ma_lhp = nbt.Ma_lhp
    GROUP BY lhp.Ma_lhp, lhp.Ten_lhp, lhp.So_nhom_bai_tap
    HAVING COUNT(nbt.Ma_nhom) > 1;
# 4. Đếm số lượng lịch học cho mỗi ngày
SELECT lh.Ngay_hoc, COUNT(*) AS So_luong_lich_hoc
FROM (SELECT Ngay_hoc FROM lich_hoc UNION ALL SELECT Ngay_hoc FROM lich_bai_tap) AS lh
GROUP BY lh.Ngay_hoc;

# 5. Đếm số lượng lớp học phần mà mỗi giảng viên phụ trách
SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, COUNT(lhp.Ma_lhp) AS So_luong_lop
FROM giang_vien gv LEFT JOIN lop_hoc_phan lhp ON gv.Ma_giang_vien = lhp.Ma_giang_vien
GROUP BY gv.Ma_giang_vien, gv.Ho_dem, gv.Ten;

# 6. Tính trung bình số nhóm bài tập cho mỗi lớp học phần
SELECT lhp.Ten_lhp, AVG(lhp.So_nhom_bai_tap) AS Trung_binh_so_nhom
FROM lop_hoc_phan lhp
GROUP BY lhp.Ten_lhp;

# 7. Tìm phòng học có sức chứa lớn nhất
SELECT Ma_phong, So_phong, Suc_chua
FROM phong_hoc
WHERE Suc_chua = (SELECT MAX(Suc_chua) FROM phong_hoc);

# 8. Tìm trợ giảng phụ trách nhiều nhóm bài tập nhất
SELECT tg.Ma_tro_giang, tg.Ho_dem, tg.Ten, COUNT(nbt.Ma_nhom) AS So_nhom_phu_trach
FROM tro_giang tg LEFT JOIN nhom_bai_tap nbt ON tg.Ma_tro_giang = nbt.Ma_tro_giang
GROUP BY tg.Ma_tro_giang, tg.Ho_dem, tg.Ten
ORDER BY So_nhom_phu_trach DESC
LIMIT 1;

# 9. Tính tổng số giờ học của mỗi giảng viên
SELECT gv.Ma_giang_vien, gv.Ho_dem, gv.Ten, SUM(lh.Tiet_ket_thuc - lh.Tiet_bat_dau + 1) AS Tong_gio_day
FROM giang_vien gv LEFT JOIN lich_hoc lh ON gv.Ma_giang_vien = lh.Ma_giang_vien
GROUP BY gv.Ma_giang_vien, gv.Ho_dem, gv.Ten;

#10. Tính số lượng lớp học phần và số lượng trợ giảng cho mỗi môn học
SELECT lhp.Ten_lhp, COUNT(DISTINCT lhp.Ma_lhp) AS So_lop_hoc_phan, COUNT(DISTINCT nbt.Ma_tro_giang) AS So_tro_giang
FROM lop_hoc_phan lhp
         LEFT JOIN nhom_bai_tap nbt ON lhp.Ma_lhp = nbt.Ma_lhp
GROUP BY lhp.Ten_lhp;

