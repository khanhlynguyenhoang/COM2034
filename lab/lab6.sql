--Lab 6
--Bài 1
--Viết trigger DML:
--Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì
--xuất thông báo “luong phải >15000"
create trigger trg_insert_NhanVien on NhanVien
for insert 
as if(select luong from inserted )<15000
	begin
	print N'Lương phải lớn hơn 15000'
	rollback transaction
	end

select * from NHANVIEN
insert into NHANVIEN
values(N'Nguyễn',N'Văn ','V','026','2004-10-6',N'Hà Nội',N'Nam',14000,null,1)
--Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.
create trigger trg_bai1b on NhanVien
for insert 
as 
	declare @tuoi int
	set @tuoi =year(GETDATE())- (select year(NgSinh) from inserted)
	if(@tuoi <18 or @tuoi>65)
		begin
			print N'Tuổi không hợp lệ '
			rollback transaction
		end
insert into NHANVIEN
values(N'Nguyễn',N'Văn ','V','022','2006-10-6',N'Hà Nội',N'Nam',16000,null,1)
-- Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM
create trigger trg_bai1c on NhanVien
for update
as	
	if(select dchi from inserted ) like '%HCM%' or (select dchi from inserted ) like N'%Hồ Chí Minh%'
		begin
			print N'Địa chỉ không hợp lệ'
			rollback transaction
		end
update NhanVien set TENNV='Ly' where MANV='001'
--Bài 2
--Viết các Trigger AFTER:
--Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
--thêm mới nhân viên.
create trigger trg_bai2a on NhanVien
after insert 
as
begin
	declare @nu int =(select count(*) from NHANVIEN where PHAI like N'nữ')
	print N'Số lượng nhân viên nữ: '+ cast(@nu as nvarchar)
	declare @nam int =(select count(*) from NHANVIEN where PHAI like N'nam')
	print N'Số lượng nhân viên nam: '+ cast(@nam as nvarchar)
end
insert into NHANVIEN
values(N'Nguyễn',N'Văn ','V','111','2004-10-6',N'Hà Nội',N'Nam',16000,null,1)
--Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
--cập nhật phần giới tính nhân viên

create trigger trg_bai2b on NhanVien
after update 
as
begin
	if update(Phai)
		begin
			declare @nu int =(select count(*) from NHANVIEN where PHAI like N'nữ')
			print N'Số lượng nhân viên nữ: '+ cast(@nu as nvarchar)
			declare @nam int =(select count(*) from NHANVIEN where PHAI like N'nam')
			print N'Số lượng nhân viên nam: '+ cast(@nam as nvarchar)
		end
end

update NHANVIEN set PHAI=N'Nữ' where MANV='024'
--Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng
--DEAN
create trigger trg_bai2c on DeAn
after delete
as
begin
	select  MA_NVIEN, count(MADA) as N'số lượng đề án' from PHANCONG
	group by MA_NVIEN
end

select * from DEAN
delete from DEAN where MADA=21
--Bài 3
--Viết các Trigger INSTEAD OF
--Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân
--viên trong bảng nhân viên
create trigger trg_Bai3a on NhanVien
instead of delete
as
begin
	delete from THANNHAN where MA_NVIEN in(select Manv  from deleted)--xóa bảng con
	delete from NHANVIEN where MANV in(select Manv  from deleted)-- xóa bảng cha
end
delete from NHANVIEN where MANV=017
--Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA
--là 1.
alter trigger trg_Bai3b on NhanVien
after insert
as
begin
	insert into PHANCONG
	values ((select manv from inserted),1,1,10)
end

insert into NHANVIEN
values(N'Nguyễn',N'Văn ','An','034','2004-10-6',N'Hà Nội',N'Nam',16000,'004',1)
select * from PHANCONG
select * from NHANVIEN