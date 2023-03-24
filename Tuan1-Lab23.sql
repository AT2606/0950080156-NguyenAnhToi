USE TUAN1_LAB123
CREATE TABLE Hangsx (
  mahangsx NCHAR(10) PRIMARY KEY,
  tenhang NVARCHAR(20),
  diachi NVARCHAR(30),
  sodt NVARCHAR(20),
  email NVARCHAR(30)
);

CREATE TABLE Sanpham (
  masp NCHAR(10) PRIMARY KEY,
  mahangsx NCHAR(10) REFERENCES Hangsx(mahangsx),
  tensp NVARCHAR(20),
  soluong INT,
  mausac NVARCHAR(20),
  giaban MONEY,
  donvitinh NCHAR(10),
  mota NVARCHAR(MAX)
);

CREATE TABLE Nhanvien (
  manv NCHAR(10) PRIMARY KEY,
  tennv NVARCHAR(20),
  gioitinh NCHAR(10),
  diachi NVARCHAR(30),
  sodt NVARCHAR(20),
  email NVARCHAR(30),
  phong NVARCHAR(30)
);

CREATE TABLE Nhap (
  sohdn NCHAR(10) PRIMARY KEY,
  masp NCHAR(10) REFERENCES Sanpham(masp),
  manv NCHAR(10) REFERENCES Nhanvien(manv),
  ngaynhap DATE,
  soluongN INT,
  dongiaN MONEY
);

CREATE TABLE Xuat (
  sohdx NCHAR(10) PRIMARY KEY,
  masp NCHAR(10) REFERENCES Sanpham(masp),
  manv NCHAR(10) REFERENCES Nhanvien(manv),
  ngayxuat DATE,
  soluongX INT
);
INSERT INTO Hangsx(mahangsx,tenhang,diachi,sodt,email)VALUES ('H01','Samsung','Korea','011-08271717','ss@gmail.com.kr')
INSERT INTO Hangsx(mahangsx,tenhang,diachi,sodt,email)VALUES ('H02','OPPO','China','081-08626262','oppo@gmail.com.cn')
INSERT INTO Hangsx(mahangsx,tenhang,diachi,sodt,email)VALUES ('H03','Vinfone',N'Việt Nam','084-098262626','vf@gmail.com.vn');

INSERT INTO Nhanvien VALUES
('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán');
-- insert vao sanpham
INSERT INTO Sanpham VALUES
('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP02', 'H01', 'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
('SP03', 'H02', 'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp');
-- insert vao nhap
INSERT INTO Nhap VALUES
('N01', 'SP02', 'NV01', '02-05-2019', 10, 17000000),
('N02', 'SP01','NV02','04-07-2020',30,6000000),
('N03', 'SP04','NV02','05-17-2020',20,1200000),
('N04', 'SP01','NV03','03-22-2020',10,6200000),
('N05', 'SP05','NV01','07-07-2020',20,7000000);
-- insert vao xuat
INSERT INTO Xuat VALUES
('X01', 'SP03', 'NV02', '06-14-2020', 5),
('X02', 'SP01', 'NV03', '03-05-2019', 3),
('X03', 'SP02', 'NV01', '12-12-2020', 1),
('X04', 'SP03', 'NV02', '06-02-2020', 2),
('X05', 'SP05', 'NV01', '05-18-2020', 1);

-------------Lab2---------

-- 1. Hiển thị thông tin các bảng dữ liệu trên 
SELECT * FROM SanPham
-- 2.Đưa ra thông tin masp, tensp, tenhang,soluong, mausac, giaban, donvitinh, mota của các sản phẩm sắp xếp theo chiều giảm dần giá bán
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
ORDER BY Sanpham.giaban DESC;
-- 3.Đưa ra thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là samsung sản xuất.
SELECT Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung'
-- 4.Đưa ra thông tin các nhân viên Nữ ở phòng ‘Kế toán’
SELECT * FROM nhanvien
WHERE gioitinh = 'Nữ' AND phong = 'Kế toán'
-- 5.Đưa ra thông tin phiếu nhập gồm: sohdn, masp, tensp, tenhang, soluongN, dongiaN, tiennhap=soluongN*dongiaN, mausac, donvitinh, ngaynhap, tennv, phong. Sắp xếp theo chiều tăng dần của hóa đơn nhập.
SELECT Nhap.sohdn, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Nhap.soluongN, Nhap.dongiaN, 
Nhap.soluongN*Nhap.dongiaN AS tiennhap, Sanpham.mausac, Sanpham.donvitinh, Nhap.ngaynhap, Nhanvien.tennv, Nhanvien.phong
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
ORDER BY Nhap.sohdn ASC;

--6. Đưa ra thông tin phiếu xuất gồm: sohdx, masp, tensp, tenhang, soluongX, giaban, tienxuat=soluongX*giaban, mausac, donvitinh, ngayxuat, tennv, phong trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx.

SELECT Xuat.sohdx, Sanpham.masp, Sanpham.tensp, Hangsx.tenhang, Xuat.soluongX, Sanpham.giaban, 
       Xuat.soluongX*Sanpham.giaban AS tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.ngayxuat, 
       Nhanvien.tennv, Nhanvien.phong
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE MONTH(Xuat.ngayxuat) = 10 AND YEAR(Xuat.ngayxuat) = 2018
ORDER BY Xuat.sohdx ASC;
-- 7. Đưa ra các thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017, gồm: sohdn, masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong.

SELECT sohdn, Sanpham.masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
FROM Nhap 
JOIN Sanpham ON Nhap.masp = Sanpham.masp 
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2017;
--8. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018, sắp xếp theo chiều giảm dần của soluongX.

SELECT TOP 10 Xuat.sohdx, Sanpham.tensp, Xuat.soluongX
FROM Xuat 
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE YEAR(Xuat.ngayxuat) = '2023' 
ORDER BY Xuat.soluongX DESC;
--9. Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần gía bán.

SELECT TOP 10 tenSP, giaBan
FROM SanPham
ORDER BY giaBan DESC;
--10. Đưa ra các thông tin sản phẩm có gía bán từ 100.000 đến 500.000 của hãng samsung.
SELECT *
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND Sanpham.giaban >= 100000 AND Sanpham.giaban <= 500000
--11. Tính tổng tiền đã nhập trong năm 2018 của hãng samsung.

SELECT SUM(soluongN * dongiaN) AS tongtien
FROM Nhap
JOIN Sanpham ON Nhap.masp = Sanpham.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(ngaynhap) = 2018
--12. Thống kê tổng tiền đã xuất trong ngày 2/9/2018

SELECT SUM(Xuat.soluongX * Sanpham.giaban) AS Tongtien
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE Xuat.ngayxuat = '2018-09-02'
--13. Đưa ra sohdn, ngaynhap có tiền nhập phải trả cao nhất trong năm 2018

SELECT TOP 1 sohdn, ngaynhap, dongiaN
FROM Nhap
ORDER BY dongiaN DESC
--14. Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019.

SELECT TOP 10 Sanpham.tensp, SUM(Nhap.soluongN) AS TongSoLuongN 
FROM Sanpham 
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp 
WHERE YEAR(Nhap.ngaynhap) = 2019 
GROUP BY Sanpham.tensp 
ORDER BY TongSoLuongN DESC
--15. Đưa ra masp,tensp của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.

SELECT Sanpham.masp, Sanpham.tensp
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
INNER JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND Nhanvien.manv = 'NV01';
--16. Đưa ra sohdn,masp,soluongN,ngayN của mặt hàng có masp là ‘SP02’, được nhân viên ‘NV02’ xuất.

SELECT sohdn, masp, soluongN, ngaynhap
FROM Nhap
WHERE masp = 'SP02' AND manv = 'NV02'
--17. Đưa ra manv,tennv đã xuất mặt hàng có mã ‘SP02’ ngày ’03-02-2020’.

SELECT Nhanvien.manv, Nhanvien.tennv
FROM Nhanvien
JOIN Xuat ON Nhanvien.manv = Xuat.manv
WHERE Xuat.masp = 'SP02' AND Xuat.ngayxuat = '2020-03-02'

--------------Lab3---------------
--1. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm

SELECT Hangsx.tenhang, COUNT(*) as 'So luong san pham'
FROM Sanpham
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
GROUP BY Hangsx.tenhang;
--2. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
SELECT Sanpham.tensp, SUM(Nhap.soluongN * Nhap.dongiaN) as 'Tong tien nhap'
FROM Sanpham
JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2018
GROUP BY Sanpham.tensp;

--3. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
SELECT Sanpham.tensp, SUM(Xuat.soluongX) as 'Tong so luong xuat'
FROM Sanpham
JOIN Xuat ON Sanpham.masp = Xuat.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' AND YEAR(Xuat.ngayxuat) = 2018
GROUP BY Sanpham.tensp
HAVING SUM(Xuat.soluongX) > 10000;

--4. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
SELECT Nhanvien.phong, COUNT(*) as 'So luong nhan vien Nam'
FROM Nhanvien
WHERE Nhanvien.gioitinh = N'Nam'
GROUP BY Nhanvien.phong

--5. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) as 'Tong so luong nhap'
FROM Sanpham
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
WHERE YEAR(Nhap.ngaynhap) = 2018
GROUP BY Hangsx.tenhang;

--6. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
SELECT Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) as 'Tong tien xuat'
FROM Xuat
JOIN Sanpham ON Xuat.masp = Sanpham.masp
JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.tennv;

--7. Hãy đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
SELECT Nhanvien.tennv, SUM(Nhap.soluongN * Nhap.dongiaN) as 'Tong tien nhap'
FROM Nhap
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE YEAR(Nhap.ngaynhap) = 2018 AND MONTH(Nhap.ngaynhap) = 8
GROUP BY Nhanvien.tennv
HAVING SUM(Nhap.soluongN * Nhap.dongiaN) > 100000;

--8. Hãy đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
SELECT Sanpham.tensp
FROM Sanpham
LEFT JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Xuat.masp IS NULL;

--9. Hãy đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018.
SELECT sp.masp, sp.tensp
FROM Sanpham sp
JOIN Nhap n ON sp.masp = n.masp
JOIN Xuat x ON n.masp = x.masp AND YEAR(n.ngaynhap) = 2018 AND YEAR(x.ngayxuat) = 2018

--10. Hãy đưa ra danh sách các nhân viên vừa nhập vừa xuất.
SELECT DISTINCT n.manv, nv.tennv
FROM Nhap n
JOIN Xuat x ON n.manv = x.manv AND n.ngaynhap = x.ngayxuat
JOIN Nhanvien nv ON n.manv = nv.manv

--11. Hãy đưa ra danh sách các nhân viên không tham gia việc nhập và xuất.
SELECT nv.manv, nv.tennv
FROM Nhanvien nv
WHERE nv.manv NOT IN (
    SELECT DISTINCT manv FROM Nhap
    UNION
    SELECT DISTINCT manv FROM Xuat
)
