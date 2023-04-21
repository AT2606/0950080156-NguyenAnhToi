--Cau1--

CREATE TABLE MATHANG (
  mahang INT PRIMARY KEY,
  tenhang VARCHAR(50) NOT NULL,
  soluong INT NOT NULL
);

CREATE TABLE NHATKYBANHANG (
  stt INT PRIMARY KEY,
  ngay DATE NOT NULL,
  nguoimua VARCHAR(50) NOT NULL,
  mahang INT NOT NULL,
  soluong INT NOT NULL,
  giaban FLOAT NOT NULL,
  FOREIGN KEY (mahang) REFERENCES MATHANG(mahang)
);

--Cau2--
INSERT INTO MATHANG (mahang, tenhang, soluong)
VALUES 
  (1, 'keo', 100),
  (2, 'banh', 50),
  (3, 'thuoc', 200);
 
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES (1, '2022-01-01', 'Nguyen van a ', 1, 2, 15000);
  
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
--Cau3a--
Go
CREATE TRIGGER trg_nhatkybanhang_insert
ON NHATKYBANHANG
AFTER INSERT
AS
BEGIN
	UPDATE MATHANG
	SET soluong = MATHANG.soluong - inserted.soluong
	FROM MATHANG
	INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END;
Go
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(6, '2022-04-22', 'Nguyen minh khoi', 1, 3, 15000)
SELECT * FROM MATHANG
--Cau3b--
Go
CREATE TRIGGER trg_nhatkybanhang_update
ON NHATKYBANHANG
AFTER UPDATE
AS
	BEGIN
		IF UPDATE(soluong)
		BEGIN
		UPDATE MATHANG
		SET soluong = MATHANG.soluong + deleted.soluong - inserted.soluong
		FROM MATHANG
		INNER JOIN deleted ON MATHANG.mahang = deleted.mahang
		INNER JOIN inserted ON MATHANG.mahang = inserted.mahang
	END
END;
Go
UPDATE NHATKYBANHANG SET soluong = 2 WHERE stt = 2
SELECT * FROM MATHANG
--Cau3c--
Go
CREATE TRIGGER trg_nhatkybanhang_insert2
ON NHATKYBANHANG
FOR INSERT
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong <= @soluong_hien_co
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong - @soluong
		WHERE mahang = @mahang
		END
		ELSE
		BEGIN
		RAISERROR('Số lượng hàng bán ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
END;
Go
INSERT INTO NHATKYBANHANG (stt, ngay, nguoimua, mahang, soluong, giaban)
VALUES
(7, '2021-06-21', 'tran van chien', 2, 10, 12000)
SELECT * FROM MATHANG
--Cau3d--
Go
CREATE TRIGGER trg_nhatkybanhang_update2
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
IF (SELECT COUNT(*) FROM inserted) > 1
BEGIN
	RAISERROR('Chỉ được cập nhật 1 bản ghi tại một thời điểm!', 16, 1)
	ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM inserted

		SELECT @soluong_hien_co = soluong
		FROM MATHANG
		WHERE mahang = @mahang

		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
Go
UPDATE NHATKYBANHANG SET soluong = 1 WHERE stt = 3
SELECT * FROM MATHANG
--Cau3e--
GO
CREATE TRIGGER trg_nhatkybanhang_delete
ON NHATKYBANHANG
FOR DELETE
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 1
	BEGIN
		RAISERROR('Chỉ được xóa 1 bản ghi tại một thời điểm!', 16, 1)
		ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
		DECLARE @mahang INT, @soluong INT
		SELECT @mahang = mahang, @soluong = soluong
		FROM deleted
		UPDATE MATHANG
		SET soluong = soluong + @soluong
		WHERE mahang = @mahang
	END
END;
Go
DELETE FROM NHATKYBANHANG WHERE stt = 4
SELECT * FROM MATHANG
--Cau3f--
Go
CREATE TRIGGER trg_nhatkybanhang_update3
ON NHATKYBANHANG
FOR UPDATE
AS
BEGIN
	DECLARE @mahang INT, @soluong INT, @soluong_hien_co INT

	SELECT @mahang = mahang, @soluong = soluong
	FROM inserted

	SELECT @soluong_hien_co = soluong
	FROM MATHANG
	WHERE mahang = @mahang

	IF @soluong > @soluong_hien_co
	BEGIN
		RAISERROR('Số lượng cập nhật không được vượt quá số lượng hiện có!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE IF @soluong = @soluong_hien_co
	BEGIN
		RAISERROR('Không cần cập nhật số lượng!', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		UPDATE MATHANG
		SET soluong = soluong + (SELECT soluong FROM deleted) - @soluong
		WHERE mahang = @mahang
	END
END;
Go
UPDATE NHATKYBANHANG SET soluong = 7 WHERE stt = 3
SELECT * FROM MATHANG
--Cau3g--
Go
CREATE PROCEDURE sp_xoa_mathang
@mahang INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM MATHANG WHERE mahang = @mahang)
BEGIN
PRINT 'Mã hàng không tồn tại!'
RETURN
END

BEGIN TRANSACTION

DELETE FROM NHATKYBANHANG WHERE mahang = @mahang
DELETE FROM MATHANG WHERE mahang = @mahang

COMMIT TRANSACTION

PRINT 'Xóa mặt hàng thành công!'
END
Go

EXEC sp_xoa_mathang 3
SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG
