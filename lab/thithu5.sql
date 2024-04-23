use master 
go
create database thithu6
go
use thithu6
go
create table MatHang(
MaH int primary key,
TenH nvarchar(100) not null, 
LoaiH nvarchar(100) not null, 
)
create table DONHANG (
SoDH int primary key,
NgayDH date not null, 
NgayGH date not null, 
)
create table CTDH(
SoDH int not null,
MaH int not null, 
SoLuong  int not null,
DVTinh nvarchar(100) not null,
primary key (SoDH,MaH),
foreign key (SoDH) references DonHang(SoDH),
foreign key (MaH) references MatHang(MaH)
)
--
--Tạo Stored Procedure (SP) với các tham số đầu vào phù hợp
create proc ThemMatHang
@MaH int,
@TenH nvarchar(100),
@LoaiH nvarchar(100)
as
begin
if(@MaH is null) or (@TenH is null) or (@LoaiH is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if exists (select 1 from MatHang where MaH = @MaH) 
begin
raiserror ('Ma hang da ton tai ',16,1)
return;
end
else
begin
insert into MatHang(MaH,TenH,LoaiH)
values(@MaH,@TenH,@LoaiH)
end
end
--
create proc ThemDonHang
@SoDH int,
@NgayDH date,
@NgayGH date
as
begin
if(@SoDH is null) or (@NgayDH is null) or (@NgayGH is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if exists (select 1 from DONHANG where SoDH = @SoDH) 
begin
raiserror ('So don hang da ton tai ',16,1)
return;
end
else
begin
insert into DONHANG(SoDH,NgayDH,NgayGH)
values(@SoDH,@NgayDH,@NgayGH)
end
end
--
create proc ThemCTHD
@SoDH int,
@MaH int,
@SoLuong  int,
@DVTinh nvarchar(100)
as
begin
if(@SoDH is null) or (@MaH is null) or (@SoLuong is null) or (@DVTinh is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if not exists (select 1 from DONHANG where SoDH = @SoDH) 
begin
raiserror ('So don hang khong ton tai ',16,1)
return;
end
if not exists (select 1 from MatHang where MaH = @MaH) 
begin
raiserror ('Ma hang khong ton tai ',16,1)
return;
end
else
begin
insert into CTDH(SoDH,MaH,SoLuong,DVTinh)
values(@SoDH,@MaH,@SoLuong,@DVTinh)
print ' Them thanh cong'
end
end
--
exec ThemMatHang 1,'Nuoc giat','Gia dung'
exec ThemMatHang 2,'Nuoc xa','Gia dung'
exec ThemMatHang 3,'Ao phong','thoi trang'

exec ThemDonHang 1,'2023-6-15','2023-6-16'
exec ThemDonHang 2,'2023-6-14','2023-6-16'
exec ThemDonHang 3,'2023-6-13','2023-6-16'

exec ThemCTHD 1,1,15,'can'
exec ThemCTHD 2,2,20,'can'
exec ThemCTHD 3,3,17,'chiec'
exec ThemCTHD 3,2,17,'can'
--Viết hàm các tham số đầu vào tương ứng với các cột của bảng MATHANG . Hàm này trả
--về MaH thỏa mãn các giá trị được truyền tham số.
create function FU_MaH
(
@MaH int,
@TenH nvarchar(100),
@LoaiH nvarchar(100)
)
returns int 
as
begin
return(
select MaH from MatHang
where MaH=@MaH
)
end

print 'Ma Hang can tim la: ' + convert(nvarchar,dbo.FU_MaH(1,'Nuoc giat','Gia dung'))
--
-- Tạo hàm
CREATE FUNCTION TongSoMatHang(@MaHoaDon INT)
RETURNS INT
AS
BEGIN
DECLARE @SoMatHang INT;

    SELECT @SoMatHang = COUNT(*)
    FROM CTDH
    WHERE MaH = @MaHoaDon;

    RETURN @SoMatHang;
END;
GO
-- Sử dụng hàm
DECLARE @MaHoaDon INT = 1;
DECLARE @TongSoMatHang INT;

SELECT @TongSoMatHang = dbo.TongSoMatHang(@MaHoaDon);

PRINT N'Tổng số mặt hàng của hóa đơn ' + CAST(@MaHoaDon AS NVARCHAR) + ' là ' + CAST(@TongSoMatHang AS NVARCHAR);
--Tạo View lưu thông tin của TOP 2 chi tiết đơn hàng có số lượng nhất, gồm các thông tin
--sau: MaH, TenH, LoaiH, NgayDH, NgayGH, SoLuong.
create view V_TOP2
as
select top 2 with ties CTDH.MaH, TenH,LoaiH,NgayDH,NgayGH,SUM(SoLuong) as Tongluongmua
from CTDH
join MatHang on MatHang.MaH=CTDH.MaH
join DONHANG on DONHANG.SoDH=CTDH.SoDH
group by CTDH.MaH, TenH,LoaiH,NgayDH,NgayGH,SoLuong
order by SUM(SoLuong) desc

select * from dbo.V_TOP2
--Viết một SP nhận một tham số đầu vào là SoLuong. SP này thực hiện thao tác xóa thông
--tin mặt hàng và đơn hàng tương ứng.
create proc xoaDH
@SoLuong int
as
begin
begin tran
begin try
declare @tblXoa table(MaH int,SoDH int)
insert into @tblXoa
select MaH,SoDH from CTDH where SoLuong=@SoLuong
delete from CTDH where (MaH in (select MaH from @tblXoa) or SoDH in (select SoDH from @tblXoa))
delete from MatHang where MaH in (select MaH from @tblXoa)
delete from DONHANG where SoDH in (select SoDH from @tblXoa)
commit
print 'Xoa thanh cong'
end try
begin catch
rollback 
print 'Xoa khong thanh cong'
end catch
end
--
declare @SoLuong int =17
exec xoaDH @soluong
 
 select * from CTDH