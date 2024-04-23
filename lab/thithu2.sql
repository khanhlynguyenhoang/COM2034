use master
go
create database thithu2
go
use thithu2
go
create table SanPham(
	MaSanPham varchar(5) primary key,
	TenSanPham nvarchar(100) not null,
	GiaHienHanh decimal(18,2) not null,
	SoLuongTon int not null
)
create table HoaDon(
	MaHoaDon varchar(5) primary key,
	NgayLap date not null,
	SoDienThoai varchar(11) not null
)
create table HoaDonCT(
	MaSanPham varchar(5) not null,
	MaHoaDon varchar(5) not null,
	GiaMua decimal(18,2) not null,
	SoLuongMua int not null,
	primary key (MaSanPham,MaHoaDon),
	foreign key (MaSanPham) references SanPham(MaSanPham),
	foreign key (MaHoaDon) references HoaDon(MaHoaDon)
)
--Tạo Thủ tục THÊM dữ liệu cho 3 bảng
create proc ThemSanPham
@MaSanPham varchar(5),
@TenSanPham nvarchar(100),
@GiaHienHanh decimal(18,2),
@SoLuongTon int
as 
begin
if(@MaSanPham is null) or (@TenSanPham is null) or (@GiaHienHanh is null) or (@SoLuongTon is null) 
begin
raiserror ('Thieu du lieu ',16,1)
end
if exists (select 1 from SanPham where MaSanPham=@MaSanPham)
begin
raiserror ('Ma san pham da ton tai ',16,1)
end
else
begin
insert into SanPham(MaSanPham,TenSanPham,GiaHienHanh,SoLuongTon)
values(@MaSanPham,@TenSanPham,@GiaHienHanh,@SoLuongTon)
end
end
--
create proc ThemHoaDon
@MaHoaDon varchar(5),
@NgayLap date,
@SoDienThoai varchar(11)
as 
begin
if(@MaHoaDon is null) or (@NgayLap is null) or (@SoDienThoai is null) 
begin
raiserror ('Thieu du lieu ',16,1)
end
if exists (select 1 from HoaDon where MaHoaDon=@MaHoaDon)
begin
raiserror ('Ma hoa don da ton tai ',16,1)
end
else
begin
insert into HoaDon(MaHoaDon,NgayLap,SoDienThoai)
values(@MaHoaDon,@NgayLap,@SoDienThoai)
end
end
--
create proc ThemHoaDomCT
@MaSanPham varchar(5),
@MaHoaDon varchar(5),
@GiaMua decimal(18,2),
@SoLuongMua int
as 
begin
if(@MaSanPham is null) or (@MaHoaDon is null) or (@GiaMua is null) or (@SoLuongMua is null) 
begin
raiserror ('Thieu du lieu ',16,1)
end
if not exists (select 1 from SanPham where MaSanPham=@MaSanPham)
begin
raiserror ('Ma san pham khong ton tai ',16,1)
end
if not exists (select 1 from HoaDon where MaHoaDon=@MaHoaDon)
begin
raiserror ('Ma hoa don khong ton tai ',16,1)
end
else
begin
insert into HoaDonCT(MaSanPham,MaHoaDon,GiaMua,SoLuongMua)
values(@MaSanPham,@MaHoaDon,@GiaMua,@SoLuongMua)
end
end
--Them du lieu
exec ThemSanPham 1,'Ao phong',160000,15
exec ThemSanPham 2,'Ao khoac',170000,15
exec ThemSanPham 3,'Quan bo',180000,15

exec ThemHoaDon 1,'2023-6-5','0987456321'
exec ThemHoaDon 2,'2023-6-6','0987456322'
exec ThemHoaDon 3,'2023-6-7','0987456323'

exec ThemHoaDomCT 1,1,6,160000
exec ThemHoaDomCT 2,3,5,180000
exec ThemHoaDomCT 3,2,2,170000
select * from HoaDonCT
--V_HDCT_Full
create view V_HDCT_Full
as
select MaSanPham,MaHoaDon,SoLuongMua,GiaMua, SoLuongMua*GiaMua as 'Thanh tien' 
from HoaDonCT

select * from dbo.V_HDCT_Full

--Tạo và sử dụng Khung nhìn có tên: V_TopSP
--Hiển thị 10 sản phẩm bán chạy nhất theo tháng kèm số lượng.
create view V_TopSP
as
select top 10 with ties
HoaDonCT.MaHoaDon,HoaDonCT.MaSanPham, sum(SoLuongMua) as 'So luong san pham', month(hoadon.ngaylap) as 'Thang ban'
from HoaDonCT
join HoaDon on HoaDon.MaHoaDon=HoaDonCT.MaHoaDon
join SanPham on SanPham.MaSanPham=HoaDonCT.MaSanPham
group by HoaDonCT.MaSanPham ,HoaDonCT.MaHoaDon,hoadon.ngaylap,HoaDonCT.MaSanPham
order by count(HoaDonCT.MaSanPham) desc

select * from dbo.V_TopSP
select * from HoaDonCT

--Tạo và sử dụng Hàm có tên: F_Vnd2Usd có tham số là giá tiền đơn vị VNĐ.
--Yêu cầu trả về giá tiền đơn vị USD. Biết (1 USD = 23.000 VNĐ)
create function F_Vnd2Usd(@TienVND decimal(18,2))
returns decimal(18,2)
as 
begin
declare @TienUSD int;
set @TienUSD=@TienVND/23000;
return @TienUSD
end
--
print 'So tien la: '+convert(nvarchar,dbo.F_Vnd2Usd(46000))
--Tạo và sử dụng Thủ tục có tên SP_XoaSP truyền vào mã sản phẩm
--Thực hiện Xóa sản phẩm ở các bảng liên quan
create proc SP_XoaSP
@MaSanPham varchar(5)
as
begin
	begin tran
	delete from HoaDonCT where MaSanPham=@MaSanPham
	delete from SanPham where MaSanPham=@MaSanPham
	
	rollback tran
	print 'Xoa thanh cong'
end
--
exec SP_XoaSP 1
select * from SanPham
