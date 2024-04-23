use QLDA
/*1. Tìm các nhân viên làm việc ở phòng số 4*/
select * from nhanvien where phg=4
/*2. Tìm các nhân viên có mức lương trên 30000*/
select * from nhanvien where luong>=30000
/*3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
viên có mức lương trên 30,000 ở phòng 5
*/
select * from nhanvien where (luong>=25000 and phg=4) 
or (luong>=30000 and phg=5) 
/*4.Cho biết họ tên đầy đủ của các nhân viên ở TP HCM*/
select HONV+' ' + TENLOT +' ' + TENNV N'Họ tên nv',DCHI from NHANVIEN
where DCHI like '%HCM%' or DCHI like N'%Hồ%'
--5. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự
--'N'
select HONV+' ' + TENLOT +' ' + TENNV N'Họ tên nv' from NHANVIEN
where HONV like N'N%'
--6. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien. 
select HONV+' ' + TENLOT +' ' + TENNV as fullname, DCHI, NGSINH , MANV
from NHANVIEN 
where (HONV = N'Đinh') and (TENLOT = N'Bá') and (TENNV = N'Tiên')
