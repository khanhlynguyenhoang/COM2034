--1. Tạo Stored-Procedure tính tổng
--Create Proc sp_Tong1 @So1 int, @So2 int
As
Begin
	Declare @Tong int;
	Set @Tong = @So1 + @So2
	Print @Tong
End
----
Exec sp_Tong1 10, 6
--Truy xuất thông tin nhân viên theo Mã nhân viên
--CREATE PROCEDURE sp_ThongtinNV @MaNV nvarchar(9)
AS
Begin
SELECT * from NHANVIEN WHERE MaNV = @MaNV
End
GO
EXEC sp_ThongtinNV '005'
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
 CREATE PROC sp_NamSinh
				@namsinh INT
			AS
			BEGIN
				SELECT * FROM dbo.NHANVIEN
					WHERE DATENAME(YEAR, NGSINH) = @namsinh
			END;
			select * from NHANVIEN

			SELECT * FROM dbo.NHANVIEN
			EXEC dbo.sp_NamSinh 1967
			-- 2. Viết store procedure đếm số lượng thân nhân của nhân viên có mã nhân viên được nhập từ người dùng
			CREATE PROC sp_SLNhanthan
				@manv NVARCHAR(9)
			AS
			BEGIN
				SELECT MA_NVIEN, COUNT(MA_NVIEN) AS N'Số lượng' FROM dbo.THANNHAN
				WHERE MA_NVIEN = @manv
				GROUP BY MA_NVIEN
			END;
			exec dbo.sp_SLNhanthan '005'

			exec sp_server_info  
			use master
			exec sys.sp_tables