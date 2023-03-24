USE TUAN1_LAB123
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
