create database GIAOHANG
use GiaoHang
create table KhachHang(
MaKH varchar(5) primary key,
HoTenKH nvarchar(100) not null,
DChiKH nvarchar(100) not null,
GTinh nvarchar(3) not null,
DThoaiKH varchar(11) not null
)
go
create table NhanVien(
MaNV varchar(5) primary key,
HoTenNV nvarchar(100) not null,
DChiNV nvarchar(100) not null,
GTinh nvarchar(3) not null,
DThoaiNV varchar(11) not null
)
go
create table DonHang(
MaKH varchar(5) not null,
MaNV varchar(5) not null,
NgayDH date not null,
NgayGH date not null,
primary key(MaKH,MaNV),
foreign key (MaKH) references KhachHang(MaKH),
foreign key (MaNV) references NhanVien(MaNV),
)
--Tạo Stored Procedure (SP) với các tham số đầu vào phù hợp.
--
create proc ThemKH
@MaKH varchar(5),
@HoTenKH nvarchar(100),
@DChiKH nvarchar(100),
@GTinh nvarchar(3),
@DThoaiKH varchar(11)
as
begin
	if(@MaKH is null) or (@HoTenKH is null) or (@DChiKH is null) or (@GTinh is null) or (@DThoaiKH is null) 
		begin
		raiserror('Thieu du lieu dau vao',16,1)
		end
	if exists(select 1 from KhachHang where MaKH=@MaKH) 
		begin
		raiserror('Thieu du lieu dau vao',16,1)
		end
	else
		begin
		insert into KhachHang(MaKH,HoTenKH,DChiKH,GTinh,DThoaiKH)
		values(@MaKH,@HoTenKH,@DChiKH,@GTinh,@DThoaiKH)
		print 'Them thanh cong'
		end
end
--
create proc ThemNhanVien
@MaNV varchar(5),
@HoTenNV nvarchar(100),
@DChiNV nvarchar(100),
@GTinh nvarchar(3),
@DThoaiNV varchar(11)
as
begin
	if(@MaNV is null) or (@HoTenNV is null) or (@DChiNV is null) or (@GTinh is null) or (@DThoaiNV is null) 
		begin
		raiserror('Thieu du lieu dau vao',16,1)
		end
	if exists(select 1 from NhanVien where MaNV=@MaNV) 
		begin
		raiserror('Ma NV da ton tai',16,1)
		end
	else
		begin
		insert into NhanVien(MaNV,HoTenNV,DChiNV,GTinh,DThoaiNV)
		values(@MaNV,@HoTenNV,@DChiNV,@GTinh,@DThoaiNV)
		print 'Them thanh cong'
		end
end
--
create proc ThemDonHang
@MaNV varchar(5),
@MaKH varchar(5),
@NgayDH date,
@NgayGH date
as
begin
	if(@MaNV is null) or (@MaKH is null) or (@NgayDH is null) or (@NgayGH is null) 
		begin
		raiserror('Thieu du lieu dau vao',16,1)
		end
	if not exists(select 1 from NhanVien where MaNV=@MaNV) 
		begin
		raiserror('Ma NV khong ton tai',16,1)
		end
	if not exists(select 1 from KhachHang where MaKH=@MaKH) 
		begin
		raiserror('Ma KH khong ton tai',16,1)
		end
	else
		begin
		insert into DonHang(MaNV,MaKH,NgayDH,NgayGH)
		values(@MaNV,@MaKH,@NgayDH,@NgayGH)
		print 'Them thanh cong'
		end
end
--them du lieu
exec ThemKH 'KH1','Nguyen van a','Ha Noi','Nam','0987456321'
exec ThemKH 'KH2','Nguyen van b','Bac Ninh','Nu','0987456321'
exec ThemKH 'KH3','Nguyen van c','Ha Noi','Nam','0987456321'

exec ThemNhanVien 'NV1','Nguyen van a','Ha Noi','Nam','0987456321'
exec ThemNhanVien 'NV2','Nguyen van b','Bac Ninh','Nu','0987456321'
exec ThemNhanVien 'NV3','Nguyen van c','Ha Noi','Nam','0987456321'

exec ThemDonHang 'NV1','KH1','2023-6-5','2023-6-6'
exec ThemDonHang 'NV2','KH3','2023-6-10','2023-6-11'
exec ThemDonHang 'NV3','KH2','2023-6-12','2023-6-14'
select * from DonHang
--Viết hàm các tham số đầu vào tương ứng với các cột của bảng KHACHHANG. Hàm này
--trả về MaKH thỏa mãn các giá trị được truyền tham số.
create function FU_TimKH
(@MaKH varchar(5),
@HoTenKH nvarchar(100),
@DChiKH nvarchar(100),
@GTinh nvarchar(3),
@DThoaiKH varchar(11))
returns varchar(5)
as
begin
return(
select MaKH from KhachHang
where MaKH=@MaKH
)
end
print 'Ma Kh can tim la: '+convert (varchar(5),dbo.FU_TimKH('KH1','Nguyen van a','Ha Noi','Nam','0987456321'))
--Tạo View lưu thông tin của TOP 2 đơn hàng có ngày đặt gần nhất, gồm các thông tin sau:
--MaKH, HoTenKH, DChiKH, DThoaiKH, MaNV, HoTenNV, DThoaiNV
create view DH_top2


--Viết một SP nhận một tham số đầu vào là NgayGH. SP này thực hiện thao tác xóa thông
--tin của khách hàng và nhân viên giao hàng tương ứng
create proc XoaDH
@NgayGH date
as
begin
	begin tran
	(
	select NgayGH from DonHang
	join KhachHang on KhachHang.MaKH=DonHang.MaKH
	join NhanVien on NhanVien.MaNV=DonHang.MaNV
	)
	rollback tran
end