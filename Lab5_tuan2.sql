
------------Lab5---------

--Cau1--
go
CREATE FUNCTION Cau1 (@masp Nvarchar(100))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @hangsx NVARCHAR(50)
    SELECT @hangsx = Hangsx.tenhang
    FROM Sanpham
    JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
    WHERE Sanpham.masp = @masp

    
    RETURN @hangsx
END
go
go
SELECT dbo.Cau1('SP01')
go
----Cau2-----
go
CREATE FUNCTION Cau2(@x INT, @y INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TongGiaTriNhap MONEY
    SELECT @TongGiaTriNhap = SUM(dongiaN * soluongN)
    FROM Nhap
    WHERE YEAR(ngaynhap) BETWEEN @x AND @y
    RETURN @TongGiaTriNhap
END
go
go
SELECT dbo.Cau2(2017,2020)
go

--Cau 3--
go 
CREATE FUNCTION Cau3 (@tenSanPham nvarchar(50), @nam int)
RETURNS int
AS
BEGIN
    DECLARE @soLuongNhap int, @soLuongXuat int, @soLuongThayDoi int;
    SELECT @soLuongNhap = SUM(soluongN) FROM Nhap n JOIN Sanpham sp ON n.masp = sp.masp WHERE sp.tensp = @tenSanPham AND YEAR(n.ngaynhap) = @nam;
    SELECT @soLuongXuat = SUM(soluongX) FROM Xuat x JOIN Sanpham sp ON x.masp = sp.masp WHERE sp.tensp = @tenSanPham AND YEAR(x.ngayxuat) = @nam;
    SET @soLuongThayDoi = @soLuongNhap - @soLuongXuat;
    RETURN @soLuongThayDoi;
END
go
go
SELECT dbo.Cau3 ('Galaxy V21',2020)
go

--Cau 4--
go
CREATE FUNCTION dbo.Cau4(
    @ngay_bat_dau DATE,
    @ngay_ket_thuc DATE
)
RETURNS MONEY
AS
BEGIN
    DECLARE @tong_gia_tri_nhap MONEY;
    SELECT @tong_gia_tri_nhap = SUM(nhap.soluongN * sanpham.giaban)
    FROM Nhap AS nhap
    INNER JOIN Sanpham AS sanpham ON nhap.masp = sanpham.masp
    WHERE nhap.ngaynhap >= @ngay_bat_dau AND nhap.ngaynhap <= @ngay_ket_thuc;
    RETURN @tong_gia_tri_nhap;
END;
go
go
SELECT dbo.Cau4('2019-02-05', '2020-07-07') AS TongGiaTriNhap;
go

--Cau 5--
go
CREATE FUNCTION Cau5(@tenHang NVARCHAR(20), @nam INT)
RETURNS MONEY
AS
BEGIN
  DECLARE @tongGiaTriXuat MONEY;
  SELECT @tongGiaTriXuat = SUM(S.giaban * X.soluongX)
  FROM Xuat X
  JOIN Sanpham S ON X.masp = S.masp
  JOIN Hangsx H ON S.mahangsx = H.mahangsx
  WHERE H.tenhang = @tenHang AND YEAR(X.ngayxuat) = @nam;
  RETURN @tongGiaTriXuat;
END;
go
go
SELECT dbo.Cau5(N'OPPO', 2020) AS 'TongGiaTriXuat';
go

--Cau 6--
go
CREATE FUNCTION Cau6(@tenPhong NVARCHAR(30))
RETURNS TABLE
AS
RETURN
    SELECT phong, COUNT(manv) AS soLuongNhanVien
    FROM Nhanvien
    WHERE phong = @tenPhong
    GROUP BY phong;
go
go
SELECT * FROM Cau6(N'Kế toán')
go
--Cau 7--
go
CREATE FUNCTION Cau7(@ten_sp NVARCHAR(20), @ngay_xuat DATE)
RETURNS INT
AS
BEGIN
  DECLARE @so_luong_xuat INT
  SELECT @so_luong_xuat = SUM(soluongX)
  FROM Xuat x JOIN Sanpham sp ON x.masp = sp.masp
  WHERE sp.tensp = @ten_sp AND x.ngayxuat = @ngay_xuat
  RETURN @so_luong_xuat
END
go
go
SELECT dbo.Cau7('F3 lite', '2023-03-31')
go

--Cau 8--
go
CREATE FUNCTION Cau8 (@Sohoadonxuat NCHAR(10))
RETURNS NVARCHAR(20)
AS
BEGIN
  DECLARE @sdtnhanvien NVARCHAR(20)
  SELECT @sdtnhanvien = Nhanvien.sodt
  FROM Nhanvien
  INNER JOIN Xuat ON Nhanvien.manv = Xuat.manv
  WHERE Xuat.sohdx = @Sohoadonxuat
  RETURN @Sohoadonxuat
END
go
go
SELECT dbo.Cau8('01')
go

--Cau9--
go
CREATE FUNCTION Cau9(@tenSP NVARCHAR(20), @nam INT)
RETURNS INT
AS
BEGIN
  DECLARE @tongNhapXuat INT;
  SET @tongNhapXuat = (
  SELECT COALESCE(SUM(nhap.soluongN), 0) + COALESCE(SUM(xuat.soluongX), 0) AS tongSoLuong
    FROM Sanpham sp
    LEFT JOIN Nhap nhap ON sp.masp = nhap.masp
    LEFT JOIN Xuat xuat ON sp.masp = xuat.masp
    WHERE sp.tensp = @tenSP AND YEAR(nhap.ngaynhap) = @nam AND YEAR(xuat.ngayxuat) = @nam
  );
  RETURN @tongNhapXuat;
END;
go
go
SELECT dbo.Cau9('Galaxy Note11', 2023) AS TongNhapXuat;
go

--Cau10--
go
CREATE FUNCTION Cau10(@tenhang NVARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @soluong INT;

    SELECT @soluong = SUM(soluong)
    FROM Sanpham sp JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
    WHERE hs.tenhang = @tenhang;

    RETURN @soluong;
END;
go
go
SELECT dbo.Cau10('Samsung') AS 'Tổng số lượng sản phẩm của hãng'
go