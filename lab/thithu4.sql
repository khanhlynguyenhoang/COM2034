use master
go
create database thithu4
go
use thithu4
go 
create table VATTU(
MaVT varchar(5) primary key,
TenVT nvarchar(100) not null,
DVTinh decimal(18,2) not null
)
create table PHIEUXUAT(
SoPX varchar(5) primary key,
NgayXuat date not null,
)
create table CTPXuat(
SoPX varchar(5) not null,
MaVT varchar(5) not null,
SLXuat int not null,
DonGia decimal(18,2) not null,
primary key (SoPX,MaVT),
foreign key (SoPX) references PHIEUXUAT(SoPX),
foreign key (MaVT) references VATTU(MaVT)
)
--
create proc ThemVT
@MaVT varchar(5),
@TenVT nvarchar(100),
@DVTinh decimal(18,2)
as
begin
if(@MaVT is null) or (@TenVT is null) or (@DVTinh is null) 
begin
raiserror('Thieu du lieu',16,1)
end
if exists (select 1 from VATTU where MaVT=@MaVT) 
begin
raiserror('MaVt da ton tai',16,1)
end
else
begin
insert into VATTU(MaVT,TenVT,DVTinh)
values(@MaVT,@TenVT,@DVTinh)
print 'Them thanh cong'
end
end
--
create proc ThemPX
@SoPX varchar(5),
@NgayXuat date
as
begin
if(@SoPX is null) or (@NgayXuat is null) 
begin
raiserror('Thieu du lieu',16,1)
end
if exists (select 1 from PHIEUXUAT where SoPX=@SoPX) 
begin
raiserror('So PX da ton tai',16,1)
end
else
begin
insert into PHIEUXUAT(SoPX,NgayXuat)
values(@SoPX,@NgayXuat)
print 'Them thanh cong'
end
end
--
create proc ThemCTPX
@SoPX varchar(5),
@MaVT varchar(5),
@SLXuat int,
@DonGia decimal(18,2)
as
begin
if(@SoPX is null) or (@MaVT is null) or (@SLXuat is null) or (@DonGia is null) 
begin
raiserror('Thieu du lieu',16,1)
end
if not exists (select 1 from PHIEUXUAT where SoPX=@SoPX) 
begin
raiserror('So PX khong ton tai',16,1)
end
if not exists (select 1 from VATTU where MaVT=@MaVT) 
begin
raiserror('MaVt khong ton tai',16,1)
end
else
begin
insert into CTPXuat(SoPX,MaVT,SLXuat,DonGia)
values(@SoPX,@MaVT,@SLXuat,@DonGia)
print 'Them thanh cong'
end
end
--
exec ThemVT 1,'Gach',12
exec ThemVT 2,'Xi mang',18
exec ThemVT 3,'Thep',15

exec ThemPX 1,'2023-6-1'
exec ThemPX 2,'2023-6-10'
exec ThemPX 3,'2023-6-15'

exec ThemCTPX 1,1,15,16000
exec ThemCTPX 2,3,10,18000
exec ThemCTPX 3,2,19,17000
--Viết hàm các tham số đầu vào tương ứng với các cột của bảng VATTU. Hàm này trả về
--MaVT thỏa mãn các giá trị được truyền tham số
create function FU_VT
(@MaVT varchar(5),
@TenVT nvarchar(100),
@DVTinh decimal(18,2))
returns varchar(5)
as
begin
return(
select MaVT from VATTU
where MaVT = @MaVT
)
end

print 'Ma vt can tim la: ' + convert(nvarchar,dbo.FU_VT(1,'Gach',12))
--Tạo View lưu thông tin của TOP 2 phiếu xuất có ngày xuất gần nhất, gồm các thông tin
--sau: MaVT, TenVT, DVTinh, NgayXuat, SLXuat
create view top2_thithu4
as
select top 2 with ties
CTPX.MaVT,VATTU.TenVT,VATTU.DVTinh,SLXuat, NgayXuat
from CTPXuat CTPX
join VATTU on VATTU.MaVT=CTPX.MaVT
join PHIEUXUAT on PHIEUXUAT.SoPX=CTPX.SoPX
order by DATEDIFF(Day,NgayXuat,GETDATE()) 
select * from top2_thithu4
--Viết một SP nhận một tham số đầu vào là SLXuat. SP này thực hiện thao tác xóa thông
--tin vật tư và phiếu xuất tương ứng
create proc XoaVT
@SLXuat int
as
begin
	begin tran
		begin try
			declare @tblXoa table(MaVT varchar(5) , SoPX varchar(5))
			insert into @tblXoa
			select MaVT , SoPX from CTPXuat where SLXuat=@SLXuat
			delete from CTPXuat where( MaVT in( select MaVT from @tblXoa) or SoPX in( select SoPX from @tblXoa))
			delete from VATTU where MaVT in( select MaVT from @tblXoa)
			delete from PHIEUXUAT where SoPX in( select SoPX from @tblXoa)
			commit
			print 'Xoa thanh cong'
		end try
		begin catch
			rollback 
			print 'Xoa khong thanh cong'
		end catch
end

select * from CTPXuat
exec XoaVT 15