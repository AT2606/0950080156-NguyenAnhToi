

--------Câu A----	
CREATE TABLE tblChucvu (
  MaCV VARCHAR(2) PRIMARY KEY,
  TenCV NVARCHAR(50) NOT NULL
);

CREATE TABLE tblNhanVien (
  MaNV VARCHAR(10) PRIMARY KEY,
  MaCV VARCHAR(2) NOT NULL,
  TenNV NVARCHAR(50) NOT NULL,
  NgaySinh DATE NOT NULL,
  LuongCanBan DECIMAL(18,2) NOT NULL,
  NgayCong INT NOT NULL,
  PhuCap DECIMAL(18,2) NOT NULL,
  FOREIGN KEY (MaCV) REFERENCES tblChucvu(MaCV)
);

INSERT INTO tblChucvu (MaCV, TenCV)
VALUES ('BV', N'Bảo Vệ'), ('GD', N'Giám Đốc'), ('HC', N'Hành Chính'), ('KT', N'Kế Toán'), ('TQ', N'Thủ Quỹ'), ('VS', N'Vệ Sinh');

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES 
  ('NV01', 'GD', N'Nguyễn Văn An', '1977-12-12', 700000, 25, 500000),
  ('NV02', 'BV', N'Bùi Văn Tí', '1978-10-10', 400000, 24, 100000),
  ('NV03', 'KT', N'Trần Thanh Nhật', '1977-09-09', 600000, 26, 400000),
  ('NV04', 'VS', N'Nguyễn Thị Út', '1980-10-10', 300000, 26, 300000),
  ('NV05', 'HC', N'Lê Thị Hà', '1979-10-10', 500000, 27, 200000);
  SELECT *from tblChucvu
  SELECT *from tblNhanVien


--Yeu Cau:
--Cau a
GO
CREATE PROCEDURE SP_Them_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
    VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap);
    SELECT N'Thêm nhân viên thành công.' AS 'Thông báo';
  END
  ELSE
  BEGIN
    SELECT N'Không thể thêm nhân viên.' AS 'Thông báo';
  END
END
GO
--b
GO
CREATE PROCEDURE SP_CapNhat_Nhan_Vien 
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV VARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan DECIMAL(18,2),
  @NgayCong INT,
  @PhuCap DECIMAL(18,2)
AS
BEGIN
  IF EXISTS (SELECT * FROM tblChucvu WHERE MaCV = @MaCV) AND DATEDIFF(YEAR, @NgaySinh, GETDATE()) <= 30
  BEGIN
    UPDATE tblNhanVien
    SET MaCV = @MaCV, TenNV = @TenNV, NgaySinh = @NgaySinh, LuongCanBan = @LuongCanBan, NgayCong = @NgayCong, PhuCap = @PhuCap
    WHERE MaNV = @MaNV;
    SELECT 'Cập nhật nhân viên thành công.' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT 'Không thể cập nhật nhân viên.' AS ThongBao;
  END
END
GO
--c
GO
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT MaNV, TenNV, LuongCanBan*NgayCong+PhuCap AS Luong
  FROM tblNhanVien;
END
GO

--d
GO
CREATE FUNCTION TBL_LuongTB()
RETURNS TABLE 
AS
RETURN
(
  SELECT tblNhanVien.MaNV, tblNhanVien.TenNV, tblChucvu.TenCV, tblNhanVien.LuongCanBan*CASE
  WHEN NgayCong >= 25 THEN NgayCong*2 ELSE NgayCong END + PhuCap AS Luong
  FROM tblNhanVien
  INNER JOIN tblChucvu ON tblNhanVien.MaCV = tblChucvu.MaCV
  GROUP BY tblNhanVien.MaNV, tblNhanVien.TenNV, tblChucvu.TenCV, tblNhanVien.LuongCanBan, tblNhanVien.NgayCong, tblNhanVien.PhuCap
)
GO

--1
CREATE PROCEDURE SP_ThemNhanVien1
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhuCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM tblChucvu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM tblNhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhuCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END


--2
Go
CREATE PROCEDURE SP_ThemNhanVien2
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhuCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM tblChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM tblNhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
     INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhuCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END
Go
--3
CREATE PROCEDURE SP_CapNhatNgaySinh
  @MaNV VARCHAR(10),
  @NgaySinh DATE
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM tblNhanVien WHERE MaNV = @MaNV;
  IF @Count = 0
  BEGIN
    SELECT 'Không tìm thấy bản ghi cần cập nhật' AS ThongBao;
  END
  ELSE
  BEGIN
    UPDATE tblNhanVien SET NgaySinh = @NgaySinh WHERE MaNV = @MaNV;
    SELECT 'Cập nhật thành công' AS ThongBao;
  END
END



--4
Go
CREATE PROCEDURE SP_TongSoNhanVienTheoNgayCong
  @NgayCong1 INT,
  @NgayCong2 INT
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM tblNhanVien
  WHERE NgayCong BETWEEN @NgayCong1 AND @NgayCong2;
END
Go
--5
Go
CREATE PROCEDURE SP_TongSoNhanVienTheoChucVu
  @TenCV NVARCHAR(50)
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM tblNhanVien
  WHERE MaCV IN (SELECT MaCV FROM tblChucVu WHERE TenCV = @TenCV);
END
Go