--1. Giới thiệu:
	-- UI => User Interface: Giao diện người dùng
	-- UX => User Experience: Trải nghiệm người dùng
	-- LINQ => Language Integrated Query: Mô hình hóa một cơ sở dữ liệu
	-- OQL => Object Query Language: Ngôn ngữ truy vấn hướng đối tượng
--2. Cú pháp:
--3. Tạo Store Procedure

--a. Select (ID tăng tự động)
Create Procedure PhongBan_SelectAll
-- Do select all => không cần biến
As
Begin
Select * From PhongBan
End

--Thực thi

exec PhongBan_SelectAll

--==========================================
--b. Insert
Create Procedure PhongBan_Insert(
-- ID tăng tự động => không cần khai báo biến
		@tenPB nvarchar(50)  --Khai báo như trong thiết kế
)
As
Begin
	Insert into PhongBan(tenPB) values (@tenPB)
End
--==========================================
--c. Update
Create Procedure PhongBan_Update(
		@tenPB nvarchar(50),
		@ID int
)
As
Begin
	Update PhongBan set tenPB=@tenPB Where ID=@ID
End
--==========================================
--c. Delete
Create Procedure PhongBan_Delete(
		@ID int
)
As
Begin
	Delete From PhongBan Where ID=@ID
End

--==========================================
-- Bảng NhanVien

Create Procedure Nhavien_SelectID(
	@ID int
)
As
Begin
	Select * From NhanVien Where ID=@ID
End
--==========================================

Create Procedure NhanVien_Insert(
	@hoTen nvarchar(50),
	@queQuan nvarchar(50), 
	@ID int
)
AS
Begin
	Insert into NhanVien(hoTen, queQuan, ID) values (@hoTen, @queQuan, @ID)
End
--==========================================

Create Procedure NhanVien_Update(
	@hoTen nvarchar(50),
	@queQuan nvarchar(50), 
	@maNV int
)
As
Begin
	Update NhanVien Set hoTen=@hoTen, queQuan=@queQuan Where maNV=@maNV
End

--==========================================

Create Procedure NhanVien_Delete(
		@maNV int
)
As
Begin
	Delete From NhanVien Where maNV=@maNV
End
--==========================================

--1. Tạo Stored-Procedure tính tổng
Create Proc sp_Tong @So1 int, @So2 int
As
Begin
	Declare @Tong int;
	Set @Tong = @So1 + @So2
	Print @Tong
End
--==========================================
Exec sp_Tong 5, 11
--==========================================
Create Proc sp_Tong1 @So1 int=2, @So2 int=7 --Tham số mặc định
As
Begin
	Declare @Tong int;
	Set @Tong = @So1 + @So2
	Print @Tong
End
--==========================================
Exec sp_Tong1
--==========================================
Create Proc sp_Tong
	@So1 int,
	@So2 int,
	@Tong int OUT --Tham số đầu ra
As
Begin
	Set @Tong = @So1 + @So2
End
go
--==========================================
declare @KQ int
exec sp_Tong 3, 2 ,@KQ OUT
select @KQ as TONG_OUT
--==========================================

CREATE PROCEDURE test_proc

@intInput int,
@intOutput int OUTPUT

AS
set @intOutput = @intInput + 1 

go
--==========================================
declare @intResult int
exec test_proc 3 ,@intResult OUT
select @intResult
--==========================================
CREATE PROCEDURE sp_Tong
@So1 int, @So2 int, @Tong int out
AS
Begin
SET @Tong = @So1 + @So2;
End
--==========================================
Declare @Sum int
Exec sp_Tong 1, -2, @Sum out
Select @Sum
--==========================================
--Đếm số lương nhân viên ở TP HCM
Create Proc DemNv1
	@ThanhPho nvarchar(30)

As
Begin
	Declare @num int
	Select @num = count(*) From dbo.NHANVIEN
	Where DCHI like '%' + @ThanhPho
	Return @num
End
go
--Thực thi thủ tục
Declare @tongso int
Exec @tongso = DemNv1'TP HCM'
Select @tongso as SoLuongNhanVien_HCM
go
--==========================================
--Truy xuất thông tin nhân viên theo mã
Create PROCEDURE sp_ThongtinNV1
	@MaNV nvarchar(9)
 AS
 Begin
 SELECT * from NHANVIEN WHERE MaNV = @MaNV
 End

 --Thực thi
Exec sp_ThongtinNV1'004'

--==========================================
--Điều kiện trong SP => Thêm 1 phòng ban có tên là CNTT-IT
Create PROCEDURE sp_ThemPhongBan1
	@TenPHG nvarchar(15),  @MaPHG int,
	@TRPHG nvarchar(9),  @NG_NHANCHUC date
 AS
 IF EXISTS(SELECT * From PHONGBAN Where MAPHG = @MaPHG)
	UPDATE PHONGBAN SET TENPHG =  @TenPHG, TRPHG = @Trphg,NG_NHANCHUC=@NG_NHANCHUC
	WHERE MAPHG = @MaPHG
 ELSE
	INSERT INTO PHONGBAN
			VALUES (@TenPHG,@MaPHG,@TRPHG,@NG_NHANCHUC)
 
 --Thực thi
 Exec sp_ThemPhongBan1 'CNTT',6,'008','1986-02-02'

 --==========================================
  -- Lệnh xóa Procedure 
 Drop Proc sp_ThemPhongBan1

 -- System stored procedures
 sp_helptext ThongtinNV
  --==========================================

 -- Bài tập
 -- 1. Viết store procedure nhận vào tham số là năm sinh, xuất ra tên các nhân viên
			CREATE PROC sp_NamSinh
				@namsinh INT
			AS
			BEGIN
				SELECT * FROM dbo.NHANVIEN
					WHERE DATENAME(YEAR, NGSINH) = @namsinh
			END;

			--===============================================
			EXEC dbo.sp_NamSinh 1960

 -- 2. Viết store procedure đếm số lượng thân nhân của nhân viên có mã nhân viên được nhập từ người dùng
			CREATE PROC sp_SLNhanthan
				@manv NVARCHAR(9)
			AS
			BEGIN
				SELECT MA_NVIEN, COUNT(MA_NVIEN) AS N'Số lượng' FROM dbo.THANNHAN
				WHERE MA_NVIEN = @manv
				GROUP BY MA_NVIEN
			END;
			--===============================================
			EXEC dbo.sp_SLNhanthan '005'

 -- 3. Cập nhật SP
 -- 4. Xóa SP
 -- 5. Điều kiện trong SP
 -- 6. Lặp trong SP
 -- 7. Template trong SP
 -- 8. Execute trong SP
 -- 9. System trong SP
 -- 10. Viết stored-procedure Nhập vào số nguyên @n. In ra tổng, và số lượng các số chẵn từ 1 đến @n
			 CREATE PROC sp_TongChan
				@n INT
			AS
			BEGIN
				DECLARE @sum INT, @count INT, @i INT;

				SET @sum = 0;
				SET @count = 0;
				SET @i = 1;

				WHILE @i <= @n
				BEGIN
					IF @i % 2 = 0
					BEGIN
						SET @sum = @sum + @i;
						SET @count = @count + 1;
					END
					SET @i = @i + 1;
				END

			PRINT 'Tong: ' + CAST(@sum AS VARCHAR);
			PRINT 'Dem: ' + CAST(@count AS VARCHAR);
			END;
			--===============================================
			EXEC dbo.sp_TongChan 10

 -- 11. Viết stored-procedure thêm phòng ban, các giá trị được thêm vào dưới dạng tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại
 
			 CREATE PROCEDURE sp_ThemPhongBan1
				 @TenPHG nvarchar(15),  @MaPHG int,
				 @TRPHG nvarchar(9),  @NG_NHANCHUC date
			 AS
			BEGIN
			 IF EXISTS(SELECT * From PHONGBAN Where MAPHG = @MaPHG)
			 BEGIN
				PRINT N'Chèn dữ liệu không thành công';
				RETURN;
			 END

			 INSERT INTO PHONGBAN  VALUES (@TenPHG,@MaPHG,@TRPHG,@NG_NHANCHUC)
			 PRINT N'Chèn dữ liệu thành công!';
			END;
 --==========================================
--HD thêm
--1. Tìm kiếm thông tin nhân viên theo mã
  use QLDA
	go
exec sp_ThongtinNV'003'

--2. Tính tổng theo Wile

DECLARE @Number INT = 1 ;
DECLARE @Total INT = 0 ;
 
WHILE @Number < = 12
	BEGIN
		SET @Total = @Total + @Number;
		SET @Number = @Number + 1 ;
	END
			PRINT @Total;
GO

--3. In ra từ 1 đến 5
DECLARE @counter INT = 1;
  
WHILE @counter <= 5
BEGIN
    PRINT @counter;
    SET @counter = @counter + 1;
END

--4. Thủ tục lưu trữ với tham số đầu ra
CREATE PROCEDURE test_proc
	@intInput int,
	@intOutput int OUTPUT
AS
	set @intOutput = @intInput + 1 
go
-- Thực thi
declare @intResult int
exec test_proc 3 ,@intResult OUT
select @intResult

declare @intResult int
set @intResult = 8
exec test_proc 3 ,@intResult OUT
select @intResult
---==========================================

ALTER PROCEDURE [dbo].[SP_INSERT_DMLOP]
(@nchMALOP NCHAR(5), @nvcTENLOP NVARCHAR(100), @nvcGVCN NVARCHAR(100), @nvcGHICHU NVARCHAR(200))

AS
	-- Kiểm tra trùng khóa chính
	IF EXISTS(SELECT * FROM dbo.DMLOP WHERE MALOP = @nchMALOP)

	INSERT INTO DMLOP(MALOP, TENLOP, GVCN, GHICHU)
	VALUES(@nchMALOP, @nchMALOP, @nvcGVCN, @nvcGHICHU)

--====================================

--Công nghệ AI ChatGPT

CREATE TABLE KHACHHANG (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  address VARCHAR(255),
  phone VARCHAR(255)
);

CREATE PROCEDURE insert_customer (IN name VARCHAR(255), IN address VARCHAR(255), IN phone VARCHAR(255))
BEGIN
  INSERT INTO KHACHHANG (name, address, phone)
  VALUES (name, address, phone);
END;

CALL insert_customer('TRAN THANH LONG', 'HA NOI', '0988526759');

CREATE PROCEDURE update_customer (IN customer_id INT, IN name VARCHAR(255), IN address VARCHAR(255), IN phone VARCHAR(255))
BEGIN
  UPDATE KHACHHANG
  SET name = name, address = address, phone = phone
  WHERE id = customer_id;
END;

CREATE PROCEDURE delete_customer (IN customer_id INT)
BEGIN
  DELETE FROM KHACHHANG
  WHERE id = customer_id;
END;

CREATE PROCEDURE get_customer_by_id (IN customer_id INT)
BEGIN
  SELECT * FROM KHACHHANG
  WHERE id = customer_id;
END;

CREATE PROCEDURE SumTwoNumbers (@number1 INT, @number2 INT, @sum INT OUTPUT)
AS
BEGIN
    SET @sum = @number1 + @number2;
END;

DECLARE @result INT;
EXEC SumTwoNumbers @number1 = 5, @number2 = 7, @sum = @result OUTPUT;
SELECT @result AS TotalSum;


CREATE PROCEDURE SumTwoNumbers (@number1 INT, @number2 INT)
AS
BEGIN
    SELECT @number1 + @number2 AS TotalSum;
END;

EXEC SumTwoNumbers @number1 = 5, @number2 = 7;


CREATE PROCEDURE SumEvenNumbers (@start INT, @end INT)
AS
BEGIN
    DECLARE @sum INT = 0;
    DECLARE @current INT = @start;

    WHILE (@current <= @end)
    BEGIN
        IF (@current % 2 = 0)
            SET @sum = @sum + @current;

        SET @current = @current + 1;
    END;

    SELECT @sum AS TotalSum;
END;

EXEC SumEvenNumbers @start = 1, @end = 10;


CREATE PROCEDURE update_customer (IN customer_id INT, IN name VARCHAR(255), IN address VARCHAR(255), IN phone VARCHAR(255))
BEGIN
  UPDATE KHACHHANG
  SET name = name, address = address, phone = phone
  WHERE id = customer_id;
END;

CALL update_customer(1, 'John Doe', '123 Main St', '555-555-1212');

--===================================================================
CREATE PROCEDURE insert_student
(
    @id INT,
    @name VARCHAR(50),
    @age INT
)
AS
BEGIN
    INSERT INTO students (id, name, age)
    VALUES (@id, @name, @age);
END;

EXEC insert_student 1, 'John Doe', 22;

