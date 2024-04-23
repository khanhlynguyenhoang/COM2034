USE MASTER
GO
--tạo database lab 2
CREATE DATABASE LAB2
GO
USE LAB2
--tạo bảng đề án
CREATE TABLE  DEAN(
	TENDEAN nvarchar(15)  ,
	MADA int NOT NULL PRIMARY KEY,
	DDIEM_DA nvarchar(15) NOT NULL,
	PHONG int NULL,
)
--TẠO BẢNG CÔNG VIỆC
CREATE TABLE CONGVIEC(
	MADA int NOT NULL ,
	STT int NOT NULL  ,
	TEN_CONG_VIEC nvarchar(50) NOT NULL,
	PRIMARY KEY (MADA,STT)
)
--TẠO BẢNG PHÒNG BAN
CREATE TABLE PHONGBAN(
	TENPHG nvarchar(15) NOT NULL,
	MAPHG int NOT NULL PRIMARY KEY,
	TRPHG nvarchar(9) NULL,
	NG_NHANCHUC date NOT NULL,
)
--TẠO BẢNG ĐỊA ĐIỂM PHÒNG
CREATE TABLE DIADIEM_PHG(
	MAPHG int NOT NULL ,
	DIADIEM nvarchar(15) NOT NULL ,
	PRIMARY KEY (MAPHG,DIADIEM)
)
--TẠO BẢNG NHÂN VIÊN
CREATE TABLE NHANVIEN(
	HONV nvarchar(15) NOT NULL,
	TENLOT nvarchar(15) NOT NULL,
	TENNV nvarchar(15) NOT NULL,
	MANV nvarchar(9) NOT NULL PRIMARY KEY,
	NGSINH datetime NOT NULL,
	DCHI nvarchar(30) NOT NULL,
	PHAI nvarchar(3) NOT NULL,
	LUONG float NOT NULL,
	MA_NQL nvarchar(9) NULL ,
	PHG int NULL,
)
--TẠO BẢNG PHÂN CÔNG
CREATE TABLE PHANCONG(
	MA_NVIEN nvarchar(9) NOT NULL ,
	MADA int NOT NULL ,
	STT int NOT NULL ,
	THOIGIAN float NOT NULL,
	PRIMARY KEY(MA_NVIEN,MADA,STT)
)
--TẠO BẢNG THÂN NHÂN
CREATE TABLE THANNHAN(
	MA_NVIEN nvarchar(9) NOT NULL,
	TENTN nvarchar(15) NOT NULL ,
	PHAI nvarchar(3) NOT NULL,
	NGSINH date NOT NULL,
	QUANHE nvarchar(15) NOT NULL,
	PRIMARY KEY(MA_NVIEN,TENTN)
)

--THIẾT LẬP MQH GIỮA CÁC BẢNG
--BẢNG NHÂN VIÊN
ALTER TABLE NHANVIEN
ADD FOREIGN KEY (PHG) REFERENCES PHONGBAN(MAPHG),
FOREIGN KEY (MA_NQL) REFERENCES NHANVIEN(MANV);
--BẢNG PHÒNG BAN
ALTER TABLE PHONGBAN
ADD FOREIGN KEY (TRPHG) REFERENCES NHANVIEN(MANV);
--BẢNG ĐỊA ĐIỂM PHÒNG
ALTER TABLE DIADIEM_PHG
ADD FOREIGN KEY (MAPHG) REFERENCES PHONGBAN(MAPHG);
--BẢNG THÂN NHÂN
ALTER TABLE THANNHAN
ADD FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MANV);
--BẢNG ĐỀ ÁN
ALTER TABLE DEAN
ADD FOREIGN KEY (PHONG) REFERENCES PHONGBAN(MAPHG);
--BẢNG CÔNG VIỆC
ALTER TABLE CONGVIEC
ADD FOREIGN KEY (MADA) REFERENCES DEAN(MADA);
--BẢNG PHÂN CÔNG
--ALTER TABLE PHANCONG
--ADD CONSTRAINT PK_PHANCONG PRIMARY KEY CLUSTERED (MADA,MA_NVIEN,STT) 
--FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MANV),
ALTER TABLE PHANCONG  WITH CHECK ADD  CONSTRAINT [FK_CongViec_PhanCong] FOREIGN KEY(MADA, STT)
REFERENCES CONGVIEC (MADA,STT)
ALTER TABLE PHANCONG 
ADD FOREIGN KEY (MA_NVIEN) REFERENCES NHANVIEN(MANV)
--KẾT THÚC PHẦN TẠO BẢNG
--BẢNG CÔNG VIỆC
INSERT INTO CONGVIEC(MADA, STT, TEN_CONG_VIEC)
VALUES (1, 1, N'Thiết kế sản phẩm X'),
(1, 2, N'Thử nghiệm sản phẩm X'),
(2, 1, N'Sản xuất sản phẩm Y'),
(2, 2, N'Quảng cáo sản phẩm Y'),
(3, 1, N'Khuyến mãi sản phẩm Z'),
(10, 1, N'Tin học hóa phòng nhân sự'),
(10, 2, N'Tin học hóa phòng kinh doanh'),
(20, 1, N'Lắp đặt cáp quang'),
(30, 1, N'Đào tạo nhân viên Marketing'),
(30, 2, N'Đào tạo nhân viên thiết kế')

INSERT INTO PHONGBAN(TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
 VALUES (N'Quản Lý', 1, N'006', (N'1971-06-19' )),
 (N'Điều Hành', 4, N'008', (N'1985-01-01')),
 (N'Nghiên Cứu', 5, N'005', (N'0197-05-22' )),
 (N'IT', 6, N'008', (N'1985-01-01' ))
INSERT INTO NHANVIEN (HONV, TENLOT, TENNV, MANV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
VALUES (N'Đinh', N'Quỳnh', N'Như', N'001', CAST(N'1967-02-01' AS DateTime), N'291 Hồ Văn Huê, TP HCM', N'Nữ', 4,NULL, NULL),
(N'Phan', N'Viet', N'The', N'002', CAST(N'1984-01-11T00:00:00.000' AS DateTime), N'778 nguyễn kiệm , TP hcm', N'', 30000, NULL, NULL),
(N'Trần', N'Thanh', N'Tâm', N'003', CAST(N'1957-05-04T00:00:00.000' AS DateTime), N'34 Mai Thị Lự, Tp Hồ Chí Minh', N'Nam', 25000, NULL, NULL),
(N'Nguyễn', N'Mạnh ', N'Hùng', N'004', CAST(N'1967-03-04T00:00:00.000' AS DateTime), N'95 Bà Rịa, Vũng Tàu', N'Nam', 38000, NULL,NULL ),
(N'Nguyễn', N'Thanh', N'Tùng', N'005', CAST(N'1962-08-20T00:00:00.000' AS DateTime), N'222 Nguyễn Văn Cừ, Tp HCM', N'Nam', 40000, NULL, NULL),
(N'Phạm', N'Văn', N'Vinh', N'006', CAST(N'1965-01-01T00:00:00.000' AS DateTime), N'15 Trưng Vương, Hà Nội', N'Nữ', 55000, NULL, NULL),
(N'Bùi ', N'Ngọc', N'Hành', N'007', CAST(N'1954-03-11T00:00:00.000' AS DateTime), N'332 Nguyễn Thái Học, Tp HCM', N'Nam', 25000, NULL, NULL),
(N'Trần', N'Hồng', N'Quang', N'008', CAST(N'1967-09-01T00:00:00.000' AS DateTime), N'80 Lê Hồng Phong, Tp HCM', N'Nam', 25000, NULL, NULL),
(N'Đinh ', N'Bá ', N'Tiên', N'009', CAST(N'1960-02-11T00:00:00.000' AS DateTime), N'119 Cống Quỳnh, Tp HCM', N'N', 30000, NULL, NULL),
(N'Đinh ', N'Bá ', N'Tiên', N'017', CAST(N'1960-02-11T00:00:00.000' AS DateTime), N'119 Cống Quỳnh, Tp HCM', N'N', 30000, NULL, NULL)
INSERT THANNHAN(MA_NVIEN, TENTN, PHAI, NGSINH, QUANHE)
VALUES (N'001', N'Minh', N'Nam', CAST(N'1932-02-29' AS Date), N'Vợ Chồng'),
(N'005', N'Khang', N'Nam', CAST(N'1973-10-25' AS Date), N'Con Trai'),
(N'005', N'Phương', N'Nữ', CAST(N'1948-05-03' AS Date), N'Vợ Chồng'),
(N'005', N'Trinh', N'Nữ', CAST(N'1976-04-05' AS Date), N'Con Gái'),
(N'009', N'Châu ', N'Nữ', CAST(N'1978-09-30' AS Date), N'Con Gái'),
(N'009', N'Phương', N'Nữ', CAST(N'1957-05-05' AS Date), N'Vợ Chồng'),
(N'009', N'Tiến ', N'Nam', CAST(N'1978-01-01' AS Date), N'Con Trai'),
(N'017', N'Tiến ', N'Nam', CAST(N'1978-01-01' AS Date), N'Con Trai')
INSERT INTO PHANCONG(MA_NVIEN, MADA, STT, THOIGIAN)
VALUES (N'001', 20, 1, 15.321547),
(N'001', 30, 1, 20.5),
(N'003', 1, 2, 20),
(N'003', 2, 1, 20),
(N'004', 3, 1, 40.7),
(N'005', 3, 1, 10),
(N'005', 10, 2, 10),
(N'005', 20, 1, 10),
(N'006', 20, 1, 30),
(N'007', 10, 2, 10.7),
(N'007', 30, 2, 30),
(N'008', 10, 1, 35.2),
(N'008', 30, 2, 5),
(N'009', 1, 1, 32.54),
(N'009', 2, 2, 8.9)
INSERT INTO DEAN(TENDEAN, MADA, DDIEM_DA, PHONG)
VALUES (N'Sản Phẩm x', 1, N'Vũng Tàu', 5),
(N'Sản Phẩm Y', 2, N'Nha Trang', 5),
(N'Sản Phẩm Z', 3, N'TP HCM', 5),
(N'Tin Học Hóa', 10, N'Hà Nội', 4),
(N'Cáp quang', 20, N'TP HCM', 1),
(N'Đào tạo', 30, N'Hà Nội', 4)
INSERT INTO DIADIEM_PHG(MAPHG, DIADIEM)
VALUES (1, N'TP HCM'),
(4, N'Hà Nội'),
(5, N'Nha Trang'),
(5, N'TP HCM'),
(5, N'Vũng Tàu')
SELECT * FROM NHANVIEN
--1.	Cho biêt nhân viên có lương cao nhất
DECLARE @MAX_LUONG INT
SET @MAX_LUONG =(SELECT MAX(LUONG) FROM NHANVIEN)
SELECT @MAX_LUONG AS N'LƯƠNG LỚN NHẤT'
--2.	Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu”
DECLARE @LUONG_TB INT
SET @LUONG_TB = (
SELECT AVG(LUONG) FROM NHANVIEN
JOIN PHONGBAN
ON NHANVIEN.PHG=PHONGBAN.MAPHG
WHERE TENPHG=N'Nghiên cứu')
SELECT * FROM NHANVIEN WHERE LUONG>@LUONG_TB
--3.	Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
DECLARE @LUONG_PHONGBAN TABLE(TENPB NVARCHAR(20),SOLUONG INT,LUONGTB INT)
INSERT INTO @LUONG_PHONGBAN
SELECT TENPHG,COUNT(MANV) N'SỐ LƯỢNG', AVG(LUONG) N'lƯƠNG TRUNG BÌNH' FROM NHANVIEN
JOIN PHONGBAN
ON NHANVIEN.PHG=PHONGBAN.MAPHG
GROUP BY TENPHG
HAVING AVG(LUONG)>30000
SELECT * FROM @LUONG_PHONGBAN
--4.	Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
DECLARE @DA_PHONGBAN TABLE(TENPB NVARCHAR(20),SOLUONGSA INT)
INSERT INTO @DA_PHONGBAN
SELECT TENPHG, COUNT(MADA) N'SỐ DỰ ÁN' FROM DEAN
JOIN PHONGBAN
ON DEAN.PHONG=PHONGBAN.MAPHG
GROUP BY PHONG,TENPHG
SELECT * FROM @DA_PHONGBAN

--a.	Chương trình tính diện tích, chu vi hình chữ nhật khi biết chiều dài và chiều rộng.
--1. Tính diện tích
Declare @chieudai int, @chieurong int, @dientich int
set @chieudai=10 -- Gán biến cho chiều dài là 10
set @chieurong=6 -- Gán biến cho chiều rộng là 6
set @dientich=@chieudai*@chieurong -- Tính giá trị của diện tích
Select @dientich as 'Diện tích' -- Hiển thị kết quả
--2. Tính chu vi

Declare @chieudai2 int, @chieurong2 int, @chuvi int
set @chieudai2=10 -- Gán biến cho chiều dài là 10
set @chieurong2=6 -- Gán biến cho chiều rộng là 6
set @chuvi=2*(@chieudai2+@chieurong2) -- Tính giá trị của diện tích
Select @chuvi as 'Chu Vi' -- Hiển thị kết quả
--3. Tính diện tích hình thang
Declare @Day_Lon int, @Day_Nho int, @Chieu_Cao int, @Dien_Tich int
set @Day_Lon=20
set @Day_Nho=15
set @Chieu_Cao=12
set @Dien_Tich=(@Day_Lon+@Day_Nho)*@Chieu_Cao/2
Select @Dien_Tich as 'Dien Tich Hinh Thang'
--4. Tính diện tích hình tam giác (Đáy*chiều cao)/2
Declare @Canh_Day int, @Chieu_Cao int, @Dien_Tich int
Set @Canh_Day=10
Set @Chieu_Cao=15
Set @Dien_Tich=(@Canh_Day*@Chieu_Cao)/2
Select @Dien_Tich as 'Dien Tich Hinh Tam Giac'
--5. Tính chu vi hình tam giác (tổng 3 cạnh)
Declare @Canh_a int , @Canh_b int, @Canh_c int,@Chu_vi int
set @Canh_a=10
set @Canh_b=20
set @Canh_c=30
set @Chu_vi = @Canh_a+@Canh_b+@Canh_c
select @Chu_vi as N'Chu vi tam giác'
--6. Tính diện tích hình bình hành (cạnh đay * chiều cao)
Declare @Canh_Day int, @Chieu_Cao int, @Dien_Tich int
Set @Canh_Day=10
Set @Chieu_Cao=15
Set @Dien_Tich=@Canh_Day*@Chieu_Cao
Select @Dien_Tich as 'Dien Tich Hinh Bình Hành'
--7. Tính chu vi hình bình hành (tổng 2 cạnh liền kề)*2
Declare @Canh_Day int, @Canh_Ben int, @Chu_Vi int
Set @Canh_Day=10
Set @Canh_Ben=15
Set @Chu_Vi=(@Canh_Day+@Canh_Ben)*2
Select @Chu_Vi as 'Chu Vi Hinh Bình Hành'
