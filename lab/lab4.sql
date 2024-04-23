--Bài 1
--	Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, 
--cột thứ 2 nhận giá trị Với mỗi câu truy vấn cần thực hiện bằng 2 cách, dùng cast và convert.
--dùng cast
declare @tbThongKe table (MaPB int, LuongTB float)
insert into @tbThongKe
select PHG, Cast (AVG(LUONG) as decimal(10,2)) from NHANVIEN
group by PHG
--select * from  @tbThongKe

select TENNV,PHG,LUONG,LuongTB,
TinhTrang = case
when LUONG > LuongTB then N'Không tăng lương'
else N'Tăng lương'
end
 from NHANVIEN a
inner join @tbThongKe b  
on a.PHG=b.MaPB
--dùng convert
declare @tbThongKe table (MaPB int, LuongTB float)
insert into @tbThongKe
select PHG, CONVERT(decimal(10,2),AVG(LUONG)) from NHANVIEN
group by PHG
select TENNV,PHG,LUONG,LuongTB,
TinhTrang = case
when LUONG > LuongTB then N'Không tăng lương'
else N'Tăng lương'
end
 from NHANVIEN a
inner join @tbThongKe b  
on a.PHG=b.MaPB
--	Viết chương trình phân loại nhân viên dựa vào mức lương.
--•	Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì xếp loại “nhanvien”, 
--ngược lại xếp loại “truongphong”
--dùng cast
declare @tbXepLoaiNV table (MaPB int, LuongTB float)
insert into @tbXepLoaiNV
select PHG, Cast (AVG(LUONG) as decimal(10,2)) from NHANVIEN
group by PHG
select TENNV,PHG,LUONG,LuongTB,
ChucVu = case
when LUONG > LuongTB then N'Trưởng phòng'
else N'Nhân viên'
end
 from NHANVIEN a
inner join @tbXepLoaiNV b  
on a.PHG=b.MaPB
--dùng convert
declare @tbXepLoaiNV table (MaPB int, LuongTB float)
insert into @tbXepLoaiNV
select PHG, CONVERT(decimal(10,2),AVG(LUONG)) from NHANVIEN
group by PHG
select TENNV,PHG,LUONG,LuongTB,
ChucVu = case
when LUONG > LuongTB then N'Trưởng phòng'
else N'Nhân viên'
end
 from NHANVIEN a
inner join @tbXepLoaiNV b  
on a.PHG=b.MaPB

--	Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
select TENNV =case
when PHAI= 'Nam' then 'Mr.'+TENNV 
when PHAI= N'Nữ' then 'Ms.'+TENNV 
else 'Free sex.'+ TENNV
end
from NHANVIEN
select * from NHANVIEN
--	Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
select TENNV,LUONG,
Thue=case 
		when LUONG between 0 and 25000 then LUONG* 0.1
		when LUONG between 25000 and 30000 then LUONG* 0.12
		when LUONG between 30000 and 40000 then LUONG* 0.15
		when LUONG between 40000 and 50000 then LUONG* 0.20
		else LUONG *0.25
	end
from NHANVIEN
--Bài 2
--	Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
declare @machan int=2, @dem int;
set @dem=(select COUNT(*) from NHANVIEN)
while(@machan<@dem)
begin
	select MANV, HONV, TENLOT, TENNV from NHANVIEN
	where Cast(MANV as int)=@machan;
	set @machan= @machan +2 ;
end
--	Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng không tính nhân viên có MaNV là 4.
declare @machan int=2, @dem int;
set @dem=(select COUNT(*) from NHANVIEN)
while(@machan<@dem)
begin
	if @machan=4
	begin
	set @machan = @machan+2;
	continue;
	end
	select MANV, HONV, TENLOT, TENNV from NHANVIEN
	where Cast(MANV as int)=@machan;
	set @machan= @machan +2 ;
end
--Bai 3
--	Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
--•	Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
	begin try
		insert PHONGBAN(TENPHG,MAPHG,TRPHG,NG_NHANCHUC)
		values('Ke hoach ',106,'010','2022-5-24')
		print 'Them thanh cong'
	end try
	begin catch
		print 'Loi' + convert(varchar, Error_number(),1)
		+ '=>' + Error_message()
	end catch
--	Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng RAISERROR để thông báo lỗi.
	
	begin try
		declare @a int =5, @b int =0, @result int;
		set @result = @a/@b;
	end try
	begin catch
		declare @ErMessage nvarchar(2048),
				@ErSeverity int,
				@ErState int
		select @ErMessage =ERROR_MESSAGE(),
				@ErSeverity = ERROR_SEVERITY(),
				@ErState = ERROR_STATE()
		raiserror (@ErMessage,@ErSeverity,@ErState)
	end catch

--4.	Bài tập: kết quả học tập
Declare @Diem float
Set @Diem = 9
Select 
CASE
WHEN @Diem >= 5 AND @Diem < 6.5 THEN N'Học lực trung bình'
WHEN @Diem >= 6.5 AND @Diem < 7 THEN N'Học lực trung bình khá'
WHEN @Diem >= 7 AND @Diem < 8 THEN N'Học lực khá'
WHEN @Diem >= 8 AND @Diem < 9 THEN N'Học lực giỏi'
WHEN @Diem >= 9 AND @Diem <= 10 THEN N'Học lực xuất sắc'
Else N'Học lực yếu'
END AS N'Kết quả học lực'