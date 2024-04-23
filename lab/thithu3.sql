use master
go
create database thithu3
go
use thithu3
go
create table Phong(
MaPhg varchar(5) primary key,
TenPhg nvarchar(5) not null,
NamBatDau date not null,
)
create table CongNhan(
MaNV varchar(5) primary key,
HoTen nvarchar(5) not null,
NgaySinh date not null,
GioiTinh nvarchar(10) not null
)
create table KhenThuong(
MaNV varchar(5) not null,
MaPhg varchar(5) not null,
SoTien decimal(18,2) not null,
primary key (MaNV,MaPhg),
foreign key (MaNV) references CongNhan(MaNV),
foreign key (MaPhg) references Phong(MaPhg)
)
--
create proc ThemPhong
@MaPhg varchar(5),
@TenPhg nvarchar(5),
@NamBatDau date
as
begin
if(@MaPhg is null) or (@TenPhg is null) or (@NamBatDau is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if exists (select 1 from Phong where MaPhg=@MaPhg) 
begin
raiserror ('Ma phong da ton tai',16,1)
return;
end
else
begin
insert into Phong(MaPhg,TenPhg,NamBatDau)
values(@MaPhg,@TenPhg,@NamBatDau)
end
end
--
create proc ThemCongNhan
@MaNV varchar(5),
@HoTen nvarchar(5),
@NgaySinh date,
@GioiTinh nvarchar(10)
as
begin
if(@MaNV is null) or (@HoTen is null) or (@NgaySinh is null) or (@GioiTinh is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if exists (select 1 from CongNhan where MaNV=@MaNV) 
begin
raiserror ('Ma nhan vien da ton tai',16,1)
return;
end
else
begin
insert into CongNhan(MaNV,HoTen,NgaySinh,GioiTinh)
values(@MaNV,@HoTen,@NgaySinh,@GioiTinh)
end
end

--
create proc ThemKhenThuong
@MaNV varchar(5),
@MaPhg varchar(5),
@SoTien decimal(18,2)
as
begin
if(@MaNV is null) or (@MaPhg is null) or (@SoTien is null) 
begin
raiserror ('Thieu du lieu ',16,1)
return;
end
if not exists (select 1 from CongNhan where MaNV=@MaNV) 
begin
raiserror ('Ma nhan vien khong ton tai',16,1)
return;
end
if not exists (select 1 from Phong where MaPhg=@MaPhg) 
begin
raiserror ('Ma phong khong ton tai',16,1)
return;
end
else
begin
insert into KhenThuong(MaNV,MaPhg,SoTien)
values(@MaNV,@MaPhg,@SoTien)
end
end
--
exec ThemPhong 1,'IT','2023-1-2'
exec ThemPhong 2,'CTCN','2023-1-2'
exec ThemPhong 3,'Ke Toan','2023-1-2'

exec ThemCongNhan 1,'Nguyen Van a','1999-5-4','Nam'
exec ThemCongNhan 2,'Nguyen Van b','1999-5-5','Nam'
exec ThemCongNhan 3,'Nguyen Van c','1998-5-6','NU'

exec ThemKhenThuong 1,1,19000
exec ThemKhenThuong 2,3,20000
exec ThemKhenThuong 3,2,18000

--viet ham
create function FU_TimMaNV
(@MaNV varchar(5),
@HoTen nvarchar(5),
@NgaySinh date,
@GioiTinh nvarchar(10))
returns varchar(5)
as
begin
return(
select MaNV from CongNhan where MaNV=@MaNV
)
end

--
print 'Ma NV la: ' + convert(varchar,dbo.FU_TimMaNV(1,'Nguyen Van a','1999-5-4','Nam'))

create view top2_NV
as
select top 2 with ties 
KhenThuong.MaNV,CongNhan.HoTen, sum(KhenThuong.SoTien) as 'Tong tien'
from KhenThuong
join CongNhan on KhenThuong.MaNV=CongNhan.MaNV
group by KhenThuong.MaNV,KhenThuong.SoTien,CongNhan.HoTen
order by sum(KhenThuong.SoTien) desc

select * from top2_NV

create proc xoa
@tongtien decimal(18,2)
as
begin
begin tran
begin try
declare @tblXoa table (MaNV varchar(5))
insert into @tblXoa
select MaNV from KhenThuong 
group by MaNV
having sum(SoTien)>@tongtien
delete from khenthuong where MaNV in(select MaNV from @tblXoa)
delete from CongNhan where MaNV in(select MaNV from @tblXoa)
print 'Xoa thanh cong'
Commit
end try
begin catch 
rollback tran
print 'Xoa khong thanh cong'
end catch
end
select * from KhenThuong
exec xoa 17000