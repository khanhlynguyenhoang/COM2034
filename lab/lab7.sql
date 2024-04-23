--Bài 1: Viết các hàm
--cú pháp
/*create function <tên hàm>
returns <KDL trả về>
as
begin
	code của hàm
end*/
--1. Nhập vào MaNV cho biết tuổi của nhân viên này

--DROP FUNCTION Fu_MaNv_Tuoi

CREATE FUNCTION Fu_MaNv_Tuoi
(@MaNV NVARCHAR(9)) --Xem kiểu dữ liệu và miền giá trị trong bảng nhân viên
RETURNS INT
AS 
BEGIN
	RETURN (SELECT DATEDIFF(YEAR, NGSINH, GETDATE()) + 1 --Có thể dùng: YEAR(getdate())-YEAR(NGSINH)
	FROM dbo.NHANVIEN WHERE MANV = @MaNV);
END;

--Gọi hàm
SELECT  dbo.Fu_MaNv_Tuoi('005');
PRINT N'Tuổi của bạn là: ' + CONVERT(NVARCHAR, dbo.Fu_MaNv_Tuoi('005'))

--2.Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia

--DROP FUNCTION Fu_MaNv_SoLuongDeAn (Xóa function)
--Tạo function
CREATE FUNCTION Fu_MaNv_SoLuongDeAn
(@MaNV NVARCHAR(9)) 
RETURNS INT
AS 
BEGIN
	RETURN (
		select COUNT(PHANCONG.MADA) 
		FROM PHANCONG
		where PHANCONG.MA_NVIEN=@MaNV
		);
END;
--gọi hàm
SELECT  dbo.Fu_MaNv_SoLuongDuAn('009');
PRINT N'Số lượng đề án tham gia: ' + CONVERT(NVARCHAR, dbo.Fu_MaNv_SoLuongDeAn('009'))
--3. Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái

--drop function FU_NvPhai (@phai nvarchar(3))
--Tạo hàm
CREATE FUNCTION FU_NvPhai (@phai nvarchar(3))
returns int 
as 
begin
	return(
		select COUNT(phai) from NHANVIEN where NHANVIEN.PHAI=@phai
	)
end
--gọi hàm
PRINT N'Số lượng nhân viên nam: ' + CONVERT(NVARCHAR, dbo.FU_NvPhai('Nam'))
PRINT N'Số lượng nhân viên nữ: ' + CONVERT(NVARCHAR, dbo.FU_NvPhai(N'Nữ'))

--4.Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
--họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
--của phòng đó.

--DROP FUNCTION FU_Phg_AvgLuong

--Tạo hàm
create function FU_Phg_AvgLuong (@tenPhong nvarchar(15))
returns table 
as
	return(
	select NHANVIEN.HONV,NHANVIEN.TENLOT,NHANVIEN.TENNV 
	from NHANVIEN
	where LUONG>(
		select avg(LUONG) from NHANVIEN where PHG=(
			select MAPHG from PHONGBAN where TENPHG=@tenPhong
		)
	)
	)
	--gọi hàm
	select * from FU_Phg_AvgLuong('IT')
--5.Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng
--và số lượng đề án mà phòng ban đó chủ trì.

--drop function FU_timPhongBan

--Tạo hàm 
create function FU_timPhongBan (@Maphg int)
returns table
as 
	return(
		select TENPHG,NHANVIEN.HONV+' ' +NHANVIEN.TENNV as Ten_truongphong, COUNT(MADA) as SoLuong_DeAn
		from PHONGBAN
		join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
		join DEAN on DEAN.PHONG=PHONGBAN.MAPHG
		where PHONGBAN.MAPHG=@Maphg
		group by TENPHG,NHANVIEN.HONV,NHANVIEN.TENNV
	)
-- gọi hàm
	select * from FU_timPhongBan(1)
	--Bài 2
	--1. Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg
	--Tạo View
	create view view_ThongTinNhanVien
	as 
		select NHANVIEN.HONV,NHANVIEN.TENNV, PHONGBAN.TENPHG,DIADIEM_PHG.DIADIEM
		from NHANVIEN
		join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
		join DIADIEM_PHG on DIADIEM_PHG.MAPHG=PHONGBAN.MAPHG
	-- gọi view 
	--select * from view_ThongTinNhanVien (check lại)
	--2.Hiển thị thông tin TenNv, Lương, Tuổi
	--Tạo View
	create view view_bai2b
	as
		select TENNV,LUONG, year(getdate())-year(ngsinh) as Tuoi 
		from NHANVIEN
	-- gọi view
	select * from view_bai2b
	--3.Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
	--Tạo View
	create view view_bai2c
	as
	select top(1) with ties 
	COUNT(NHANVIEN.PHG)  SoLuong_Nv,
	PHONGBAN.TENPHG,PHONGBAN.TRPHG, NV2.TENNV Ten_Truongphong
	from NHANVIEN
	join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
	join NHANVIEN NV2 on PHONGBAN.TRPHG=NV2.MANV
	group by PHONGBAN.TENPHG,PHONGBAN.TRPHG,NV2.TENNV
	order by SoLuong_Nv desc
	--gọi view
	select * from view_bai2c


