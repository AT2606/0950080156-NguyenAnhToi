

------LAB9------------
---CÂU 1------
go
CREATE TRIGGER trg_Nhap
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @masp NVARCHAR(10)
    DECLARE @manv NVARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN
    FROM inserted
    IF(NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp))
    BEGIN
        RAISERROR('Lỗi: masp không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    
    IF( NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv))
    BEGIN
        RAISERROR('Lỗi: manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
  
    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Lỗi: soluongN và dongiaN phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    ELSE
    UPDATE Sanpham SET soluong = soluong + @soluongN FROM Sanpham
    WHERE masp = @masp
END
go
SELECT* FROM Sanpham
SELECT* FROM Nhanvien
SELECT * FROM Nhap

INSERT INTO NHAP VALUES('NH01','SP01','NV01','3/7/2022',0,15000)

---CÂU 2------
go
CREATE TRIGGER trg_xuat
ON Xuat
AFTER INSERT
AS
BEGIN
   
    IF (NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = (SELECT masp FROM inserted)))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF( NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = (SELECT manv FROM inserted)))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    

    DECLARE @soluongX INT
    SELECT @soluongX = soluongX FROM inserted
    
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = (SELECT masp FROM inserted)
    
    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng hàng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    UPDATE Sanpham  SET soluong = soluong - @soluongX
    WHERE masp = (SELECT masp FROM inserted)
END
go

SELECT* FROM Sanpham
SELECT* FROM Nhanvien
SELECT * FROM Xuat

INSERT INTO Xuat VALUES('HD02','SP05','NV01','2022/03/03',15000)

-----Câu 3---------
go
CREATE TRIGGER trg_kt_xoa
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END
go
DELETE FROM Xuat WHERE sohdx ='HD01'

-----Câu 4--------
go
CREATE TRIGGER trg_updateSL
ON xuat
AFTER UPDATE
AS
BEGIN
  
    IF (SELECT COUNT(*) FROM inserted) < 2
    BEGIN
	DECLARE @old_soluong INT, @new_soluong INT, @masp NVARCHAR(10)

        SELECT @masp = i.masp, @old_soluong = d.soluongX, @new_soluong = i.soluongX
        FROM deleted d INNER JOIN inserted i ON d.sohdx = i.sohdx AND d.masp = i.masp

       
        IF (@new_soluong <= (SELECT soluong FROM sanpham WHERE masp = @masp))
        BEGIN
            UPDATE xuat SET soluongX = @new_soluong WHERE sohdx IN (SELECT sohdx FROM inserted)
            UPDATE sanpham SET soluong = soluong + @old_soluong - @new_soluong WHERE masp = @masp
        END
    END
END
GO

-----Câu 5
GO
CREATE TRIGGER tr_updateSLNhap
ON Nhap
AFTER UPDATE
AS
BEGIN
 
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('Chỉ được phép cập nhật 1 bản ghi tại một thời điểm', 16, 1)
        ROLLBACK
    END
    
    DECLARE @masp INT
    DECLARE @soluongN INT
    DECLARE @soluong INT
    
    SELECT @masp = i.masp, @soluongN = i.soluongN, @soluong = s.soluong
    FROM inserted i
    INNER JOIN Sanpham s ON i.masp = s.masp
    
    IF (@soluongN > @soluong)
    BEGIN
        RAISERROR('Số lượng nhập không được vượt quá số lượng hiện có trong kho', 16, 1)
        ROLLBACK
    END
    
    UPDATE Sanpham
    SET soluong = soluong + (@soluongN - (SELECT soluongN FROM deleted WHERE masp = @masp))
    WHERE masp = @masp
END
GO

-----Câu 6----
GO
CREATE TRIGGER TRG_update_soluongSP
ON Nhap
AFTER DELETE
AS

BEGIN
    
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong - deleted.soluongN
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END
GO







