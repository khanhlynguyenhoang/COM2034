--bài 1
--Sử dụng cơ sở dữ liệu QLDA. Với mỗi câu truy vấn cần thực hiện bằng 2 cách, dùng cast và convert
--	Chỉnh sửa cột thời trong bảng PhanCong với dữ liệu như sau:
--sửa thành kdl decimal 
	SELECT MA_NVIEN, MADA, STT, CAST(THOIGIAN AS DECIMAL(10,2)) AS N'Thời gian sửa' FROM dbo.PHANCONG
	SELECT MA_NVIEN, MADA, STT, CONVERT(decimal(10,2),THOIGIAN) AS N'Thời gian sửa' FROM dbo.PHANCONG
	--sửa thành kdl varchar
	SELECT MA_NVIEN, MADA, STT, CAST(THOIGIAN AS VARCHAR) AS N'Thời gian sửa' FROM dbo.PHANCONG
	SELECT MA_NVIEN, MADA, STT, CONVERT(varchar,THOIGIAN) AS N'Thời gian sửa' FROM dbo.PHANCONG

--Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
	select TENDEAN, SUM(THOIGIAN) N'Tổng số giờ' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	
	--	Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
	--Dùng cast
	select TENDEAN, CAST(SUM(THOIGIAN)as decimal(6,2)) N'Tổng số giờ kiểu decimal' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--Dùng convert
	select TENDEAN, CONVERT(decimal(6,2),SUM(THOIGIAN)) N'Tổng số giờ kiểu decimal' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--	Xuất định dạng “tổng số giờ làm việc” kiểu varchar
	--Dùng cast
	select TENDEAN, CAST(SUM(THOIGIAN)as varchar) N'Tổng số giờ kiểu varchar ' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--Dùng convert
	select TENDEAN, CONVERT(varchar,SUM(THOIGIAN)) N'Tổng số giờ kiểu varchar' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN

--	Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm việc cho phòng ban đó.
	select TENPHG, AVG(luong) N'Lương trung bình'from PHONGBAN
	join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
	group by TENPHG

--•	Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, 
--sử dụng dấu phẩy để phân biệt phần nguyên và phần thập phân.
	--dùng cast
	select TENPHG, CAST(AVG(luong) as decimal(10,2)) N'Lương trung bình 'from PHONGBAN
	join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
	group by TENPHG
	--dùng convert
	select TENPHG,CONVERT(decimal(10,2),AVG(luong)) N'Lương trung bình'from PHONGBAN
	join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
	group by TENPHG
--•	Xuất định dạng “luong trung bình” kiểu varchar.
--Sử dụng dấu phẩy tách cứ mỗi 3 chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
	--dùng cast
	select TENPHG, CAST(AVG(luong) as varchar) N'Lương trung bình ',
	LEFT (CAST(AVG(luong) as varchar),3) +
	--cứ mỗi 3 số sẽ cắt ra từ lương 
	REPLACE(CAST(AVG(luong) as varchar),LEFT (CAST(AVG(luong) as varchar),3),',') N'Lương varchar'
	--câu lệnh replace(chuỗi nguồn( là chuỗi chứa chuỗi thay thế), chuỗi bị thay thế, chuỗi sẽ thế vào)
	from PHONGBAN
	join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
	group by TENPHG
	
	--dùng convert
	select TENPHG, CONVERT(varchar,AVG(luong) ) N'Lương trung bình ',
	LEFT (CONVERT(varchar,AVG(luong) ),3) +
	REPLACE(CONVERT(varchar,AVG(luong) ),LEFT (CONVERT(varchar,AVG(luong)),3),',')N'Lương varchar'
	from PHONGBAN
	join NHANVIEN on NHANVIEN.PHG=PHONGBAN.MAPHG
	group by TENPHG

--2.	Sử dụng các hàm toán học
--	Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó
select TENDEAN, SUM(THOIGIAN) N'Tổng số giờ' from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--•	Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
	--dùng cast
	select TENDEAN,  
	CEILING(CAST(SUM(THOIGIAN)as decimal(6,2))) N'Tổng số giờ dùng ceiling' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--dùng convert
	select TENDEAN,  
	CEILING(CONVERT(decimal(6,2),SUM(THOIGIAN))) N'Tổng số giờ dùng ceiling' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--•	Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
	--dùng cast
	select TENDEAN,  
	FLOOR(CAST(SUM(THOIGIAN)as decimal(6,2))) N'Tổng số giờ dùng floor' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--dùng convert
	select TENDEAN,  
	FLOOR(CONVERT(decimal(6,2),SUM(THOIGIAN))) N'Tổng số giờ dùng floor' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--•	Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
	--dùng cast
	select TENDEAN,  
	ROUND(CAST(SUM(THOIGIAN)as decimal(6,2)),2) N'Tổng số giờ dùng round' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
	--dùng convert
	select TENDEAN,  
	ROUND(CONVERT(decimal(6,2),SUM(THOIGIAN)),2) N'Tổng số giờ dùng round' 
	from DEAN
	join CONGVIEC on CONGVIEC.MADA=DEAN.MADA
	join PHANCONG on PHANCONG.MADA=CONGVIEC.MADA
	group by TENDEAN
--Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) 
--có mức lương trên mức lương trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
	select HONV + ' ' +TENLOT + ' ' + TENNV as N'Họ và tên', LUONG from NHANVIEN
	where LUONG >=(
	select ROUND(AVG(Luong),2) from NHANVIEN
	join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
	where TENPHG=N'Nghiên cứu'
	)

--3.	Sử dụng các hàm xử lý chuỗi
--	Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, thỏa các yêu cầu
select UPPER(HONV) as N'Họ nhân viên',
LOWER (TENLOT) as N'Tên lót',
LOWER(LEFT(TENNV,1)) + 
UPPER(SUBSTRING(TENNV,2,1)) +
LOWER(SUBSTRING(TENNV,3,LEN(TENNV)-2))  as 'Tên nhân viên',
SUBSTRING(DCHI,CHARINDEX (' ',DCHI)+1,CHARINDEX (', ',DCHI)-CHARINDEX (' ',DCHI)-1) as N'Thành phố' 
, COUNT(MA_NVIEN) as N'Số thân nhân' from NHANVIEN
join THANNHAN on THANNHAN.MA_NVIEN=NHANVIEN.MANV
group by HONV,TENLOT,TENNV,DCHI
having COUNT(MA_NVIEN)>=2
--	Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất,
--hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
	select top(1) with ties  TENPHG,TRPHG,
	REPLACE(NV.TENNV,NV.TENNV,'Fpoly') N'Tên trưởng phòng',
	count(NHANVIEN.MANV) as N'Số nhân viên 'from NHANVIEN
	join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
	join NHANVIEN NV on NV.MANV=PHONGBAN.TRPHG
	group by TENPHG,TRPHG, NV.TENNV
	order by count(NHANVIEN.MANV) desc
--4.	Sử dụng các hàm ngày tháng năm
--	Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
	select * from NHANVIEN
	where DATENAME(year,NGSINH) between 1960 and 1965 
--	Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
	select * , year(getdate())-year(NGSINH) as N'Tuổi'from NHANVIEN
--	Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.
	select *, DATENAME(WEEKDAY,NGSINH) as N'Ngày sinh' from NHANVIEN
--	Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng 
--và ngày nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)
	select COUNT(NHANVIEN.MANV) N'Số nhân viên', PHONGBAN.TRPHG ,NV.TENNV as N'Tên trưởng phòng',
	CONVERT(varchar,PHONGBAN.NG_NHANCHUC,105) N'Ngày nhận chức'
	from NHANVIEN
	join PHONGBAN on PHONGBAN.MAPHG=NHANVIEN.PHG
	join NHANVIEN NV on NV.MANV=PHONGBAN.TRPHG
	group by PHONGBAN.TRPHG ,NV.TENNV,PHONGBAN.NG_NHANCHUC


