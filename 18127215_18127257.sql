CREATE DATABASE Lazada
GO
USE Lazada
GO
--Tạo bảng (có not null và default)
CREATE TABLE NHAN_VIEN
(
	NV_ID int,
	NV_TEN nvarchar(50),
	NV_SDT char(10) unique,
	NV_MAIL text,
	NV_LOAI nvarchar(30),
	NV_GTINH nvarchar(8),
	NV_LUONG float(3),
	NV_IDTK int,
	PRIMARY KEY (NV_ID)
)
GO
CREATE TABLE TAI_KHOAN
(
	TK_ID int,
	TK_TEN text,
	TK_MATKHAU text,
	TK_LOAI nvarchar(20),
	PRIMARY KEY (TK_ID)
)
GO
CREATE TABLE KHACH_HANG
(
	KH_ID int,
	KH_HOTEN nvarchar(50),
	KH_SDT char(10) not null unique,
	KH_NGAYSINH date,
	KH_DIACHI nvarchar(100),
	KH_MAIL text not null,
	KH_GIOITINH nvarchar(8),
	KH_IDTK int,
	PRIMARY KEY(KH_ID)
)
GO
CREATE TABLE VOUCHER
(
	VCH_ID int,
	VCH_GIATRI tinyint,
	VCH_LOAI nvarchar(20),
	VCH_CONLAI int,
	PRIMARY KEY (VCH_ID)
)
GO
CREATE TABLE HOA_DON
(
	HD_ID int,
	HD_TINHTRANG nvarchar(50) default N'Đang lấy hàng',
	HD_IDGH int,
	HD_NGAY date default GETDATE(),
	PRIMARY KEY (HD_ID)
)
GO
CREATE TABLE GIO_HANG
(
	GH_ID int,
	GH_PTTTOAN nvarchar(20),
	GH_TONGTIEN money,
	GH_DCNhan nvarchar(100),
	GH_TINHTRANG nvarchar(50) not null default N'Chưa duyệt',
	GH_VAT tinyint default 10,
	GH_PHISHIP float(3) default 15000,
	GH_IDNV int,
	GH_IDKH int,
	PRIMARY KEY (GH_ID)
)
GO
CREATE TABLE SU_DUNG_VOUCHER
(
	SDVC_IDVC int,
	SDVC_IDGH int,
	SDVC_LOAIVC nvarchar(20),
	SDVC_GIATRI tinyint default 0,
	PRIMARY KEY (SDVC_IDVC, SDVC_IDGH)
)
GO
CREATE TABLE CHI_TIET_GIO_HANG
(
	CTGH_IDGH int,
	CTGH_IDMH int,
	CTGH_DONGIA money,
	CTGH_SOLUONG int DEFAULT 1,
	PRIMARY KEY (CTGH_IDGH, CTGH_IDMH)
)
GO
CREATE TABLE MAT_HANG
(
	MH_ID int,
	MH_TEN nvarchar(50) not null,
	MH_XUATXU nvarchar(30) not null,
	MH_TLUONG float(3) not null,
	MH_THUONGHIEU nvarchar(35) not null,
	MH_IDLOAI int,
	PRIMARY KEY (MH_ID)
)
GO
CREATE TABLE LOAI_HANG
(
	LH_ID int,
	LH_TEN nvarchar(25) not null unique,
	PRIMARY KEY (LH_ID)
)
GO
CREATE TABLE NHA_CUNG_UNG
(
	NCU_ID int,
	NCU_TEN nvarchar(50),
	NCU_DCHI nvarchar(100),
	NCU_SDT char(10) unique,
	NCU_MAIL text,
	PRIMARY KEY (NCU_ID)
)
GO
CREATE TABLE THONG_TIN_CUNG_UNG
(
	TTCU_ID_NCU int,
	TTCU_IDMH int,
	TTCU_DONGIA money not null,
	PRIMARY KEY (TTCU_ID_NCU, TTCU_IDMH)
)
GO
--Các ràng buộc khóa ngoại
--NHAN_VIEN
ALTER TABLE NHAN_VIEN
	ADD CONSTRAINT FK_NHANVIEN_TAIKHOAN_IDTK
	FOREIGN KEY (NV_IDTK) REFERENCES TAI_KHOAN(TK_ID) ON DELETE SET NULL 
	
--KHACH_HANG
ALTER TABLE KHACH_HANG
	ADD CONSTRAINT FK_KHACHHANG_TAIKHOAN_IDTK
	FOREIGN KEY (KH_IDTK) REFERENCES TAI_KHOAN(TK_ID) ON DELETE SET NULL 
	
--HOADON
ALTER TABLE HOA_DON
	ADD CONSTRAINT FK_HOADON_GIOHANG_IDGH
	FOREIGN KEY (HD_IDGH) REFERENCES GIO_HANG(GH_ID) ON DELETE CASCADE
	
--GIO_HANG
ALTER TABLE GIO_HANG
	ADD CONSTRAINT FK_GIOHANG_NHANVIEN_IDNV
	FOREIGN KEY (GH_IDNV) REFERENCES NHAN_VIEN(NV_ID) ON DELETE SET NULL
	
ALTER TABLE GIO_HANG
	ADD CONSTRAINT FK_GIOHANG_KHACHHANG_IDKH
	FOREIGN KEY (GH_IDKH) REFERENCES KHACH_HANG(KH_ID) ON DELETE SET NULL
	
--SU_DUNG_VOUCHER
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT FK_SUDUNGVOUCHER_VOUCHER_IDVC
	FOREIGN KEY (SDVC_IDVC) REFERENCES VOUCHER(VCH_ID)
	
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT FK_SUDUNGVOUCHER_GIOHANG_IDGH
	FOREIGN KEY (SDVC_IDGH) REFERENCES GIO_HANG(GH_ID)
	
--CHI_TIET_GIO_HANG
ALTER TABLE CHI_TIET_GIO_HANG
	ADD CONSTRAINT FK_CHITIETGIOHANG_GIOHANG_IDGH
	FOREIGN KEY (CTGH_IDGH) REFERENCES GIO_HANG(GH_ID) ON DELETE CASCADE
	
ALTER TABLE CHI_TIET_GIO_HANG
	ADD CONSTRAINT FK_CHITIETGIOHANG_MATHANG_IDMH
	FOREIGN KEY (CTGH_IDMH) REFERENCES MAT_HANG(MH_ID) ON DELETE CASCADE
	
--MAT_HANG
ALTER TABLE MAT_HANG
	ADD CONSTRAINT FK_MATHANG_LOAIHANG_IDLOAI
	FOREIGN KEY (MH_IDLOAI) REFERENCES LOAI_HANG(LH_ID)ON DELETE SET NULL
	
--THONG_TIN_CUNG_UNG
ALTER TABLE THONG_TIN_CUNG_UNG
	ADD CONSTRAINT FK_THONGTINCUNGUNG_NHACUNGUNG_IDNCU
	FOREIGN KEY (TTCU_ID_NCU) REFERENCES NHA_CUNG_UNG(NCU_ID) ON DELETE CASCADE
ALTER TABLE THONG_TIN_CUNG_UNG
	ADD CONSTRAINT FK_THONGTINCUNGUNG_MATHANG_IDMH
	FOREIGN KEY (TTCU_IDMH) REFERENCES MAT_HANG(MH_ID) ON DELETE CASCADE
	
--Cac rang buoc logic
ALTER TABLE NHAN_VIEN
	ADD CONSTRAINT CK_NHANVIEN_GIOITINH
	CHECK (NV_GTINH = N'Nam' or NV_GTINH = N'Nữ')
	
ALTER TABLE KHACH_HANG
	ADD CONSTRAINT CK_KHACHHANG_GIOITINH
	CHECK (KH_GIOITINH = N'Nam' or KH_GIOITINH = N'Nữ')
	
ALTER TABLE KHACH_HANG
	ADD CONSTRAINT CK_KHACHHANG_NGAYSINH
	CHECK (KH_NGAYSINH < GETDATE())
	
ALTER TABLE VOUCHER
	ADD CONSTRAINT CK_VOUCHER_GIATRI
	CHECK (VCH_GIATRI > 0 and VCH_GIATRI <= 100)
	
ALTER TABLE VOUCHER
	ADD CONSTRAINT CK_VOUCHER_CONLAI
	CHECK (VCH_CONLAI >= 0)

ALTER TABLE GIO_HANG
	ADD CONSTRAINT CK_GIOHANG_TINHTRANG
	CHECK (GH_TINHTRANG = N'Đã duyệt' or GH_TINHTRANG = N'Chưa duyệt')
	
ALTER TABLE GIO_HANG
	ADD CONSTRAINT CK_GIOHANG_TONGTIEN
	CHECK (GH_TONGTIEN > 0)
	
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT CK_SUDUNGVOUCHER_GIATRI
	CHECK (SDVC_GIATRI > 0 and SDVC_GIATRI <= 100)
GO
create function CK_GiaTri_Voucher ()
returns int
as
begin
	if not exists (select s.SDVC_IDVC from SU_DUNG_VOUCHER s where exists (select v.VCH_ID from VOUCHER v where v.VCH_ID = s.SDVC_IDVC
	and (s.SDVC_LOAIVC != v.VCH_LOAI or s.SDVC_GIATRI != v.VCH_GIATRI)))
	begin
		return 1
	end
	return 0
end;
GO
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT CK_SUDUNGVOUCHER_GIATRI_FK
	CHECK (dbo.CK_GiaTri_Voucher() = 1)
GO
create function CK_SoLuong_Voucher ()
returns int
as
begin
	if ( 2 >= all (select COUNT(SDVC_IDGH) from SU_DUNG_VOUCHER group by SDVC_IDGH)) 
	and ( 1 >= all (select COUNT(s.SDVC_IDGH) from SU_DUNG_VOUCHER s where s.SDVC_LOAIVC = 'Ship' group by s.SDVC_IDGH))
	and ( 1 >= all (select COUNT(s.SDVC_IDGH) from SU_DUNG_VOUCHER s where s.SDVC_LOAIVC = 'Product' group by s.SDVC_IDGH))
	begin
		return 1
	end
	return 0
end;
GO
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT CK_SUDUNGVOUCHER_SOLUONG
	CHECK (dbo.CK_SoLuong_Voucher () = 1)
	
ALTER TABLE SU_DUNG_VOUCHER
	ADD CONSTRAINT CK_SUDUNGVOUCHER_LOAIVC
	CHECK (SDVC_LOAIVC = 'Ship' or SDVC_LOAIVC = 'Product')
	
ALTER TABLE CHI_TIET_GIO_HANG
	ADD CONSTRAINT CK_CTGIOHANG_DONGIA
	CHECK (CTGH_DONGIA > 0)

ALTER TABLE CHI_TIET_GIO_HANG
	ADD CONSTRAINT CK_CTGIOHANG_SOLUONG
	CHECK (CTGH_SOLUONG > 0)
	
ALTER TABLE MAT_HANG
	ADD CONSTRAINT CK_MATHANG_TLUONG
	CHECK (MH_TLUONG > 0)
	
ALTER TABLE THONG_TIN_CUNG_UNG
	ADD CONSTRAINT CK_TTCUNGUNG_DONGIA
	CHECK (TTCU_DONGIA > 0)
	
ALTER TABLE HOA_DON
	ADD CONSTRAINT CK_HOADON_NGAY
	CHECK (HD_NGAY <= GETDATE())
	
--Nhập dữ liệu
--Tài Khoản

insert into TAI_KHOAN
	values(1,'THuyVu','0775463088', N'NHÂN VIÊN')
insert into TAI_KHOAN
	values(2,'QPThanh','0775463089', N'NHÂN VIÊN')
insert into TAI_KHOAN
	values(3,'MocAnh','0939807294', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(4,'Hehe','0935413549', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(5,'MyHanh','0983269325', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(6,'MyHoa','0939807293', N'NHÂN VIÊN')
insert into TAI_KHOAN
	values(7,'LongA','0772720673', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(8,'LongM','0938038353', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(9,'TKyDai','0936743652', N'KHÁCH HÀNG')
insert into TAI_KHOAN
	values(10,'NhatMinh','0988422690', N'NHÂN VIÊN')
insert into TAI_KHOAN
	values(11,'BuoiTaiNhan','0939277931', N'NHÂN VIÊN')
insert into TAI_KHOAN
	values(12,'ToDongPha','0371826326', N'NHÂN VIÊN')

--Nhân viên
-- có 2 loại nhân viên, 1 là quản lý, 2 là kiểm duyệt
insert into NHAN_VIEN
	values(1, N'Trần Huy Vũ','0775463088','huyvucv10112000@gmail.com', N'Quản Lý', N'Nam',20000000,1)
insert into NHAN_VIEN
	values(2, N'Quách Phú Thành','0775463089','phuthanhhehe@gmail.com', N'Kiểm Duyệt', N'Nam',10000000,2)
insert into NHAN_VIEN
	values(3, N'Huỳnh Thị Mỹ Hoa','0939807293','huynhhoa2k@gmail.com', N'Kiểm Duyệt', N'Nữ',10000000,6)
insert into NHAN_VIEN
	values(4, N'Phang Nhật Minh','0988422690','maykhaunhatrang@gmail.com', N'Kiểm Duyệt', N'Nam',7000000,10)
insert into NHAN_VIEN
	values(5, N'Trần Buồi Tài Nhân','0939277931','sadboiz_nguoicodon@gmail.com', N'Kiểm Duyệt', N'Nữ',7500000,11)
insert into NHAN_VIEN
	values(6, N'Tô Đông Pha','0371826326','danhdanghitadoqua@gmail.com', N'Kiểm Duyệt', N'Nam',7000000,12)

--Khách hàng
insert into KHACH_HANG
	values(1,N'Trần Lư Mộc Anh','0775463088','2000/05/31',N'180, Nguyễn Thị Minh Khai, quận 1, tp Hồ Chí Minh','mocanh_NLHV@gmail.com', N'Nữ',3)
insert into KHACH_HANG
	values(2,N'Trần Lư Nam Anh','0935413549','1998/09/14',N'180, Nguyễn Thị Minh Khai, quận 1, tp Hồ Chí Minh','namanh_NLHV@gmail.com', N'Nam',4)
insert into KHACH_HANG
	values(3,N'Lâm Mỹ Hạnh','0983269325','1998/02/03',N'873, Lạc Long Quân, quận Tân Bình, tp Hồ Chí Minh','usagiii@gmail.com', N'Nữ',5)
insert into KHACH_HANG
	values(4,N'Trịnh Thanh Long','0772720673','2000/10/20',N'340, Trường Chinh, quận 12, tp Hồ Chí Minh','longanh@gmail.com', N'Nam',7)
insert into KHACH_HANG
	values(5,N'Trần Lư Mộc Anh','0938038353','2000/10/20',N'340, Trường Chinh, quận 12, tp Hồ Chí Minh','longemhehegmail.com', N'Nam',8)
insert into KHACH_HANG
	values(6,N'Trần Kỳ Đại','0936743652',N'2004/07/25','39, Cao Lỗ, quận 8, tp Hồ Chí Minh','tkydai@gmail.com', N'Nam',9)


--Voucher
--Có 2 loại voucher là ship và product, 1 cái trừ vào tiền ship, 1 cái trừ vào tiền sản phẩm
insert into VOUCHER
	values(1,100,'Ship',20)	
insert into VOUCHER
	values(2,50,'Ship',50)	
insert into VOUCHER
	values(3,10,'Product',20)
insert into VOUCHER
	values(4,20,'Product',20)
insert into VOUCHER
	values(5,30,'Product',20)

--Giỏ hàng
-- có 3 loại phương thức thanh toán là COD, Momo (t tính để ví điện tử mà thấy nó dài quá), Bank (thanh toán qua ngân hàng nói chung)
-- có các loại tình trạng đơn hàng 
-- + đang chờ xác nhận với shop
-- + đang lấy hàng
-- + đang giao hàng
-- + đã nhận hàng
-- m có thêm gì thì thêm nha, hehe 
-- cái chỗ VAT mình có 2 lựa chọn, 1 là 10 (tức 10%) 2 là 0 (ko lấy VAT)
-- phí ship hiện tại thì cho mặc định là 20k hết nha, chỗ nào để 0 hoặc 10000 tức là có áp mã rùi
insert into GIO_HANG
	values(1,'COD',100000,N'873, Lạc Long Quân, quận Tân Bình, tp Hồ Chí Minh',N'Đã duyệt', 0, 0, 2, 3)
insert into GIO_HANG
	values(2,'Momo',180000,N'340, Trường Chinh, quận 12, tp Hồ Chí Minh',N'Chưa duyệt', 0, 20000, 3, 4)
insert into GIO_HANG
	values(3,'COD',150000,N'180, Nguyễn Thị Minh Khai, quận 1, tp Hồ Chí Minh',N'Đã duyệt', 0, 0, 2, 1)
insert into GIO_HANG
	values(4,'Bank',1100000,N'873, Lạc Long Quân, quận Tân Bình, tp Hồ Chí Minh',N'Chưa duyệt', 10, 10000, 5, 3)
insert into GIO_HANG
	values(5,'COD',700000,N'39, Cao Lỗ, quận 8, tp Hồ Chí Minh',N'Đã duyệt', 0, 0, 4, 6)

 

--sử dụng voucher
-- có thể sử dụng chồng cùng lúc 2 loại voucher nhưng cùng 1 loại ko thể dùng 2 cái
insert into SU_DUNG_VOUCHER
	values(1,1,'Ship',100)
insert into SU_DUNG_VOUCHER
	values(2,3,'Ship',50)	
insert into SU_DUNG_VOUCHER
	values(3,4,'Product',10)
insert into SU_DUNG_VOUCHER
	values(4,2,'Product',20)
insert into SU_DUNG_VOUCHER
	values(2,4,'Ship',50)	
	
	
--Hóa đơn
--Tinh trạng bao gồm: Đang lấy hàng, Đang vận chuyển, Đã giao hàng
insert into HOA_DON
	values (1,N'Đang lấy hàng',1, '12-21-2020')
insert into HOA_DON
	values (2,N'Đã giao hàng',3, '12-21-2020')
insert into HOA_DON
	values (3,N'Đã giao hàng',5,'12-21-2020')


--Loại Hàng
insert into LOAI_HANG
	values(1, N'Thời trang')
insert into LOAI_HANG
	values(2,N'Điện tử')
insert into LOAI_HANG
	values(3,N'Đồng hồ')
insert into LOAI_HANG
	values(4,N'Giày dép')
insert into LOAI_HANG
	values(5,N'Gia dụng')
insert into LOAI_HANG
	values(6,N'Thể thao')
insert into LOAI_HANG
	values(7,N'Xe máy, ô tô')
insert into LOAI_HANG
	values(8,N'Sách')
insert into LOAI_HANG
	values(9,N'Bách hóa')
insert into LOAI_HANG
	values(10,N'Mẹ và bé')
insert into LOAI_HANG
	values(11,N'Sức khỏe và sắc đẹp')
insert into LOAI_HANG
	values(12,N'Máy tính và laptop')
insert into LOAI_HANG
	values(13,N'Điện thoại và phụ kiện')
insert into LOAI_HANG
	values(14,N'Đồ chơi')
insert into LOAI_HANG
	values(15,N'Thú cưng')

--Mặt hàng
--trọng lượng tạm thời tính theo đơn bị kg nha
-- cái này sau này còn nhiều lắm, chắc thêm vô sau
insert into MAT_HANG
	values(1,N'Áo thun adidas',N'Trung Quốc',0.1,'Adidas',1)
insert into MAT_HANG
	values(2,N'Quần adidas',N'Trung Quốc',0.2,'Adidas',1)
insert into MAT_HANG
	values(3,N'Đồng hồ da',N'Việt Nam',0.3,'Rolux',3)
insert into MAT_HANG
	values(4,N'Hạt Royal Cannin',N'Pháp',2,'Royal Cannin',15)
insert into MAT_HANG
	values(5,N'Bột giặt omo',N'Việt Nam',2,'Omo',9)
insert into MAT_HANG
	values(6,N'Pate the pet',N'Việt Nam',1,'The pet VN',15)

--Nhà cung ứng
insert into NHA_CUNG_UNG
	values(1,N'Adidas Việt Nam',N'10 Điện Biên Phủ, quận 1, tp Hồ Chí Minh','0378128344','adidasVN@gmail.com')
insert into NHA_CUNG_UNG
	values(2,N'Đồng hồ RoVN',N'172 Tôn Đản, quận 4, tp Hồ Chí Minh','0378123124', 'donghoxin@gmail.com')
insert into NHA_CUNG_UNG
	values(3,N'Royalcanin.94',N'32 Chu Mạnh Trinh, quận Thủ Đức, tp Hồ Chí Minh','0332947078','royalcanin94@gmail.com')
insert into NHA_CUNG_UNG
	values(4,N'Uniliver',N'323 Nguyễn Thị Thập, quận 7, tp Hồ Chí Minh','0326501641','uniliverVN@gmail.com')

--Thông tin cung ứng
insert into THONG_TIN_CUNG_UNG
	values(1,1,300000)
insert into THONG_TIN_CUNG_UNG
	values(1,2,500000)
insert into THONG_TIN_CUNG_UNG
	values(2,3,300000)
insert into THONG_TIN_CUNG_UNG
	values(3,4,100000)
insert into THONG_TIN_CUNG_UNG
	values(4,5,200000)
insert into THONG_TIN_CUNG_UNG
	values(3,6,50000)

--chi tiết giỏ hàng
insert into CHI_TIET_GIO_HANG
	values(1,4,100000,1)
insert into CHI_TIET_GIO_HANG
	values(2,5,200000,1)
insert into CHI_TIET_GIO_HANG
	values(3,4,100000,1)
insert into CHI_TIET_GIO_HANG
	values(3,6,50000,1)
insert into CHI_TIET_GIO_HANG
	values(4,2,500000,1)
insert into CHI_TIET_GIO_HANG
	values(4,3,300000,1)
insert into CHI_TIET_GIO_HANG
	values(4,5,200000,1)
insert into CHI_TIET_GIO_HANG
	values(5,1,300000,2)
insert into CHI_TIET_GIO_HANG
	values(5,4,100000,1)

GO
--Procedures

--NHÂN VIÊN
create proc Tinh_Tong_Tien
(
	@IDGH int
)
as
begin tran
	begin try	
		if exists (select g.GH_ID from GIO_HANG  g where g.GH_ID = @IDGH)
		begin
			declare @Tong money = (select SUM(ct.CTGH_SOLUONG * ct.CTGH_DONGIA) from GIO_HANG gh join CHI_TIET_GIO_HANG ct on (gh.GH_ID = ct.CTGH_IDGH) where gh.GH_ID = @IDGH)
			declare @Voucher_ship tinyint = (select S.SDVC_GIATRI from SU_DUNG_VOUCHER s where s.SDVC_IDGH = @IDGH and s.SDVC_LOAIVC = 'Ship')
			declare @Voucher_Product tinyint = (select S.SDVC_GIATRI from SU_DUNG_VOUCHER s where s.SDVC_IDGH = @IDGH and s.SDVC_LOAIVC = 'Product')
			if @Voucher_Product is not null
			begin
				set @Tong = @Tong - (@Tong * @Voucher_Product) / 100
			end
			if @Voucher_ship is not null
			begin
				set @Tong = @Tong + (select gh.GH_PHISHIP - ((gh.GH_PHISHIP * @Voucher_ship) / 100) from GIO_HANG gh where gh.GH_ID = @IDGH)
			end
			else
			begin
				set @Tong = @Tong + (select gh.GH_PHISHIP from GIO_HANG gh where gh.GH_ID = @IDGH)
			end
			set @Tong = @Tong + (@Tong * (select gh.GH_VAT from GIO_HANG gh where gh.GH_ID = @IDGH) / 100)
			
			update GIO_HANG set GH_TONGTIEN = @Tong where GH_ID = @IDGH
		end
		else
		begin
			print N'Không tìm thấy giỏ hàng để tính tổng tiền'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
exec Tinh_Tong_Tien 4
GO
create proc NV_Upd_TinhTrangGH
(
	@IDGH int
)
as
begin tran
	begin try
		if not exists (select g.GH_ID from GIO_HANG g where g.GH_ID = @IDGH)
			begin
				print N'Giỏ hàng không tồn tại'
				rollback tran
				return 1
			end
		if (select g.GH_TINHTRANG from GIO_HANG g where g.GH_ID = @IDGH) = N'Đã duyệt'
			begin
				print N'Giỏ hàng đã được duyệt'
				rollback tran
				return 1
			end
		update GIO_HANG set GH_TINHTRANG = N'Đã duyệt' where GH_ID = @IDGH
		declare @max_idhd int = (select MAX(HD_ID) + 1 from HOA_DON)
		insert into HOA_DON
			values (@max_idhd,N'Đang lấy hàng',@IDGH)	
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Upd_TinhTrangGH 2
--exec NV_Upd_TinhTrangGH 6
GO
create proc NV_Upd_TinhTrangHD
(
	@IDHD int,
	@TinhTrang nvarchar(50)
)
as
begin tran
	begin try
		if (@TinhTrang != N'Đang vận chuyển' and @TinhTrang != N'Đã giao hàng') 
			begin
				print N'Sai cú pháp, Tình trạng phải là "Đang vận chuyển" hoặc "Đã giao hàng"'
				rollback tran
				return 1
			end
		if exists (select h.HD_ID from HOA_DON h where h.HD_ID = @IDHD)
		begin
			update HOA_DON set HD_TINHTRANG = @TinhTrang where HD_ID = @IDHD
		end
		else
		begin
			print N'Hóa đơn không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Upd_TinhTrangHD 1, N'Đang vận chuyển'
--exec NV_Upd_TinhTrangHD 1, N'Đang lấy hàng'
GO
create proc NV_Xem_Voucher
as
begin tran
	begin try
		select * from VOUCHER 
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_Voucher
GO
create proc NV_Xem_MatHang
as
begin tran
	begin try
		select * from MAT_HANG
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_MatHang
GO
create proc NV_Xem_GioHang
(
	@IDNV int
) 
as
begin tran
	begin try
		if exists (select n.NV_ID from NHAN_VIEN n where n.NV_ID = @IDNV)
		begin
			select * from GIO_HANG g where g.GH_IDNV = @IDNV
		end
		else
		begin
			print N'Không tồn tại nhân viên này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_GioHang 2
--exec NV_Xem_GioHang 100
GO
create proc NV_Xem_Hoa_Don
(
	@IDNV int
)
as
begin tran
	begin try
		if exists (select n.NV_ID from NHAN_VIEN n where n.NV_ID = @IDNV)
		begin
			select * from GIO_HANG g join HOA_DON h on (g.GH_ID = h.HD_IDGH) where g.GH_IDNV = @IDNV
		end
		else
		begin
			print N'Không tồn tại nhân viên này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_Hoa_Don 2
--exec NV_Xem_Hoa_Don 100
GO
create proc NV_Xem_CT_GioHang
(
	@IDNV int,
	@IDGH int
)
as
begin tran
	begin try
		if exists (select n.NV_ID from NHAN_VIEN n where n.NV_ID = @IDNV)
		begin
			if exists (select g.GH_ID from GIO_HANG g where g.GH_ID = @IDGH and g.GH_IDNV = @IDNV)
			begin
				exec Tinh_Tong_Tien @IDGH
				select * from CHI_TIET_GIO_HANG ct where ct.CTGH_IDGH = @IDGH
			end
			else
			begin
				print N'Không tồn tại giỏ hàng này hoặc nhân viên không có quyền truy cập giỏ hàng này'
				rollback tran
				return 1
			end
		end
		else
		begin
			print N'Không tồn tại nhân viên này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_CT_GioHang 2, 3
--exec NV_Xem_CT_GioHang 1, 3
GO
create proc NV_Xem_NCU
as
begin tran
	begin try
		select * from NHA_CUNG_UNG
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xem_NCU
GO
create proc  NV_Them_MH
(
	@TenMH nvarchar(50),
	@XuatXu nvarchar(30),
	@TLuong float(3),
	@ThuongHieu nvarchar(35),
	@IDLoai int
)
as
begin tran
	begin try
		if exists (select l.LH_ID from LOAI_HANG l where l.LH_ID = @IDLoai)
		begin
			declare @max_idmh int = (select MAX(MH_ID) + 1 from MAT_HANG)
			insert into MAT_HANG
				values (@max_idmh, @TenMH, @XuatXu, @TLuong, @ThuongHieu, @IDLoai)
		end
		else
		begin
			print N'Không tồn tại loại hàng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0 
--exec NV_Them_MH N'ASUS TUF GAMING LAPTOP', N'Châu Âu', 5.0, N'ASUS', 12
--exec NV_Them_MH N'ASUS TUF GAMING LAPTOP', N'Châu Âu', 5.0, N'ASUS', -1
GO
create proc NV_Xoa_MH
(
	@IDMH int
)
as
begin tran
	begin try
		if exists (select m.MH_ID from MAT_HANG m where m.MH_ID = @IDMH)
		begin
			delete from MAT_HANG where MH_ID = @IDMH
		end
		else
		begin
			print N'Không tồn tại mặt hàng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xoa_MH 7
GO
create proc  NV_Upd_MH
(
	@IDMH int,
	@TenMH nvarchar(50),
	@XuatXu nvarchar(30),
	@TLuong float(3),
	@ThuongHieu nvarchar(35),
	@IDLoai int
)
as
begin tran
	begin try
		if exists (select m.MH_ID from MAT_HANG m where m.MH_ID = @IDMH)
		begin
			update MAT_HANG set MH_TEN = @TenMH, MH_XUATXU = @XuatXu, MH_TLUONG = @TLuong, MH_THUONGHIEU = @ThuongHieu,MH_IDLOAI = @IDLoai
			where MH_ID = @IDMH
		end
		else
		begin
			print N'Không tồn tại mặt hàng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0 
--exec NV_Upd_MH 7, N'ASUS TUF GAMING LAPTOP', N'Châu Âu', 6.0, N'ASUS', 12
--exec NV_Upd_MH 8, N'ASUS TUF GAMING LAPTOP', N'Châu Âu', 6.0, N'ASUS', 12
GO
create proc  NV_Them_NCU
(
	@Ten nvarchar(50),
	@Dchi nvarchar(100),
	@SDT char(10),
	@Mail text
)
as
begin tran
	begin try
		if exists (select n.NCU_ID from NHA_CUNG_UNG n where n.NCU_TEN = @Ten or n.NCU_SDT = @SDT)
		begin
			print N'Trùng tên hoặc sdt'
			rollback tran
			return 1
		end
		else
		begin
			declare @max_idncu int = (select MAX(NCU_ID) + 1 from NHA_CUNG_UNG)
			insert into NHA_CUNG_UNG
				values (@max_idncu, @Ten, @Dchi, @SDT, @Mail)
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0 
--exec NV_Them_NCU N'ASUS Việt Nam', N'210 đường 3 tháng 2 quận 5 Tp HCM', '0903276891', 'asusvn@gmail.com.vn'
GO
create proc NV_Xoa_NCU
(
	@IDNCU int
)
as
begin tran
	begin try
		if exists (select n.NCU_ID from NHA_CUNG_UNG n where n.NCU_ID = @IDNCU)
		begin
			delete from NHA_CUNG_UNG where NCU_ID = @IDNCU
		end
		else
		begin
			print N'Không tồn tại nhà cung ứng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xoa_NCU 5
GO
create proc  NV_Upd_NCU
(
	@IDNCU int,
	@Ten nvarchar(50),
	@Dchi nvarchar(100),
	@SDT char(10),
	@Mail text
)
as
begin tran
	begin try
		if exists (select n.NCU_ID from NHA_CUNG_UNG n where n.NCU_ID = @IDNCU)
		begin
			update NHA_CUNG_UNG set NCU_TEN = @Ten, NCU_DCHI = @Dchi, NCU_SDT = @SDT, NCU_MAIL = @Mail
			where NCU_ID = @IDNCU
		end
		else
		begin
			print N'Không tồn tại nhà cung ứng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Upd_NCU 5, N'ASUS VN', N'210 đường 3 tháng 2 quận 5 Tp HCM', '0903276891', 'asusvn@yahoo.com.vn'
--exec NV_Upd_NCU 6, N'ASUS VN', N'210 đường 3 tháng 2 quận 5 Tp HCM', '0903276891', 'asusvn@yahoo.com.vn'
GO
create proc NV_Xem_TT_CU
as
begin tran
	begin try
		select * from NHA_CUNG_UNG
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
GO
create proc NV_Them_TT_CU
(
	@IDNCU int,
	@IDMH int,
	@Dongia money
)
as
begin tran
	begin try
		if exists (select n.NCU_ID from NHA_CUNG_UNG n where n.NCU_ID = @IDNCU)
		begin
			if exists (select m.MH_ID from MAT_HANG m where m.MH_ID = @IDMH)
			begin
				if exists (select * from THONG_TIN_CUNG_UNG t where t.TTCU_ID_NCU = @IDNCU and t.TTCU_IDMH = @IDMH)
				begin
					print N'Đã tồn tại thông tin cung ứng này'
					rollback tran
					return 1
				end
				else
				begin
					insert into THONG_TIN_CUNG_UNG
						values (@IDNCU, @IDMH, @Dongia)
				end
			end
			else
			begin
				print N'Không tồn tại mặt hàng có ID này'
				rollback tran
				return 1
			end
		end
		else
		begin
			print N'Không tồn tại nhà cung ứng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Them_TT_CU 4, 5, 20000000
--exec NV_Them_TT_CU 100, 7, 20000000
GO
create proc NV_Xoa_TT_CU
(
	@IDNCU int,
	@IDMH int
)
as
begin tran
	begin try
		if exists (select * from THONG_TIN_CUNG_UNG t where t.TTCU_ID_NCU = @IDNCU and t.TTCU_IDMH = @IDMH)
		begin
			delete from THONG_TIN_CUNG_UNG where TTCU_ID_NCU = @IDNCU and TTCU_IDMH = @IDMH
		end
		else
		begin
			print N'Không tìm thấy thông tin cung ứng'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xoa_TT_CU 5, 7
GO
create proc NV_Upd_TT_CU
(
	@IDNCU int,
	@IDMH int,
	@Dongia money
)
as
begin tran
	begin try
		if exists (select * from THONG_TIN_CUNG_UNG t where t.TTCU_ID_NCU = @IDNCU and t.TTCU_IDMH = @IDMH)
		begin
			update THONG_TIN_CUNG_UNG set TTCU_DONGIA = @Dongia where TTCU_ID_NCU = @IDNCU and TTCU_IDMH = @IDMH
		end
		else
		begin
			print N'Không tìm thấy thông tin cung ứng'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Upd_TT_CU 5, 7, 18000000
--exec NV_Upd_TT_CU 5, 10, 18000000
GO
create proc NV_Xem_Loai_Hang
as
begin tran
	begin try
		select * from LOAI_HANG order by LH_ID
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
exec NV_Xem_Loai_Hang
GO
create proc NV_Them_Loai_Hang
(
	@Ten nvarchar(25)
)
as
begin tran
	begin try
		if exists (select l.LH_ID from LOAI_HANG l where l.LH_TEN = @Ten)
		begin 
			print N'Đã tồn tại loại hàng này'
			rollback tran
			return 1
		end
		else
		begin
			declare @max_idlh int = (select MAX(LH_ID) + 1 from LOAI_HANG)
			insert into LOAI_HANG
				values (@max_idlh, @Ten)
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Them_Loai_Hang N'Y tế'
--exec NV_Them_Loai_Hang N'Bách hóa'
GO
create proc NV_Xoa_Loai_Hang
(
	@IDLH int
)
as
begin tran
	begin try
		if exists (select l.LH_ID from LOAI_HANG l where l.LH_ID = @IDLH)
		begin
			delete from LOAI_HANG where LH_ID = @IDLH
		end
		else
		begin
			print N'Không tìm thấy Loại hàng có ID này'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Xoa_Loai_Hang 16
GO
create proc NV_Upd_Loai_Hang
(
	@IDLH int,
	@Ten nvarchar(25)
)
as
begin tran
	begin try
		if exists (select l.LH_ID from LOAI_HANG l where l.LH_TEN = @Ten)
		begin
			print N'Tên này đã có ở loại hàng khác'
			rollback tran
			return 1
		end
		else
		begin
			if exists (select l.LH_ID from LOAI_HANG l where l.LH_ID = @IDLH)
			begin
				update LOAI_HANG set LH_TEN = @Ten where LH_ID = @IDLH
			end
			else
			begin
				print N'Không tìm thấy loại hàng nào có ID này'
				rollback tran
				return 1
			end
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec NV_Upd_Loai_Hang 16, N'Nội thất'
--exec NV_Upd_Loai_Hang 16, N'Bách hóa


GO
--ADMIN
create proc AD_TongNV
as
begin tran
	begin try
		declare @count int = (select COUNT(NV_ID) from NHAN_VIEN)	
		print N'Tổng số lượng nhân viên là:' + cast(@count as varchar(10))
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_TongNV
GO
create proc AD_TongKH
as
begin tran
	begin try
		declare @count int = (select COUNT(KH_ID) from KHACH_HANG)	
		print N'Tổng số lượng khách hàng là:' + cast(@count as varchar(10))
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
exec AD_TongKH
GO
create proc AD_TongHD_TG
(
	@Ngaybatdau date,
	@Ngayketthuc date
)	
as
begin tran
	begin try	
		if @Ngaybatdau > @Ngayketthuc
			begin
				print N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc'
				rollback tran
				return 1
			end
		if @Ngaybatdau > GETDATE() or @Ngayketthuc > GETDATE()
			begin
				print N'Ngày bắt đầu và ngày kết thúc phải nhỏ hơn hoặc bằng ngày hôm nay'
				rollback tran
				return 1
			end
		select * from HOA_DON h where h.HD_NGAY <= @Ngayketthuc and h.HD_NGAY >= @Ngaybatdau
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_TongHD_TG '12-20-2020', '12-22-2020'
--exec AD_TongHD_TG '12-21-2020', '12-20-2020'
GO
create proc AD_TongHD_TG_DaGiao
(
	@Ngaybatdau date,
	@Ngayketthuc date
)	
as
begin tran
	begin try	
		if @Ngaybatdau > @Ngayketthuc
			begin
				print N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc'
				rollback tran
				return 1
			end
		if @Ngaybatdau > GETDATE() or @Ngayketthuc > GETDATE()
			begin
				print N'Ngày bắt đầu và ngày kết thúc phải nhỏ hơn hoặc bằng ngày hôm nay'
				rollback tran
				return 1
			end
		select * from HOA_DON h where h.HD_NGAY <= @Ngayketthuc and h.HD_NGAY >= @Ngaybatdau and h.HD_TINHTRANG = N'Đã giao hàng'
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_TongHD_TG_DaGiao '12-20-2020', '12-22-2020'
--exec AD_TongHD_TG_DaGiao '12-21-2020', '12-20-2020'
GO
create proc AD_Them_NV
(
	@TEN nvarchar(50),
	@SDT char(10),
	@MAIL text,
	@LOAI nvarchar(30),
	@GTINH nvarchar(8),
	@LUONG money,
	@tk text,
	@mk text
)	
as
begin tran
	begin try	
		if exists (select n.NV_ID from NHAN_VIEN n where n.NV_SDT = @SDT)
		begin
			print N'Trùng SDT'
			rollback tran
			return 1
		end
		if exists (select t.TK_ID from TAI_KHOAN t where t.TK_TEN like @tk)
		begin
			print N'Trùng Tên tài khoản'
			rollback tran
			return 1
		end
		if @LOAI != N'Quản lí' and @LOAI != N'Kiểm duyệt' 
		begin
			print N'Loại nhân viên là: Quản lí hoặc Kiểm duyệt'
			rollback tran
			return 1
		end
		if @GTINH != N'Nam' and @GTINH != N'Nữ' 
		begin
			print N'Giới tính phải là Nam hoặc Nữ'
			rollback tran
			return 1
		end
		if @LUONG < 0
		begin
			print N'Lương phải lớn hơn 0'
			rollback tran
			return 1
		end
		declare @max_idnv int = (select MAX(NV_ID) + 1 from NHAN_VIEN)
		declare @max_idtk int = (select MAX(TK_ID) + 1 from TAI_KHOAN)
		insert into TAI_KHOAN
			values(@max_idtk, @tk, @mk, N'NHÂN VIÊN')
		insert into NHAN_VIEN
			values(@max_idnv, @TEN, @SDT, @MAIL, @LOAI, @GTINH, @LUONG, @max_idtk)
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_Them_NV N'Trần Đức Bo', '1234567890', 'meomeo@gmail.com', N'Quản lí', N'Nữ', 15000000, 'DUCBO', 'meomeomeo'
GO
create proc AD_Xoa_NV
(
	@IDNV int
)	
as
begin tran
	begin try
		if exists (select n.NV_ID from NHAN_VIEN n where n.NV_ID = @IDNV)
		begin
			declare @temp int = (select n.NV_IDTK from NHAN_VIEN n where n.NV_ID = @IDNV)
			delete from NHAN_VIEN where NV_ID = @IDNV
			if @temp is not NULL
			begin
				delete from TAI_KHOAN where TK_ID = @temp
			end
		end
		else
		begin
			print N'Nhân viên không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_Xoa_NV 7
GO
create proc AD_Xoa_tk
(
	@IDtk int
)	
as
begin tran
	begin try
		if exists (select t.TK_ID from TAI_KHOAN t where t.TK_ID = @IDtk)
		begin
			delete from TAI_KHOAN where TK_ID = @IDtk
		end
		else
		begin
			print N'Tài khoản không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec AD_Xoa_tk 5
GO
create proc AD_Xoa_KH
(
	@IDKH int
)	
as
begin tran
	begin try
		if exists (select h.KH_ID from KHACH_HANG h where h.KH_ID = @IDKH)
		begin
			declare @temp int = (select h.KH_IDTK from KHACH_HANG h where h.KH_ID = @IDKH)
			delete from KHACH_HANG where KH_ID = @IDKH
			if @temp is not NULL
			begin
				delete from TAI_KHOAN where TK_ID = @temp
			end
		end
		else
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
exec AD_Xoa_KH 1


--Khách hàng
--tạo tkkh
--kèm theo cả thông tin của khách hàng
create procedure KH_taoTK 
(
	@TK_TEN text,
	@TK_MATKHAU text,
	@TK_LOAI nvarchar(20),
	@KH_HOTEN nvarchar(50),
	@KH_SDT char(10),
	@KH_NGAYSINH date,
	@KH_DIACHI nvarchar(100),
	@KH_MAIL text,
	@KH_GIOITINH nvarchar(8)
)
as
begin tran
	begin try 
		if exists (select kh.KH_SDT from KHACH_HANG kh where kh.KH_SDT = @KH_SDT)
		begin	
			print N'Trùng SDT'
			rollback tran
			return 1
		end
		if exists (select t.TK_ID from TAI_KHOAN t where t.TK_TEN like @TK_TEN)
		begin
			print N'Trùng Tên tài khoản'
			rollback tran
			return 1
		end
		if @KH_GIOITINH != N'Nam' and @KH_GIOITINH != N'Nữ' 
		begin
			print N'Giới tính phải là Nam hoặc Nữ'
			rollback tran
			return 1
		end
		if @KH_HOTEN is null or @KH_HOTEN= ''
		begin 
			print N'Tên Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		if @KH_DIACHI is null or @KH_DIACHI = ''
		begin 
			print N'Dia Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		IF LEN(@KH_SDT ) <> 10
		begin 
			print N'SDT Không Hợp Lệ'
			rollback tran
			return 1
		end
		declare @max_idnv int = (select MAX(KH_ID) + 1 from KHACH_HANG)
		declare @max_idtk int = (select MAX(TK_ID) + 1 from TAI_KHOAN)
		insert into TAI_KHOAN
			values(@max_idtk, @TK_TEN, @TK_MATKHAU, N'KHÁCH HÀNG')
		insert into KHACH_HANG
			values(@max_idnv, @KH_HOTEN, @KH_SDT, @KH_NGAYSINH, @KH_DIACHI, @KH_MAIL, @KH_GIOITINH, @max_idtk)
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
GO

--Sửa mật khẩu
create procedure capnhat_mk_KH
(
@TK_TEN text,
@TK_MATKHAUCU text,
@TK_MATKHAUMOI text
)
as 
begin tran
	begin try
		if not exists (select * from TAI_KHOAN where TK_TEN like @TK_TEN and TK_LOAI = N'KHÁCH HÀNG')
		begin 
			print N'Khách hàng không tồn tại'
			rollback tran
			return 1
		end 
		if @TK_MATKHAUCU not like (select tk.TK_MATKHAU from TAI_KHOAN tk where tk.TK_TEN like @TK_TEN)
		begin
			print N'Mật khẩu không khớp với tài khoản'
			rollback tran
			return 1
		end
		if @TK_MATKHAUCU like @TK_MATKHAUMOI
		begin
			print N'Mật khẩu mới trùng với mật khẩu cũ'
			rollback tran
			return 1
		end
		update dbo.TAI_KHOAN
		set 
			TK_MATKHAU = @TK_MATKHAUMOI
		where TK_TEN like @TK_TEN
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go
--Sửa thông tin bản thân

create procedure capnhat_thongtin_KH(@KH_ID int,@KH_HOTEN nvarchar(50),@KH_SDT char(10),@KH_NGAYSINH date,@KH_DIACHI nvarchar(100),@KH_MAIL text,@KH_GIOITINH nvarchar(8),@KH_IDTK int)
as
begin tran
	begin try 
		if not exists(select * from KHACH_HANG where kh_id=@KH_ID)
		begin 
			print N'Khach hang' + cast(@KH_ID as varchar(3)) + N' Khong Tồn Tại'
			rollback tran
			return 1
		end 
		if @KH_HOTEN is null or @KH_HOTEN= ''
		begin 
			print N'Tên Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		if @KH_DIACHI is null or @KH_DIACHI = ''
		begin 
			print N'Dia Khach Hang Không Được Trống'
			rollback tran
			return 1
		end
		IF LEN(@KH_SDT ) <> 10
		begin 
			print N'SDT Không Hợp Lệ'
			rollback tran
			return 1
		end
		update dbo.KHACH_HANG
		set 
			KH_HOTEN=@KH_HOTEN,
			KH_SDT=@KH_SDT
		where KH_ID = @KH_ID
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go

--khách hàng xem thông tin mặt hàng
create proc KH_Xem_MatHang
as
begin tran
	begin try
		select * from MAT_HANG
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0
GO

--tạo giỏ hàng mới
create proc KH_tao_giohang
(
	@GH_PTTTOAN nvarchar(20),
	@GH_DCNhan nvarchar(100),
	@GH_TENTK text
)
as
begin tran
	begin try
		
		if @GH_DCNhan is null or @GH_DCNhan = ''
		begin 
			print N'Địa chỉ nhận không Được Trống'
			rollback tran
			return 1
		end
		declare @max_idgh int = (select MAX(GH_ID) + 1 from GIO_HANG)
		declare @def_tongtien int = 0

		--khúc này là tính số nhân viên hiện h để lấy hàm random nè, radom từ nhân viên số 1 đến số lớn nhất
		declare @max_idnv int = (select MAX(NV_ID) from NHAN_VIEN)
		declare @rand_idnv int = (SELECT FLOOR(RAND()*(@max_idnv-1+1)+1))

		--khách hàng nhập tên tk nên phải có bước này để lấy idtk của khách hàng 
		declare @idkh int = (select kh.KH_ID from KHACH_HANG kh join TAI_KHOAN tk on (kh.KH_IDTK = tk.TK_ID) where @GH_TENTK like tk.TK_TEN)

		insert into GIO_HANG (GH_ID,GH_PTTTOAN,GH_TONGTIEN,GH_DCNhan,GH_IDNV,GH_IDKH)
			values(@max_idgh,@GH_PTTTOAN,@def_tongtien,@GH_DCNhan,@rand_idnv,@idkh)
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0

GO


--khách hàng tạo thông tin chi tiết của giỏ hàng
create proc KH_tao_chitietgiohang
(
	@CTGH_IDGH int,
	@CTGH_TENMH nvarchar(50),
	@CTGH_SOLUONG int
)
as
begin tran
	begin try
		
		declare @CTGH_IDMH int = (select mh.MH_ID from MAT_HANG mh where mh.MH_TEN = @CTGH_TENMH)
		declare @CTGH_DONGIA money = (select ttcu.TTCU_DONGIA from MAT_HANG mh join THONG_TIN_CUNG_UNG ttcu on (mh.MH_ID = ttcu.TTCU_IDMH) where mh.MH_TEN = @CTGH_TENMH)

		insert into CHI_TIET_GIO_HANG
			values(@CTGH_IDGH,@CTGH_IDMH,@CTGH_DONGIA ,@CTGH_SOLUONG)		
		exec Tinh_Tong_Tien @CTGH_IDGH

	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0

GO

--khách hàng xóa giỏ hàng và chi tiết giỏ hàng (2 proc riêng)
create proc KH_XOA_GIOHANG
(
	@IDGH int
)
as
begin tran
	begin try
		if exists (select GH_ID from GIO_HANG where GH_ID = @IDGH)
		begin
			delete from GIO_HANG where GH_ID = @IDGH
		end
		else
		begin
			print N'Giỏ hàng không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0

GO

create proc XOA_CHI_TIET_GIO_HANG

(
	
	@IDGH int,
	@TENMH nvarchar(50)
)
as
begin tran
	begin try
		declare @CTGH_IDMH int = (select mh.MH_ID from MAT_HANG mh where mh.MH_TEN = @TENMH)

		if exists (select * from CHI_TIET_GIO_HANG where CTGH_IDMH = @CTGH_IDMH and CTGH_IDGH = @IDGH)
		begin
			delete from CHI_TIET_GIO_HANG where CTGH_IDMH = @CTGH_IDMH and CTGH_IDGH = @IDGH
			exec Tinh_Tong_Tien @IDGH
		end
		else
		begin
			print N'Chi tiết sản phảm trong giỏ hàng này không tồn tại'
			rollback tran
			return 1
		end
	end try
	begin catch
		print N'Lỗi hệ thống'
		rollback tran
		return 1
	end catch
commit tran
return 0

GO

--khách hàng sửa giỏ hàng hoặc chi tiết giỏ hàng (2 proc riêng)
create proc KH_UPDATE_GIOHANG
(
	@GH_TENTK text,
	@GH_PTTTOAN nvarchar(20),
	@GH_DCNhan nvarchar(100)
)
as
begin tran
	begin try 
		if not exists (select * from TAI_KHOAN where TK_TEN like @GH_TENTK and TK_LOAI = N'KHÁCH HÀNG')
		begin 
			print N'Khách hàng không tồn tại'
			rollback tran
			return 1
		end 
		declare @idkh int = (select kh.KH_ID from KHACH_HANG kh join TAI_KHOAN tk on (kh.KH_IDTK = tk.TK_ID) where @GH_TENTK like tk.TK_TEN)
		update dbo.GIO_HANG
		set 
			GH_PTTTOAN = @GH_PTTTOAN,
			GH_DCNhan = @GH_DCNhan
		where GH_IDKH = @idkh
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go

--thay đổi chi tiết giỏ hàng phải nhập thông tin mặt hàng cũ và mặt hàng mới sau khi đổi
create proc KH_UPDATE_CHITIETGIOHANG
(
	@CTGH_IDGH int,
	@CTGH_TENMHCU nvarchar(50),
	@CTGH_TENMHMOI nvarchar(50),
	@CTGH_SOLUONG int
)

as
begin tran
	begin try 
		declare @CTGH_IDMHCU int = (select mh.MH_ID from MAT_HANG mh where mh.MH_TEN = @CTGH_TENMHCU)
		declare @CTGH_IDMHMOI int = (select mh.MH_ID from MAT_HANG mh where mh.MH_TEN = @CTGH_TENMHMOI)
		update dbo.CHI_TIET_GIO_HANG
		set 
			CTGH_IDMH = @CTGH_IDMHMOI,
			CTGH_SOLUONG = @CTGH_SOLUONG
		where CTGH_IDGH = @CTGH_IDGH and CTGH_IDMH = @CTGH_IDMHCU
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
go

--khách hàng xem giỏ hàng của bản thân
create proc KH_XEMGIOHANG
(
	@GH_TENTK text
)
as
begin tran
	begin try
		if not exists (select * from TAI_KHOAN where TK_TEN like @GH_TENTK and TK_LOAI = N'KHÁCH HÀNG')
		begin 
			print N'Khách hàng không tồn tại'
			rollback tran
			return 1
		end 
		declare @idkh int = (select kh.KH_ID from KHACH_HANG kh join TAI_KHOAN tk on (kh.KH_IDTK = tk.TK_ID) where @GH_TENTK like tk.TK_TEN)
		
		select GH_ID, GH_PTTTOAN, GH_TONGTIEN, GH_DCNhan, GH_TINHTRANG, GH_VAT, GH_PHISHIP, GH_IDKH from GIO_HANG where GH_IDKH = @idkh
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_XEMGIOHANG 'MocAnh'
go

--khách hàng xác nhận đơn hàng của mình (chỉ được xác nhận là đã nhận được hàng)
create proc KH_XacNhanDonHang
(
	@IDGH int,
	@TINHTRANG nvarchar(50)
)
as
begin tran
	begin try
		if @TINHTRANG not like N'Đã nhận hàng'
		begin 
			print N'Lỗi'
			rollback tran
			return 1
		end 
		if not exists (select * from HOA_DON where HD_IDGH = @IDGH)
		begin 
			print N'Đơn hàng này không tồn tại'
			rollback tran
			return 1
		end 
		
		update dbo.HOA_DON
			set HD_TINHTRANG = @TINHTRANG
			where HD_IDGH = @IDGH
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go

--theo dõi tình trạng của các đơn hàng (chỉ xem)

create proc KH_XemTinhTrangDonHang
(
	@IDGH int
)
as
begin tran
	begin try
		if not exists (select * from HOA_DON where HD_IDGH = @IDGH)
		begin 
			print N'Đơn hàng này không tồn tại'
			rollback tran
			return 1
		end 
		
		select HD_TINHTRANG as N'Tình trạng của đơn hàng' from HOA_DON where HD_IDGH = @IDGH 
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_XemTinhTrangDonHang 1
go

--tìm thông tin mặt hàng theo các nhu cầu sau
--loại hàng
create proc KH_TimMH_TheoLoaiHang
(
	@TEN_LOAIHANG nvarchar(25)
)
as
begin tran
	begin try

		if not exists (select * from LOAI_HANG where LH_TEN = @TEN_LOAIHANG)
		begin 
			print N'Không có mặt hàng nào thuộc loại hàng này'
			rollback tran
			return 1
		end 
		select * from MAT_HANG mh join LOAI_HANG lh on (mh.MH_IDLOAI = lh.LH_ID) where lh.LH_TEN = @TEN_LOAIHANG

	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_TimMH_TheoLoaiHang N'Thú cưng'
go

--create index Test_Index_MH on LOAI_HANG(LH_TEN) 
--select * from MAT_HANG mh join LOAI_HANG lh on (mh.MH_IDLOAI = lh.LH_ID) where lh.LH_TEN = N'Thú cưng'
--drop index Test_INdex_MH on LOAI_HANG 

--Tên
create proc KH_TimMH_TheoTenMatHang
(
	@TEN_TENMATHANG nvarchar(50)
)
as
begin tran
	begin try

		if exists (select * from MAT_HANG where MH_TEN = @TEN_TENMATHANG)
		begin 
			select * from MAT_HANG where MH_TEN = @TEN_TENMATHANG
		end 
		else
		begin 
			print N'Không tìm thấy'
			rollback tran
			return 1
		end 

	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_TimMH_TheoTenMatHang N'Bột giặt Omo'
go

--giá (khi hiển thị ra sẽ được sắp xếp từ trên xuống dưới)
create proc KH_TimMH_TheoGia
(
	@GIA_NHO_NHAT money,
	@GIA_LON_NHAT money
)
as
begin tran
	begin try
	if exists (select * 
		from MAT_HANG mh join THONG_TIN_CUNG_UNG ttcu on (mh.MH_ID = ttcu.TTCU_IDMH)
		where ttcu.TTCU_DONGIA >= @GIA_NHO_NHAT and ttcu.TTCU_DONGIA <=@GIA_LON_NHAT)
	begin
		select * 
		from MAT_HANG mh join THONG_TIN_CUNG_UNG ttcu on (mh.MH_ID = ttcu.TTCU_IDMH)
		where ttcu.TTCU_DONGIA >= @GIA_NHO_NHAT and ttcu.TTCU_DONGIA <=@GIA_LON_NHAT
		order by ttcu.TTCU_DONGIA
	end
	else
		begin 
			print N'Không tìm thấy'
			rollback tran
			return 1
		end 
	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_TimMH_TheoGia 0,100000
go	

--create index Test_Index_TTCU on THONG_TIN_CUNG_UNG(TTCU_DONGIA)
--select * 
--		from MAT_HANG mh join THONG_TIN_CUNG_UNG ttcu on (mh.MH_ID = ttcu.TTCU_IDMH)
--		where ttcu.TTCU_DONGIA >= 0 and ttcu.TTCU_DONGIA <= 1000000
--		order by ttcu.TTCU_DONGIA
--drop index Test_Index_TTCU on THONG_TIN_CUNG_UNG

--tìm theo thương hiệu
create proc KH_TimMH_TheoThuongHieu
(
	@TEN_THUONGHIEU nvarchar(35)
)
as
begin tran
	begin try

		if not exists (select * from MAT_HANG where MH_THUONGHIEU = @TEN_THUONGHIEU)
		begin 
			print N'Không có thương hiệu nào thuộc loại hàng này'
			rollback tran
			return 1
		end 
		select * from MAT_HANG where MH_THUONGHIEU = @TEN_THUONGHIEU

	end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0
--exec KH_TimMH_TheoThuongHieu N'Adidas'
go


--Nhập code voucher (mỗi thứ chỉ được 1 loại), trong này khách hàng chỉ cần nhập id giỏ hàng với id vc là được, còn cái proc sẽ tự động lấy giá trị 
--loại vc, và check luôn chỉ được dùng mỗi thứ 1 loại tạm thời thì t chưa làm ra khúc này
create proc KH_NhapVoucher
(
	@IDVC int,
	@IDGH int
	
)
as
begin tran
	begin try
		if not exists(select * from GIO_HANG where GH_ID = @IDGH)
		begin 
			print N'Không tồn tại giỏ hàng này'
			rollback tran
			return 1
		end 
		if not exists(select * from VOUCHER where VCH_ID = @IDVC)
		begin 
			print N'Không tồn tại mã khuyến mãi này'
			rollback tran
			return 1
		end 
		declare @SDVC_LOAIVC nvarchar(20) = (select VCH_LOAI from VOUCHER where VCH_ID = @IDVC )
		declare @SDVC_GIATRI tinyint = (select VCH_GIATRI from VOUCHER where VCH_ID = @IDVC )

		insert into SU_DUNG_VOUCHER
			values(@IDVC,@IDGH,@SDVC_LOAIVC,@SDVC_GIATRI)
		end try
	begin catch
		print N'LỖI HỆ THỐNG'
		rollback tran
		return 1
	end catch
commit tran
return 0

go
		
--index 1
--create index Loai_GiaTri_Voucher on SU_DUNG_VOUCHER (SDVC_LOAIVC,SDVC_GIATRI);
--select S.SDVC_GIATRI from SU_DUNG_VOUCHER s where s.SDVC_IDGH = 4 and s.SDVC_LOAIVC = 'Product'
--drop index Loai_GiaTri_Voucher on SU_DUNG_VOUCHER