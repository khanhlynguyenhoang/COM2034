
--BÀI THỰC HÀNH LAB07-COM2034 - BL1-SU2023

--Bài 1: Viết các hàm

--1. Nhập vào MaNV cho biết tuổi của nhân viên này
DROP FUNCTION Fu_Tuoi
CREATE FUNCTION Fu_Tuoi
(@MaNV NVARCHAR(9)) --Xem kiểu dữ liệu và miền giá trị trong bảng nhân viên
RETURNS INT
AS 
BEGIN
	RETURN (SELECT DATEDIFF(YEAR, NGSINH, GETDATE()) + 1 --Có thể dùng: YEAR(getdate())-YEAR(NGSINH)
	FROM dbo.NHANVIEN WHERE MANV = @MaNV);
END;

--Gọi hàm
SELECT  dbo.Fu_Tuoi('005');
PRINT N'Tuổi của bạn là: ' + CONVERT(NVARCHAR, dbo.Fu_Tuoi('005'))

SELECT * FROM NHANVIEN

--2. Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia

CREATE FUNCTION Fu_TongDeAn
(@MaNV nvarchar(9))
RETURNS INT
AS 
BEGIN
	RETURN (SELECT COUNT(MADA)  FROM PHANCONG WHERE MA_NVIEN = @MaNV);
END;

--Gọi hàm
SELECT dbo.Fu_TongDeAn('005') 

SELECT * FROM PHANCONG

--3. Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái

CREATE FUNCTION Fu_ThongKeGT
(@GT nvarchar(3))
RETURNS INT
AS 
BEGIN
	RETURN (SELECT COUNT(MANV) FROM NHANVIEN WHERE PHAI = @GT); 
END;

--Gọi hàm
SELECT dbo.Fu_ThongKeGT(N'Nam') AS N'Tổng số nhân viên Nam là:';
SELECT dbo.Fu_ThongKeGT(N'Nữ') AS N'Tổng số nhân viên Nam là:';

--4. Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó,
	-- Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng đó.

CREATE FUNCTION Fu_LuongTB
(@Tenphong nvarchar(15))
RETURNS INT
AS 
BEGIN
	RETURN (SELECT AVG(NHANVIEN.LUONG) FROM PHONGBAN JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
			WHERE TENPHG LIKE N'%' + @Tenphong + N'%') --Chứa giá trị truyền vào
END;

--Thực hiện: Cho biết các nhân viên của phòng quản lý có mức lương lớn hơn mức lương trung bình của phòng điều hành 
SELECT HONV, TENLOT, TENNV FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
	WHERE LUONG > dbo.Fu_LuongTB(N'Nghiên Cứu') AND TENPHG LIKE N'%Nghiên Cứu%';

SELECT * FROM PHONGBAN
SELECT * FROM NHANVIEN


--5. Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng và số lượng đề án mà phòng ban đó chủ trì

CREATE FUNCTION Fu_Phong_DeAn
(@MaP int)
RETURNS @DS TABLE (TenPhong nvarchar(15), TenTruongPhong nvarchar(15), SoLuongDeAn int)
AS 
BEGIN
	INSERT INTO @DS
		SELECT A.TENPHG, B.HONV + ' ' + B.TENLOT + ' ' + B.TENNV,
			(SELECT COUNT(C.MADA) FROM DEAN C WHERE C.PHONG = A.MAPHG)
		FROM PHONGBAN A INNER JOIN NHANVIEN B ON A.TRPHG = B.MANV
		WHERE A.MAPHG = @MaP;
  RETURN;      
END;

--Gọi hàm
SELECT * FROM dbo.Fu_Phong_DeAn(4);

--Bài 2: Tạo các view
--1. Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.

CREATE VIEW ThongtinNV_DDiem
AS 
	SELECT NHANVIEN.HONV, NHANVIEN.TENLOT, NHANVIEN.TENNV, PHONGBAN.TRPHG, DIADIEM_PHG.DIADIEM
		FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG AND
		NHANVIEN.MANV = PHONGBAN.TRPHG INNER JOIN DIADIEM_PHG ON PHONGBAN.MAPHG = DIADIEM_PHG.MAPHG

--Gọi view

SELECT * FROM ThongtinNV_DDiem

--2. Hiển thị thông tin TenNv, Lương, Tuổi.

CREATE VIEW Ten_Tuoi_Luong
AS
	SELECT TENNV, LUONG, DATEDIFF(YEAR, NGSINH, GETDATE()) AS N'Tuổi nhân viên'
		FROM dbo.NHANVIEN

--Gọi View

SELECT * FROM Ten_Tuoi_Luong

--3. Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất

CREATE VIEW PhongBanDongNhat
AS
SELECT a.TENPHG, b.HONV + ' ' + b.TENLOT + ' ' + b.TENNV AS N'Tên trưởng phòng'
	FROM dbo.PHONGBAN a JOIN dbo.NHANVIEN b ON a.TRPHG = b.MANV
		WHERE a.MAPHG IN (SELECT PHG FROM dbo.NHANVIEN
				GROUP BY PHG
					HAVING COUNT(MANV) = (SELECT TOP 1 COUNT(MANV) AS DEMNV FROM dbo.NHANVIEN
						GROUP BY PHG
							ORDER BY DEMNV DESC))

--Gọi view
SELECT * FROM PhongBanDongNhat


--===========================================================================
--THAM KHẢO
CREATE FUNCTION Fu_Luong_TB1
(@TenPhong nvarchar(15))
RETURNS TABLE 
AS 
 RETURN (SELECT HONV, TENLOT, TENNV FROM dbo.NHANVIEN, dbo.PHONGBAN 
	WHERE LUONG > (SELECT AVG(LUONG) FROM dbo.NHANVIEN, dbo.PHONGBAN
		WHERE TENPHG= @TenPhong  AND MAPHG = PHG) 
			AND  MAPHG = PHG AND TENPHG like @TenPhong)

SELECT * FROM dbo.Fu_Luong_TB1(N'Điều Hành')
--===========================================================================
