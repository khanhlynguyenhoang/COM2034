use master
go
drop database QLNHATRO
go
-- Tạo database
create database QLNHATRO
go

use QLNHATRO
go
--Tạo các bảng trong database
--Bảng loại nhà
create table LOAINHA(
	MaLoaiNha int primary key,
	TenLoaiNha nvarchar(50),
	ThongTinLoaiNha nvarchar(50)
)
go
--Bảng người dùng
create table  NGUOIDUNG
(
	MaNguoiDung int  primary key,
	TenNguoiDung nvarchar(50),
	GioiTinh bit,
	DienThoai char(50),
	DiaChi nvarchar(50),
	Quan nvarchar(50),
	Email char(50)
)
go
	-- Bảng NhaTro
create table NHATRO
(
	MaNhaTro int  PRIMARY KEY,
	MaLoaiNha int,
	DienTich real ,
	GiaPhong money,
	DiaChi nvarchar(50),
	Quan nvarchar(50),
	MoTa nvarchar(50),
	NgayDang date,
	foreign key(MaLoaiNha) references LOAINHA(MaLoaiNha),
	Constraint chk_dientich check (DienTich>0),
	Constraint chk_giaphong check (GiaPhong>0),
)
go
	-- Bảng DanhGia
 create table DANHGIA
(
	MaNhaTro int,
	MaND int,
	DanhGia varchar(20),
	ThongTinDanhGia nvarchar(50),
	PRIMARY KEY (Manhatro, MaND),
	foreign key(MaNhaTro) references NHATRO(MaNhaTro),
	foreign key(MaND) references NGUOIDUNG(MaNguoiDung)
)
--thêm dữ liệu
--Bảng ngươì dùng
		create proc sp_Insert_NguoiDung
			@MaNguoiDung int ,
			@TenNguoiDung nvarchar(50) , 
			@GioiTinh bit ,
			@DienThoai char(50) , 
			@DiaChi nvarchar(50) , 
			@Quan nvarchar(50) , 
			@Email  char(50) 
		as 
		if
			(@MaNguoiDung is null) or
			(@TenNguoiDung is null) or 
			(@GioiTinh is null) or 
			(@DienThoai is null) or 
			(@DiaChi is null) or 
			(@Quan is null) or
			(@Email is null)
			begin
			print N'Lỗi'
			print N'Thiếu dữ liệu, mời nhập lại'
			end
		else
			begin
			insert into NGUOIDUNG(MaNguoiDung,TenNguoiDung,GioiTinh,DienThoai,DiaChi,Quan,Email)
			values(@MaNguoiDung,@TenNguoiDung,@GioiTinh,@DienThoai,@DiaChi,@Quan ,@Email)
			end
exec sp_Insert_NguoiDung 1,N'Nguyễn Hoàng Khánh Ly',1,'0964113982',N'Tiên Du',N'Bắc Ninh','lyly1062004@gmail.com'
exec sp_Insert_NguoiDung 2,N'Nguyễn Thị Hường',1,'097412589',N'Tiên Du',N'Bắc Ninh','lhuongnt@gmail.com'
exec sp_Insert_NguoiDung 3,N'Nguyễn Thị Ngọc Minh',1,'0852147932',N'Tiên Du',N'Bắc Ninh','ngocminh@gmail.com'
exec sp_Insert_NguoiDung 4,N'Nguyễn Thị Mai Linh',1,'0147852369',N'Tiên Du',N'Bắc Ninh','mailinh@gmail.com'
exec sp_Insert_NguoiDung 5,N'Trịnh Đình Trường',0,'0369852147',N'Chương Mỹ',N'Hà Nội','truongtt@gmail.com'
exec sp_Insert_NguoiDung 6,N'Nguyễn Văn An',0,'0378965412',N'Chương Mỹ',N'Hà Nội','annv@gmail.com'
exec sp_Insert_NguoiDung 7,N'ĐàoThị Lan',1,'0985632147',N'Tiên Du',N'Bắc Ninh','landt@gmail.com'
exec sp_Insert_NguoiDung 8,N'Nguyễn Văn Long',0,'0963258741',N'Vân Canh',N'Nam Từ Liêm','long@gmail.com'
exec sp_Insert_NguoiDung 9,N'Nguyễn Thanh Hoàng',0,'0963214587',N'Bắc Hồng',N'Đông Anh','thanhhoang@gmail.com'
exec sp_Insert_NguoiDung 10,N'Nguyễn Tùng Dương',0,'0963258741',N'Tiên Du',N'Bắc Ninh','tungduongh@gmail.com'
--Dữ liệu lỗi
exec sp_Insert_NguoiDung 10,null,0,'0963258741',N'Tiên Du',N'Bắc Ninh','tungduongh@gmail.com'

--Bảng Loại nhà
	create proc sp_Insert_LoaiNha

	@MaLoaiNha int,
	@TenLoaiNha nvarchar(50),
	@ThongTinLoaiNha nvarchar(50)
	as
	if
			(@MaLoaiNha is null) or
			(@TenLoaiNha is null) or 
			(@ThongTinLoaiNha is null)
			begin
			print N'Lỗi'
			print N'Thiếu dữ liệu, mời nhập thêm'
			end
	else
			begin
			insert into LOAINHA(MaLoaiNha,TenLoaiNha,ThongTinLoaiNha)
			values(@MaLoaiNha,@MaLoaiNha,@ThongTinLoaiNha)
			end
exec sp_Insert_LoaiNha 1,N'Chung cư',N'Khép kín'
exec sp_Insert_LoaiNha 2,N'Nhà Trọ',N' Không Khép kín'
exec sp_Insert_LoaiNha 3,N'Chung cư',N'Khép kín'
exec sp_Insert_LoaiNha 4,N'Nhà Trọ',N'Khép kín'
exec sp_Insert_LoaiNha 5,N'Chung cư',N'Không Khép kín'
exec sp_Insert_LoaiNha 6,N'Chung cư',N'Khép kín'
exec sp_Insert_LoaiNha 7,N'Nhà Trọ',N'Khép kín'
exec sp_Insert_LoaiNha 8,N'Chung cư',N'Không Khép kín'
exec sp_Insert_LoaiNha 9,N'Nhà cấp 4',N'Khép kín'
exec sp_Insert_LoaiNha 10,N'Chung cư',N'Khép kín'
-- dữ liệu lỗi
exec sp_Insert_LoaiNha 10,null,N'Khép kín'
--Bảng Nhà trọ
	create proc sp_insert_NhaTro 
	@MaNhaTro int,
	@MaLoaiNha int , 
	@DienTich real , 
	@GiaPhong money , 
	@DiaChi nvarchar(50) ,
	@Quan nvarchar(50),
	@MoTa nvarchar(50) , 
	@NgayDang date  ,
	@kt1 int = 0
	as
	--Kiểm tra thông tin đầu vào
	if 
	(@MaNhaTro is null) or 
	(@MaLoaiNha is null) or 
	(@DienTich is null) or 
	(@GiaPhong is null) or 
	(@DiaChi is null) or 
	(@Quan is null) or
	(@NgayDang is null)
	begin
	print N'Lỗi:'
	print N'Thiếu dữ liệu, mời nhập thêm'
	end 
else 
begin
	--Kiểm tra mã loại nhà có tồn tại hay không
	if not exists (select * from LoaiNha where MaLoaiNha = @MaLoaiNha ) 
	begin
	set @kt1 = 1
	print N'Loại nhà này không tồn tại'
	end
	if @kt1 = 0
	begin
	insert into NhaTro
	values (@MaNhaTro,@MaLoaiNha, @DienTich, @GiaPhong, @DiaChi, @Quan, @MoTa,@NgayDang)
	print N'Thêm thông tin thành công'
	END
end
go
select * from NHATRO
exec sp_Insert_NhaTro 1,1,25,3000000,N'Vân Canh',N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-5-6'
exec sp_Insert_NhaTro 2,2,25,3000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-4-6'
exec sp_Insert_NhaTro 3,3,30,4000000,N'Hòe Thị',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-4-3'
exec sp_Insert_NhaTro 4,4,25,5000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-4-1'
exec sp_Insert_NhaTro 5,5,20,6000000,N'Xuân Phương',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-4-2'
exec sp_Insert_NhaTro 6,6,50,7000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2022-4-2'
exec sp_Insert_NhaTro 7,7,18,8000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2022-4-2'
exec sp_Insert_NhaTro 8,8,13,1000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-5-1'
exec sp_Insert_NhaTro 9,9,10,2000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2023-4-10'
exec sp_Insert_NhaTro 10,10,12,15000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2021-4-2'
-- thêm dữ liệu lỗi
exec sp_Insert_NhaTro 10,30,12,15000000,N'Vân Canh',	N'Nam Từ Liêm',	N'Phòng tiện nghi, rộng','2021-4-2'

--Bảng đánh giá
		--
		create proc sp_insert_DanhGia 
		@MaNhaTro int , 
		@MaND int , 
		@DanhGia bit = true,
		@ThongTinDanhGia nvarchar(50) = null, 
		@kt1 int = 0,
		@kt2 int = 0, 
		@kt3 int = 0
		as
		if (@MaNhaTro is null) or (@MaND is null) 
			begin
			print N'Lỗi:'
			print N'Thiếu thông tin đầu vào'
			end
		else 
begin
			--Kiểm tra mã nhà trọ có tồn tại hay không
			if not exists (select * from NhaTro where MaNhaTro = @MaNhaTro ) 
				begin
				set @kt1 = 1
				print N'Nhà trọ này không tồn tại'
			end
			--Kiểm tra người dùng tồn tại hay không
			if not exists (select * from NguoiDung	where MaNguoiDung	= @MaND )
				begin
					set @kt2 = 1
					print N'Người dùng này không tồn tại'
				end
			--Kiểm tra xem người dùng đã đánh giá nhà trọ hay chưa
			if exists (select * from DanhGia where MaND = @MaND and MaNhaTro = @MaNhaTro)
				begin
					set @kt3 = 1
					print N'Người dùng này đã đánh giá nhà trọ này'
				end
			if @kt1 = 0 and @kt2 = 0 and @kt3 = 0 
				begin
					insert into DanhGia
					values (@MaNhaTro , @MaND , @DanhGia , @ThongTinDanhGia) 
					print N'Thêm thông tin thành công'
				end
end
--thêm dữ liệu
exec sp_Insert_DanhGia 1,1,true,N'Nhà trọ đẹp'
exec sp_Insert_DanhGia 2,1,true,N'Phòng đẹp, rộng'
exec sp_Insert_DanhGia 3,3,false,N'Nhà trọ đẹp'
exec sp_Insert_DanhGia 4,4,false,N'Nhà trọ đẹp'
exec sp_Insert_DanhGia 5,5,true,N'Nhà trọ đẹp'
exec sp_Insert_DanhGia 6,6,true,N'Không đẹp'
exec sp_Insert_DanhGia 7,7,true,N'Nhà trọ đẹp'
exec sp_Insert_DanhGia 8,8,false,N'Giá cao quá'
exec sp_Insert_DanhGia 9,9,true,N'Nhà trọ bình thường'
exec sp_Insert_DanhGia 10,10,true,N'Nhà trọ đẹp'
 select * from DANHGIA
 --dữ liệu lỗi
exec sp_Insert_DanhGia 10,10,true,N'Nhà trọ đẹp'

--Các yêu cầu về chức năng
--1. Thêm thông tin vào các bảng
-- Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp
--SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG
--đã làm bên trên phần thêm dữ liệu
--2. Truy vấn thông tin
--SP thực hiện tìm kiếm thông tin các
--phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
--tin, khoảng giá tiền, loại hình nhà trọ.
--2. Truy vấn thông tin
	--a. Viết một SP với các tham số đầu vào phù hợp => Tìm theo quận
		-- drop procedure sp_quan
create procedure sp_TimKiem 
@Quan nvarchar(50),
@DienTichmin real,
@DienTichmax real,
@GiaPhongmin money,
@GiaPhongmax money

as
begin
select (N'Cho thuê phòng trọ tại ' + nhatro.Diachi +' ' + nhatro.Quan),
			(replace(cast(dientich as varchar),'.',',')+'m2') as N'Diện tích',
			(replace(convert(varchar,giaphong,103),',','.')) as N'Giá Phòng',
			MoTa,
			convert(varchar,ngaydang,105) as N'Ngày đăng tin',
			case gioitinh 
			when 0 then 'A.' + reverse(substring((reverse(TenNguoiDung)),0,charindex(' ',(reverse(tennguoidung)))))
			when 1 then 'C. ' + reverse(substring((reverse(TenNguoiDung)),0,charindex(' ',(reverse(tennguoidung)))))
			end as N'Tên người dùng',
			dienthoai as N'Số điệnt thoại liên hệ',
			nguoidung.diachi as N'Địa chỉ liên hệ'
	 from nhatro inner join danhgia on nhatro.MaNhaTro=danhgia.MaNhaTro
				 inner join nguoidung on danhgia.MaND=nguoidung.MaNguoiDung
where nhatro.quan = @quan
	and DienTich between  @DienTichmin and @DienTichmax
	and GiaPhong between  @GiaPhongmin and @GiaPhongmax
end
select * from NHATRO
Exec sp_TimKiem N'Nam Từ liêm',23,50,1000000,6000000
Exec sp_TimKiem N'Nam Từ liêm',9,10,1000000,6000000
--b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng
--NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng
--NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.
create function FU_Cau2b
(@tennguoidung nvarchar(50),@gioitinh bit,
@dienthoai nvarchar(50),@diachi nvarchar(50),
@quan nvarchar(50),@email char(50))
RETURNS int
BEGIN
	RETURN (
	Select MaNguoiDung from NGUOIDUNG
	where TenNguoiDung=@tennguoidung 
	and gioitinh=@gioitinh 
	and dienthoai=@dienthoai 
	and DiaChi=@diachi 
	and quan = @quan 
	and email =@email
	)
END
--thực thi hàm
print cast(dbo.FU_Cau2b(N'Nguyễn Hoàng Khánh Ly',1,'0964113982',N'Tiên Du',N'Bắc Ninh','lyly1062004@gmail.com')
as varchar(50))
select * from NGUOIDUNG
--c. Viết một hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng
--NHATRO). Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.
	create function sp_cauc (@manhatro int)
	returns @table table
		(
			sodislike varchar,
			solike varchar 
		)
	begin
		
			insert into @table
			values((select  count(*)	from danhgia where manhatro = @manhatro and danhgia = 0),
			(select  count(*) 	from danhgia where manhatro = @manhatro and danhgia = 1))
			return;	
	end
go
--Thực thi hàm
	select * from sp_cauc(3)
go
--d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm
--các thông tin sau:
-- Diện tích
-- Giá
-- Mô tả
-- Ngày đăng tin
-- Tên người liên hệ
-- Địa chỉ
-- Điện thoại
-- Email
--Viết hàm
	Create view sp_caud
	as
		select 
		TenNguoiDung as N'Tên người liên hệ',
		dientich as N'Diện tích',
		GiaPhong as N'Giá',
		ThongTinDanhGia as N'Mô tả',
		NgayDang as N'Ngày Đăng Tin',
		nhatro.DiaChi as N'Địa chỉ',
		Dienthoai as N'Điện Thoại',
		Email, nhatro.MaNhaTro
		from danhgia, nguoidung, nhatro
		where nguoidung.MaNguoiDung = danhgia.MaND
		and danhgia.MaNhaTro = nhatro.MaNhaTro
		and nhatro.manhatro in 
	(select top10 from (select  top 10 manhatro as top10, count(*) as abc from danhgia where danhgia = 1 
	group by manhatro order by abc desc)as temp)
go
--Thực thi
	select * from sp_caud
go
--e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của
--bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau:
-- Mã nhà trọ
-- Tên người đánh giá
-- Trạng thái LIKE hay DISLIKE
-- Nội dung đánh giá
	create procedure sp_DanhGia 
	@manhatro int
	as
	begin
		select nhatro.manhatro as N'Mã Nhà Trọ',
		tennguoidung as N'Tên người đánh giá',
		case danhgia 
		when 1 then 'Like'
		when 0 then 'Dislike'
		end as N'Trạng thái Like hay dislike',
		MoTa as N'Nội dung đánh giá'
		from danhgia
		inner join nguoidung on nguoidung.MaNguoiDung=danhgia.MaND
		inner join nhatro on danhgia.MaNhaTro=nhatro.MaNhaTro
		where nhatro.manhatro = @manhatro
	end
--thực thi
	exec sp_DanhGia 2
--3. Xóa thông tin
--1. Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện
--thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng
--DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
	--Viết hàm
	CREATE PROC sp_xoa @SLDislike INT
	 AS
	  BEGIN
	  -- tạo biến bảng lưu trữ mã nhà trọ có lượt dislike lớn hơn số lg tham số truyền vào
		DECLARE @MaNhaTro TABLE (MaNhaTro VARCHAR(10))
		INSERT INTO @MaNhaTro
		SELECT MaNhaTro FROM dbo.DANHGIA WHERE DanhGia = 0 
		GROUP BY MaNhaTro 
		HAVING COUNT([DanhGia])>@SLDislike
	
		BEGIN TRANSACTION
			 DELETE FROM dbo.DANHGIA WHERE MaNhaTro IN (SELECT MaNhaTro FROM @MaNhaTro) 
			 DELETE FROM dbo.NHATRO WHERE MaNhaTro IN (SELECT MaNhaTro FROM @MaNhaTro)
			 -- sử dụng giao dịch để đảm bảo tính toàn vẹn dữ liệu
			 ROLLBACK TRAN 
	  END
  --Thực thi
  SELECT * FROM dbo.DANHGIA
  SELECT * FROM dbo.NHATRO
  EXEC dbo.sp_xoa @SLDislike = 0
  GO 
-- b. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện thao tác xóa thông tin những nhà trọ 
--   được đăng trong khoảng thời gian được truyền vào qua các tham số.
--   Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này.
--Thực thi hàm
CREATE PROC sp_ThoiGian @Start DATE, @Finish DATE
  AS
    BEGIN
	-- tạo biến bảng lưu trữ mã nhà trọ có thời gian đăng tin trong khoảng thời gian được truyền vào qua các tham số.
	  DECLARE @ThoiGian TABLE (MaNhaTro VARCHAR(10))
	  INSERT INTO @ThoiGian
      SELECT MaNhaTro FROM dbo.NHATRO
	  WHERE NgayDang BETWEEN @Start AND @Finish

		  BEGIN TRANSACTION
		    DELETE FROM dbo.DANHGIA WHERE MaNhaTro IN (SELECT MaNhaTro FROM @ThoiGian) -- bắt buộc phải xóa ở bảng đánh giá trước vì có mối quan hệ FK
		  	DELETE FROM dbo.NHATRO WHERE MaNhaTro IN (SELECT MaNhaTro FROM @ThoiGian)
		  -- sử dụng giao dịch để đảm bảo tính toàn vẹn dữ liệu
		  ROLLBACK TRAN
    END

-- thực thi 
SELECT * FROM dbo.NHATRO
EXEC dbo.sp_ThoiGian @Start = '2022-07-11', 
                     @Finish = '2023-08-11' 

SELECT * FROM dbo.NHATRO
EXEC dbo.sp_ThoiGian @Start = '2009-07-11', 
                     @Finish = '2009-08-11'



	


