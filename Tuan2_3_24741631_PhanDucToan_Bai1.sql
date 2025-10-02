--CREATE DATABASE Tuan2Va3Bai1;

--USE Tuan2Va3Bai1;

CREATE TABLE NhomSanPham(
	MaNhom int NOT NULL PRIMARY KEY,
	TenNhom nvarchar(15)
);

CREATE TABLE NhaCungCap(
	MaNCC int NOT NULL PRIMARY KEY,
	TenNCC nvarchar(40) NOT NULL,
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	SoFax nvarchar(24),
	DCMail nvarchar(50)
)

CREATE TABLE SanPham(
	MaSP int NOT NULL PRIMARY KEY,
	TenSP nvarchar(40) NOT NULL,
	MaNCC int,
	MoTa nvarchar(50),
	MaNhom int,
	DonViTinh nvarchar(20),
	GiaGoc money CHECK(GiaGoc > 0),
	SLTon int CHECK(SLTon >= 0)
	FOREIGN KEY (MaNhom) REFERENCES NhomSanPham(MaNhom),
	FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

CREATE TABLE KhachHang(
	MaKH char(5) NOT NULL PRIMARY KEY,
	TenKH nvarchar(40) NOT NULL,
	LoaiKH nvarchar(4) CHECK(LoaiKH IN ('VIP','TV','VL')),
	DiaChi nvarchar(60),
	Phone nvarchar(24),
	DCMail nvarchar(50),
	DiemTL int CHECK(DiemTL >= 0)
);

CREATE TABLE HoaDon(
	MaHD int NOT NULL PRIMARY KEY,
	NgayLapHD datetime DEFAULT GetDate() 
				CONSTRAINT CHK_NgayLapHD CHECK (NgayLapHD >= GETDATE()),
	NgayGiao datetime,
	NoiChuyen nvarchar(60) NOT NULL,
	MaKH char(5)
	FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE CT_HoaDon(
	MaHD int NOT NULL,
	MaSP int NOT NULL,
	SoLuong smallint CHECK(SoLuong > 0),
	DonGia money,
	ChietKhau money,
	PRIMARY KEY(MaHD, MaSP),
	FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
	FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

ALTER TABLE HoaDon
ADD LoaiHD char(1) 
DEFAULT 'N'
CONSTRAINT Check_LoaiHD 
CHECK(LoaiHD IN ('N','X','C','T'));

ALTER TABLE HoaDon
ADD CONSTRAINT Check_NgayGiao 
CHECK(NgayGiao >= NgayLapHD);

