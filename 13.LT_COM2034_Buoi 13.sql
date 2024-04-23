
--HÀM DO NGƯỜI DÙNG ĐỊNH NGHĨA
	-- Hàm giá trị vô hướng				Trả về giá trị đơn của mọi kiểu dữ liệu T-SQL (truy vấn)
	-- Hàm giá trị bảng đơn giản		Trả về bảng, là kết quả của 1 câu lệnh select đơn
	-- Hàm giá trị nhiều câu lệnh		Trả về bảng, là kết quả của nhiều câu lệnh

/*


				CREATE FUNCTION [schema_name.]function_name
				( [ @parameter [ AS ] [type_schema_name.] datatype
				[ = default ] [ READONLY ]
				, @parameter [ AS ] [type_schema_name.] datatype
				[ = default ] [ READONLY ] ]
				)

				RETURNS return_datatype

				[ WITH { ENCRYPTION
				| SCHEMABINDING
				| RETURNS NULL ON NULL INPUT
				| CALLED ON NULL INPUT
				| EXECUTE AS Clause ]

				[ AS ]

				BEGIN

				[declaration_section]

				executable_section

				RETURN return_value

				END;


Tham số:

schema_name: Tên schema (lược đồ) sở hữu function.

function_name: Tên gán cho function.

@parameter: Một hay nhiều tham số được truyền vào hàm.

type_schema_name: Kiểu dữ liệu của schema (nếu có).

Datatype: Kiểu dữ liệu cho @parameter.

Default: Giá trị mặc định gán cho @parameter.

READONLY: @parameter không thể bị function ghi đè lên.

return_datatype: Kiểu dữ liệu của giá trị trả về.

ENCRYPTION: Mã nguồn (source) của function sẽ không được lưu trữ dưới dạng text trong hệ thống.

SCHEMABINDING: Đảm bảo các đối tượng không bị chỉnh sửa gây ảnh hưởng đến function.

RETURNS NULL ON NULL INPUT: Hàm sẽ trả về NULL nếu bất cứ parameter nào là NULL.

CALL ON NULL INPUT: Hàm sẽ thực thi cho dù bao gồm tham số là NULL.

EXECUTE AS clause: Xác định ngữ cảnh bảo mật để thực thi hàm.

return_value: Giá trị được trả về.

////////////////////////////////////////////////////////////////////////////////

*/

--HÀM GIÁ TRỊ VÔ HƯỚNG

--1. Viết hàm giá trị vô hướng, tính tuổi của người có năm sinh là @ns được truyền vào:

-- Xóa hàm nếu đã có (kiểm tra hàm fTuoi có tồn tại thì xóa)
IF OBJECT_ID('fTuoi','FN') IS NOT NULL
	DROP FUNCTION fTuoi
GO

--Tạo hàm Fu_Tuoi
CREATE FUNCTION Fu_Tuoi (@ns INT) --Tên hàm và khai báo các tham số truyền vào cho hàm
RETURNS INT --Khai báo kiểu trả về
AS 
BEGIN
 RETURN YEAR(GETDATE()) - @ns --Năm hiện tại - năm sinh => tuổi (thân hàm)
END
GO
--Biên dịch hàm => F5 

--kiểm tra hàm => gọi hàm
--Cách 1:
PRINT dbo.Fu_Tuoi(1976)  --Lưu ý phải có dbo.
--Cách 2:
PRINT N'Tuổi của bạn là: ' + CONVERT(NVARCHAR, dbo.Fu_Tuoi(1976))

--2. Câu lệnh tạo hàm giá trị vô hướng trả về tổng số lượng nhân viên:

CREATE FUNCTION Fu_DemNV() --Hàm không có tham số đầu vào => ()
RETURNS int --Trả về kiểu giá trị int
BEGIN
    RETURN (SELECT COUNT(MANV) FROM dbo.NHANVIEN) --Đếm số lượng nhân viên (MANV) và trả về tổng số
END
GO

 --Gọi hàm cách 1:
 PRINT N'Tổng số nhân viên là: ' + CONVERT(VARCHAR, dbo.Fu_DemNV())

 --Gọi hàm cách 2: Khái báo 1 biến để nhận giá trị trả về của hàm
 DECLARE @Tong INT
 SELECT @Tong = dbo.Fu_DemNV() --Nhận giá trị của hàm trả về
 PRINT N'Tổng số nhân viên là: ' + CONVERT(VARCHAR, @Tong)
  --Hoặc PRINT @Tong

--3. Câu lệnh tạo hàm giá trị vô hướng trả về tổng số lượng nhân viên theo giới tính:

 CREATE FUNCTION FU_DemNV_Gioitinh (@phai nvarchar(3)) --Phái truyền vào khi gọi thực hiện hàm
RETURNS int --Trả về giá trị có kiểu int
BEGIN
  RETURN (SELECT count(MANV) FROM NHANVIEN
  where PHAI like @phai) --Giá trị truyền vào xác định phái của nhân viên => đếm xem có báo nhiêu nhân viên theo phái được truyền vào
 END
 GO
--Gọi hàm phái nam
PRINT N'Tổng số nhân viên theo phái Nam là: ' + CONVERT(VARCHAR, dbo.Fu_DemNV_Gioitinh(N'Nam'))
--Gọi hàm phái nữ
PRINT N'Tổng số nhân viên theo phái Nữ là: ' + CONVERT(VARCHAR, dbo.Fu_DemNV_Gioitinh(N'Nữ'))

--HÀM GIÁ TRỊ BẢNG ĐƠN GIẢN

--1. Viết hàm trả về bảng các nhân viên làm việc ở phòng số 5 (BẢNG ĐƠN)

CREATE FUNCTION FU_NhanVien_PB (@Maphg int) --giá trị truyền vào
 RETURNS TABLE --Kết quả trả về là 1 bảng
 AS
   RETURN
   (
     SELECT MANV, HONV, TENLOT, TENNV FROM NHANVIEN
     WHERE PHG = @Maphg
    )
GO

--Gọi hàm
SELECT * FROM Fu_NhanVien_PB(005)
SELECT * FROM dbo.NHANVIEN

--HÀM GIÁ TRỊ NHIỀU CÂU LỆNH

--1. Hàm nhận dữ liệu từ bảng phòng ban

CREATE FUNCTION Fu_ListPhong (@phong Int)
  RETURNS @ProdList TABLE --Tên của biến bảng
   (  ten nvarchar(15) , ma int, trphg nvarchar(9), ngay date
   )
 AS
  BEGIN
   IF @phong IS NULL
    BEGIN
     INSERT INTO @ProdList (ten,ma,trphg,ngay) -- Chèn vào bảng ProdList các thông tin lấy từ trong bảng phòng ban
     SELECT TENPHG, MAPHG,TRPHG,NG_NHANCHUC
     FROM dbo.PHONGBAN
    END
   ELSE
   BEGIN
     INSERT INTO @ProdList (ten,ma,trphg,ngay) -- Chèn vào bảng ProdList các thông tin lấy từ trong bảng phòng ban
    SELECT TENPHG, MAPHG,TRPHG,NG_NHANCHUC
     FROM PHONGBAN
     WHERE MAPHG=@phong --Kiểm tra Mã phòng có bằng tham số truyền vào hay không
   END
  RETURN
  END
GO

--Gọi hàm

SELECT * FROM dbo.Fu_ListPhong(NULL)
SELECT * FROM dbo.PHONGBAN
SELECT * FROM dbo.Fu_ListPhong(6)

--XÓA, SỬA NỘI DUNG CỦA MỘT HÀM: Dùng DROP và ALTER => sinh viên thực hiện trên lớp

DROP FUNCTION Fu_NhanVien_PB
DROP FUNCTION Fu_ListPhong
DROP FUNCTION Fu_DemNV
DROP FUNCTION Fu_DemNV_Gioitinh
DROP FUNCTION dbo.Fu_Tuoi

ALTER FUNCTION Fu_Tuoi (@ns1 INT) --Tên hàm và khai báo các tham số truyền vào cho hàm
RETURNS INT --Khai báo kiểu trả về 'TRAN THANH LONG SỬA ĐỔI'
AS 
BEGIN
 RETURN YEAR(GETDATE()) - @ns1 --Năm hiện tại - năm sinh => tuổi (thân hàm)
END

--DEMO
--1. Tạo hàm nhận tham số đầu vào là giới tính nam hoặc nữ và đếm số lượng nhân viên theo giới tính.

CREATE FUNCTION Fu_Dem_Gioitinh (@GT nvarchar(3)) -- Hàm giá trị vô hướng trả về tổng số lượng nhân viên theo giới tính
RETURNS INT
BEGIN
	RETURN (SELECT COUNT(MANV) FROM dbo.NHANVIEN
		WHERE PHAI LIKE @GT); ----Giá trị truyền vào xác định phái của nhân viên => đếm xem có báo nhiêu nhân viên theo phái được truyền vào
END;
GO
--Gọi hàm phái nam
SELECT dbo.Fu_Dem_Gioitinh(N'Nam')
PRINT N'Tổng số nhân viên theo phái Nam là: ' + CONVERT(VARCHAR, dbo.Fu_Dem_Gioitinh(N'Nam'))
SELECT dbo.Fu_Dem_Gioitinh(N'Nam')
--Gọi hàm phái nữ
SELECT dbo.Fu_Dem_Gioitinh(N'Nữ')
PRINT N'Tổng số nhân viên theo phái Nữ là: ' + CONVERT(VARCHAR, dbo.Fu_Dem_Gioitinh(N'Nữ'))

--2. Tạo hàm nhận tham số đầu vào là mã phòng, trả về bảng các nhân viên thuộc mã phòng đó.

CREATE FUNCTION Fu_TimNhanVien_MaPhong (@MaP int)
RETURNS @DSNV TABLE --Tên của biến bảng
(HONV NVARCHAR(15),TENLOT NVARCHAR(15),TENNV NVARCHAR(15),MANV NVARCHAR(9),
NGSINH DATETIME,DCHI NVARCHAR(30),PHAI NVARCHAR(3),LUONG FLOAT,MA_NQL NVARCHAR(9),PHG INT)

 AS
  BEGIN
    INSERT INTO @DSNV (HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
    SELECT HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG FROM dbo.NHANVIEN WHERE PHG = @MaP
	RETURN
   END
 GO

 --Gọi hàm
 SELECT * FROM dbo.Fu_TimNhanVien_MaPhong(5);

 ------///////////////////////////////////////////////////////////////

--VIEW

--1. Tạo view chứa 2 thông tin là tên nhân viên và tên phòng ban

CREATE VIEW Vi_NV_PB
AS
SELECT TENNV, TENPHG FROM dbo.NHANVIEN INNER JOIN dbo.PHONGBAN
ON dbo.NHANVIEN.PHG = dbo.PHONGBAN.MAPHG

--Gọi View
SELECT* FROM Vi_NV_PB

--2. Tạo View có thể cập nhật được, hiển thị tên phòng có mã phòng 6

CREATE VIEW Vi_Update_Phong
AS
SELECT TENPHG, MAPHG FROM dbo.PHONGBAN WHERE  MAPHG = 6

--Gọi View

SELECT * FROM Vi_Update_Phong

--Cập nhật đổi tên phòng bằng update của View

UPDATE Vi_Update_Phong
SET TENPHG = N'Phòng ngủ'

SELECT * FROM Vi_Update_Phong

--2. Tạo view chi đọc

CREATE VIEW Vi_ThongTinNV
AS
SELECT TENNV, LUONG, YEAR(GETDATE()) - YEAR(NGSINH) AS N'Tuổi của nhân viên'
FROM dbo.NHANVIEN WHERE (YEAR(GETDATE()) - YEAR(NGSINH) < 50)

--Gọi View

SELECT * FROM Vi_ThongTinNV

--3. Xóa và chỉnh sửa View: DROP + ALTER

DROP VIEW Vi_ThongTinNV

--Sinh viên thực hành câu lệnh Alter

--DEMO

--1. Tạo View hiển thị Danh sách những trưởng phòng (HONV, TENLOT, TENNV) có tối thiểu một thân nhân

CREATE VIEW Vi_TrPH_TN
AS
SELECT DISTINCT NHANVIEN.HONV, NHANVIEN.TENLOT, NHANVIEN.TENNV
FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.MANV = PHONGBAN.TRPHG
WHERE (SELECT COUNT(THANNHAN.MA_NVIEN) FROM THANNHAN WHERE THANNHAN.MA_NVIEN = NHANVIEN.MANV) > 0

--Gọi View

SELECT * FROM Vi_TrPH_TN

