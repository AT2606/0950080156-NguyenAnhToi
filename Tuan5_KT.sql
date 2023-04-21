CREATE DATABASE QLKHO;
USE QLKHO;

CREATE TABLE Ton (
  MaVT INT PRIMARY KEY,
  TenVT VARCHAR(50),
  SoLuongT INT
);
CREATE TABLE Nhap (
  SoHDN INT PRIMARY KEY,
  MaVT INT,
  SoLuongN INT,
  DonGiaN FLOAT,
  NgayN DATE,
  FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
);

CREATE TABLE Xuat (
  SoHDX INT PRIMARY KEY,
  MaVT INT,
  SoLuongX INT,
  DonGiaX FLOAT,
  NgayX DATE,
  FOREIGN KEY (MaVT) REFERENCES Ton(MaVT)
);

-- Thêm 4 mặt hàng vào bảng Ton
INSERT INTO Ton (MaVT, TenVT, SoLuongT)
VALUES (1, 'Mat hang 1', 50),
       (2, 'Mat hang 2', 100),
       (3, 'Mat hang 3', 150),
       (4, 'Mat hang 4', 200);

-- Thêm 3 phiếu nhập vào bảng Nhap
INSERT INTO Nhap (SoHDN, MaVT, SoLuongN, DonGiaN, NgayN)
VALUES (1, 1, 10, 10000, '2023-04-20'),
       (2, 2, 20, 20000, '2023-04-21'),
       (3, 3, 30, 30000, '2023-04-22');

-- Thêm 3 phiếu xuất vào bảng Xuat
INSERT INTO Xuat (SoHDX, MaVT, SoLuongX, DonGiaX, NgayX)
VALUES (1, 1, 5, 15000, '2023-04-20'),
       (2, 2, 10, 25000, '2023-04-21'),
       (3, 3, 15, 35000, '2023-04-22');

Select* from Nhap
Select * from Xuat
Select *from Ton
	     
--Cau 2
GO
CREATE FUNCTION ThongKeTienBan(@MaVT nvarchar(10), @NgayX datetime)
RETURNS TABLE
AS
RETURN
SELECT Ton.MaVT, Ton.TenVT, SUM(Xuat.SoLuongX * Xuat.DonGiaX) AS Tienban
FROM Xuat
INNER JOIN Ton ON Xuat.MaVT = Ton.MaVT
WHERE Ton.MaVT = @MaVT AND Xuat.NgayX = @NgayX
GROUP BY Ton.MaVT, Ton.TenVT
GO
SELECT * FROM ThongKeTienBan(1, '2023-04-20')


---Cau 3
GO
CREATE FUNCTION ThongKeTienNhap2(@MaVT nvarchar(10), @NgayN datetime)
RETURNS TABLE
AS
RETURN (
SELECT MaVT, SUM(SoLuongN * DonGiaN) AS TienNhap
FROM Nhap
WHERE MaVT = @MaVT AND NgayN = @NgayN
GROUP BY MaVT, NgayN)
Go

SELECT * FROM ThongKeTienNhap2(2, '2023-04-21')

