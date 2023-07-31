create database QLSVNC;
use QlSVNC;

create table dmMakhoa(
	MaKhoa varchar(20) primary key,
    TenKhoa varchar(255)
);

create table dmnganh(
	MaNganh int primary key,
    TenNanganh varchar(255),
    MaKhoa varchar(20),
    foreign key(MaKhoa) references dmMaKhoa(MaKhoa)
);

create table dmhocphan(
	MaHP int primary key,
    TenHP varchar(255),
    Sohvht int,
    MaNganh int,
    Hocky int,
    foreign key(MaNganh) references dmnganh(MaNganh)
);

create table dmlop(
	MaLop varchar(20) primary key,
    TenLop varchar(255),
    MaNganh int,
    KhoaHoc int,
    HeDT varchar(255),
    NamNhapHoc int,
    foreign key(MaNganh) references dmnganh(MaNganh)
);

create table sinhvien(
	MaSv int primary key,
    HoTen varchar(255),
    MaLop varchar(20),
    Gioitinh tinyint(1),
    NgaySinh date,
    DiaChi varchar(255),
    foreign key(MaLop) references dmlop(MaLop)
);

create table diemhp(
MaSV int ,
MaHP int ,
foreign key (MaSV) references sinhvien(MaSV),
foreign key (MaHP) references dmhocphan(MaHP),
DiemHp float
);

INSERT INTO dmMakhoa (MaKhoa, TenKhoa)
VALUES
    ('CNTT', 'Công nghệ thông tin'),
    ('KT', 'Kế Toán'),
    ('SP', 'Sư phạm');

INSERT INTO dmnganh (MaNganh, TenNanganh, MaKhoa)
VALUES
    (140902, 'Sư phạm toán tin', 'SP'),
    (480202, 'Tin học ứng dụng','CNTT');

INSERT INTO dmlop (MaLop, TenLop, MaNganh, KhoaHoc, HeDT, NamNhapHoc)
VALUES
    ('CT11', 'Cao đẳng tin học', '480202', 11, 'TC', 2013),
    ('CT12', 'Cao đẳng tin học', '480202', 12, 'CĐ', 2013),
    ('CT13', 'Cao đẳng tin học', '480202', 13, 'TC', 2014);

INSERT INTO dmhocphan (MaHP, TenHP, Sohvht, MaNganh, Hocky)
VALUES
    (1, 'Toán cấp cấp A1', 4, '480202', 1),
    (2, 'Tiếng Anh 1', 3, '480202', 1),
    (3, 'Vật lý đại cương', 4, '480202', 1),
    (4, 'Tiếng Anh 2', 7, '480202', 1),
    (5, 'Tiếng Anh 1', 3, '140902', 2),
    (6, 'Xác suất thống kê', 3, '480202', 2);

INSERT INTO sinhvien (MaSV, HoTen, MaLop, Gioitinh, NgaySinh, DiaChi)
VALUES
    (1, 'Phan Thanh', 'CT12', 0, '1990-09-12', 'Tuy Phước'),
    (2, 'Nguyễn Thị Cẩm', 'CT12', 1, '1994-01-12', 'Quy Nhơn'),
    (3, 'Võ Thị Hà', 'CT12', 1, '1995-07-02', 'An Nhơn'),
    (4, 'Trần Hoài Nam', 'CT12', 0, '1994-04-05', 'Tây Sơn'),
    (5, 'Trần Văn Hoàng', 'CT13', 0, '1995-08-04', 'Vĩnh Thạnh'),
    (6, 'Đặng Thị Thảo', 'CT13', 1, '1995-06-12', 'Quy Nhơn'),
    (7, 'Lê Thị Sen', 'CT13', 1, '1994-08-12', 'Phù Mỹ'),
    (8, 'Nguyễn Văn Huy', 'CT11', 0, '1995-06-04', 'Tuy Phước'),
    (9, 'Trần Thị Hoa', 'CT11', 1, '1994-08-09', 'Hoài Nhơn');

insert into diemhp(MaSV,MaHP,DiemHp)values
(2,3,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4),
(7,1,6.2);


-- 1
SELECT HoTen
FROM sinhvien
WHERE MaSV NOT IN (SELECT MaSV FROM diemhp);

-- 2
SELECT sv.HoTen
FROM sinhvien sv
WHERE NOT EXISTS (SELECT 1 FROM diemhp dh WHERE sv.MaSV = dh.MaSV AND dh.MaHP = 1);

-- 3
SELECT TenHP AS TenHocPhan
FROM dmhocphan
WHERE MaHP NOT IN (SELECT MaHP FROM diemhp WHERE DiemHp < 5);

-- 4
SELECT HoTen
FROM sinhvien
WHERE MaSV NOT IN (SELECT MaSV FROM diemhp WHERE DiemHp < 5);

-- 5
SELECT DISTINCT lp.TenLop
FROM dmlop lp
WHERE lp.MaLop IN (SELECT MaLop FROM sinhvien WHERE HoTen LIKE '%Hoa%');

-- 6
SELECT sv.HoTen
FROM sinhvien sv
WHERE sv.MaSV IN (SELECT MaSV FROM diemhp WHERE MaHP = 1 AND DiemHp < 5);

-- 7
SELECT TenHP
FROM dmhocphan
WHERE Sohvht >= (SELECT Sohvht FROM dmhocphan WHERE MaHP = 1);

-- 8
SELECT sv.HoTen, dh.MaHP, dh.DiemHP
FROM sinhvien sv
JOIN diemhp dh ON sv.MaSV = dh.MaSV
WHERE dh.DiemHP = (SELECT MAX(DiemHP) FROM diemhp);

-- 9
SELECT sv.MaSV, sv.HoTen
FROM sinhvien sv
JOIN (SELECT MaSV FROM diemhp WHERE MaHP = 1 ORDER BY DiemHP DESC LIMIT 1) dh ON sv.MaSV = dh.MaSV;

-- 10
SELECT MaSV, MaHP
FROM diemhp
WHERE DiemHp > ANY (SELECT DiemHp FROM diemhp WHERE MaSV = 3);

-- 11
SELECT MaSV, HoTen
FROM sinhvien
WHERE EXISTS (SELECT 1 FROM diemhp WHERE diemhp.MaSV = sinhvien.MaSV);

-- 12
SELECT MaSV, HoTen
FROM sinhvien
WHERE NOT EXISTS (SELECT 1 FROM diemhp WHERE diemhp.MaSV = sinhvien.MaSV);

-- 13
SELECT DISTINCT MaSV
FROM diemhp
WHERE MaHP IN (1, 2);

-- 14
DELIMITER //
CREATE PROCEDURE KIEM_TRA_LOP(IN MaLopParam VARCHAR(20))
BEGIN
    DECLARE MaLopExists INT;
    SELECT COUNT(*) INTO MaLopExists FROM dmlop WHERE MaLop = MaLopParam;
    IF MaLopExists = 0 THEN
        SELECT 'Lớp này không có trong danh mục' AS Result;
    ELSE
        SELECT sv.HoTen
        FROM sinhvien sv
        WHERE sv.MaLop = MaLopParam
        AND sv.MaSV NOT IN (SELECT MaSV FROM diemhp WHERE DiemHp < 5);
    END IF;
END //
DELIMITER ;
CALL KIEM_TRA_LOP('CT12');

-- 15
DELIMITER //
CREATE TRIGGER tr_check_MaSV_not_empty
BEFORE INSERT ON sinhvien
FOR EACH ROW
BEGIN
    IF NEW.MaSV IS NULL OR NEW.MaSV = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mã sinh viên phải được nhập';
    END IF;
END //
DELIMITER ;

-- 16
DELIMITER //
CREATE TRIGGER tr_update_SiSo
AFTER INSERT ON sinhvien
FOR EACH ROW
BEGIN
    UPDATE dmlop
    SET SiSo = SiSo + 1
    WHERE MaLop = NEW.MaLop;
END //
DELIMITER ;

-- 17
DELIMITER //
CREATE FUNCTION DOC_DIEM(DiemHP FLOAT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE DiemChu VARCHAR(255);
    CASE
        WHEN DiemHP >= 9.5 THEN SET DiemChu = 'A+';
        WHEN DiemHP >= 8.5 THEN SET DiemChu = 'A';
        WHEN DiemHP >= 7.5 THEN SET DiemChu = 'B+';
        WHEN DiemHP >= 6.5 THEN SET DiemChu = 'B';
        WHEN DiemHP >= 5.5 THEN SET DiemChu = 'C+';
        WHEN DiemHP >= 4.5 THEN SET DiemChu = 'C';
        WHEN DiemHP >= 3.5 THEN SET DiemChu = 'D+';
        WHEN DiemHP >= 2.0 THEN SET DiemChu = 'D';
        ELSE SET DiemChu = 'F';
    END CASE;
    RETURN DiemChu;
END //
DELIMITER ;

SELECT sv.MaSV,sv.HoTen,dh.MaHP,dh.DiemHP,DOC_DIEM(dh.DiemHP) AS DiemChu
FROM diemhp dh
JOIN sinhvien sv ON dh.MaSV = sv.MaSV
LIMIT 0, 1000;

-- 18
DELIMITER //
CREATE PROCEDURE HIEN_THI_DIEM(IN threshold FLOAT)
BEGIN
    DECLARE student_count INT;
    SELECT COUNT(*) INTO student_count
    FROM sinhvien sv
    JOIN diemhp dh ON sv.MaSV = dh.MaSV
    WHERE dh.DiemHp < threshold;

    IF student_count > 0 THEN
        SELECT sv.MaSV, sv.HoTen, sv.MaLop, dh.DiemHp, dh.MaHP
        FROM sinhvien sv
        JOIN diemhp dh ON sv.MaSV = dh.MaSV
        WHERE dh.DiemHp < threshold;
    ELSE
        SELECT 'Không có sinh viên nào' AS Message;
    END IF;
END //
DELIMITER ;
CALL HIEN_THI_DIEM(5);

-- 19
DELIMITER //
CREATE PROCEDURE HIEN_THI_MAHP(IN maHP INT)
BEGIN
    DECLARE hphExists INT;
    SELECT COUNT(*) INTO hphExists FROM dmhocphan WHERE MaHP = maHP;
    IF hphExists = 0 THEN
        SELECT 'Không có học phần với mã chỉ định.' AS Message;
    ELSE
        -- Display HoTen sinh viên who have not studied the specified học phần
        SELECT sv.HoTen
        FROM sinhvien sv
        WHERE sv.MaSV NOT IN (SELECT MaSV FROM diemhp WHERE MaHP = maHP);
    END IF;
END //
DELIMITER ;
CALL HIEN_THI_MAHP(1);

-- 20
DELIMITER //
CREATE PROCEDURE HIEN_THI_TUOI(IN TuoiMin INT, IN TuoiMax INT)
BEGIN
    SELECT sv.MaSV, sv.HoTen, sv.MaLop, sv.NgaySinh, sv.Gioitinh,
           TIMESTAMPDIFF(YEAR, sv.NgaySinh, CURDATE()) AS Tuoi
    FROM sinhvien sv
    WHERE TIMESTAMPDIFF(YEAR, sv.NgaySinh, CURDATE()) BETWEEN TuoiMin AND TuoiMax
    UNION
    SELECT NULL, 'Không có sinh viên nào', NULL, NULL, NULL, NULL
    WHERE NOT EXISTS (
        SELECT 1 FROM sinhvien WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) BETWEEN TuoiMin AND TuoiMax
    );
END //
DELIMITER ;
CALL HIEN_THI_TUOI(20, 30);