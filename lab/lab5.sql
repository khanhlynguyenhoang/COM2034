--Bài 1
--In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên Tiếng Việt có dấu của
--bạn. 
create  proc sp_lab5_bai1a 
@name nvarchar(20)
as
 begin
	print 'Xin chào:' + @name
 end
exec sp_lab5_bai1a N'Khánh Ly'
--Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
create or alter proc sp_lab5_bai1b
@s1 int,
@s2 int
as
 begin
		declare @tong int;
		set @tong=@s1+@s2
		print N'Tổng 2 số là:' + Cast(@tong as nvarchar)
 end
 go 
 exec sp_lab5_bai1b 7,8
 --Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @
 create or alter proc sp_lab5_bai1c
@n int
as
 begin
		declare @tong int =0, @i int=2;
		while(@i<=@n)
		begin
			if(@i%2=0)
			begin
				set @tong=@tong+@i
			end
			set @i=@i+2
		end
		
		select @tong as N'Tổng số chẵn là:'
		print N'Tổng 2 số là:' + Cast(@tong as nvarchar)
 end
 go 
 exec sp_lab5_bai1c 8
 --Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây:
 create proc sp_lab5_bai1d
	@s1 int,
	@s2 int
 as 
 begin
	while(@s1 !=@s2)
	begin
	if(@s1>@s2)
		set @s1 = @s1-@s2
	else
		set @s2= @s2-@s1
	end
	print N'Ước chung lớn nhất là:'+ cast(@s2 as nvarchar)
 end
 go
 exec sp_lab5_bai1d 10,5
 --Bài 2
 --Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv
 create proc sp_lab5_bai2a
 @Manv nvarchar(9)
 as
	begin
		select * from nhanvien
		where MANV =@Manv

	end
exec sp_lab5_bai2a '001'
--Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó
 create proc sp_lab5_bai2b
 @MaDa int 
 as
	begin
		select MADA, COUNT(MA_NVIEN) as N'Số nhân viên tham gia' from PHANCONG
		where MADA=@MaDa
		group by MADA
	end
exec sp_lab5_bai2b 3
--Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham
--gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
 create proc sp_lab5_bai2c
 @MaDa int, @Ddiem_DA nvarchar(15)
 as
	begin
		select PHANCONG.MADA,DDIEM_DA ,COUNT(MA_NVIEN) as N'Số nhân viên tham gia' from PHANCONG
		join DEAN on DEAN.MADA=PHANCONG.MADA
		where PHANCONG.MADA=@MaDa and  DDIEM_DA =@Ddiem_DA
		group by PHANCONG.MADA,DDIEM_DA
	end
exec sp_lab5_bai2c 10, N'Hà Nội'
--Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là
--@Trphg và các nhân viên này không có thân nhân.
create proc sp_lab5_bai2d
@Trphg nvarchar(9)
as 
begin
	select *
	from NHANVIEN
	join PHONGBAN on PHONGBAN.TRPHG=NHANVIEN.MANV
	left join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV
	where PHONGBAN.TRPHG= @Trphg
	and 
	THANNHAN.MA_NVIEN is null 
end
exec sp_lab5_bai2d '006'
--Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có
--mã @Mapb hay không
create proc sp_lab5_bai2e
 @Manv nvarchar(9), @Mapb int
 as
 begin
	if exists (select * from NHANVIEN
		join PHONGBAN on PHONGBAN.TRPHG= NHANVIEN.MANV
		where MANV= @Manv and PHONGBAN.MAPHG=@Mapb
	)
	print N'Nhân viên ' +  @Manv+ N'thuộc phòng ' + cast(@Mapb as nvarchar)
	else
	print N'Nhân viên ' +@Manv+ N'không thuộc phòng ' + cast(@Mapb as nvarchar)
		
 end
 exec sp_lab5_bai2e '002',4
 --Bài 3
 --Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng
--tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại
create proc sp_lab5_bai3a
@Mapb int, @Tenpb nvarchar(15), @Trgphg nvarchar(9), @ngaynhanchuc date
as 
begin
	if exists (select * from PHONGBAN where MAPHG =@Mapb)
		print N'Thêm thất bại'
	else
		begin
			insert into PHONGBAN(MAPHG,TENPHG,TRPHG,NG_NHANCHUC)
			values(@Mapb,@Tenpb,@Trgphg,@ngaynhanchuc)
			print N'Thêm thành công'
		end
end
exec sp_lab5_bai3a 11,'CNTT','009','2023-1-5'
--Cập nhật phòng ban có tên CNTT thành phòng IT.
create proc sp_lab5_bai3b
@Mapb int, @Tenpb nvarchar(15), @Trgphg nvarchar(9), @ngaynhanchuc date
as 
begin
	if exists (select * from PHONGBAN where TENPHG ='CNTT')
		begin
		update PHONGBAN set TENPHG='IT'
		where TENPHG ='CNTT'
		print N'Update thành công'
		end
	else
		begin
			insert into PHONGBAN(MAPHG,TENPHG,TRPHG,NG_NHANCHUC)
			values(@Mapb,@Tenpb,@Trgphg,@ngaynhanchuc)
			print N'Thêm thành công'
		end
end
exec sp_lab5_bai3b 11,'CNTT','009','2023-1-5'
--Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
--vào với điều kiện:
select HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG
from NHANVIEN
insert into NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
values(N'Nguyễn',N'Văn',N'Nam','018','2023-6-1',N'Hà Nội','Nam',25000,'004',4)
--
create proc sp_lab5_bai3c
@HONV nvarchar(15),@TENLOT nvarchar(15),@TENNV nvarchar(15),@MANV nvarchar(9),@NGSINH date,
@DCHI nvarchar(30),@PHAI nvarchar(3),@LUONG float,@MA_NQL nvarchar(9)=null ,@PHG int
as
begin
	declare @tuoi int
	set @tuoi =year(GETDATE())-year(@NGSINH)
	if @PHG=(Select MAPHG from PHONGBAN where TENPHG='IT')
		begin 
			if @LUONG>25000
			set @MA_NQL ='009'
			else set @MA_NQL='005'
			if(@PHAI = 'Nam' and(@tuoi >=18 and @tuoi <=65 )) 
			or (@PHAI = N'Nữ' and(@tuoi >=18 and @tuoi <=60 ))
			begin 
			insert into NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
			values(@HONV,@TENLOT,@TENNV,@MANV,@NGSINH,@DCHI,@PHAI,@LUONG,@MA_NQL,@PHG)
			end
			else
			print N'Không thuộc tuổi lao động'
		end
	else
		print N'Không phải phòng ban IT'
end
go
exec sp_lab5_bai3c N'Nguyễn',N'Văn',N'Nam','028','2004-6-1',N'Hà Nội','Nam','25000','004','6'
exec sp_lab5_bai3c N'Nguyễn',N'Văn',N'Nam','028','1906-6-1',N'Hà Nội','Nam','25000','004','6'

select * from PHONGBAN
--Lệnh xóa 
 Create Procedure ThanNhan_Delete(
		@MaNV  int
)
As
Begin
	Delete From THANNHAN Where MA_NVIEN=@MaNV
End
exec ThanNhan_Delete 1

