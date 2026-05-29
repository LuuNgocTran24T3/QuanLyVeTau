CREATE DATABASE VeTauDB_CaiTien;
GO
USE VeTauDB_CaiTien;
GO

/*=============================================================================
  1. NHÓM NGƯỜI DÙNG
=============================================================================*/

CREATE TABLE dbo.KHACH_HANG (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_KHACH_HANG PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL,
    so_dien_thoai NVARCHAR(15) NULL,
    mat_khau_hash NVARCHAR(255) NOT NULL,
    ngay_sinh DATE NULL,
    gioi_tinh NVARCHAR(10) NULL,
    dia_chi NVARCHAR(MAX) NULL,
    ngay_tao DATETIME2(0) NOT NULL CONSTRAINT DF_KHACH_HANG_ngay_tao DEFAULT SYSDATETIME(),
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_KHACH_HANG_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_KHACH_HANG_email UNIQUE (email),
    CONSTRAINT UQ_KHACH_HANG_so_dien_thoai UNIQUE (so_dien_thoai),
    CONSTRAINT CK_KHACH_HANG_gioi_tinh CHECK (gioi_tinh IS NULL OR gioi_tinh IN (N'Nam', N'Nữ', N'Khác')),
    CONSTRAINT CK_KHACH_HANG_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Khóa'))
);
GO

CREATE TABLE dbo.NHAN_VIEN (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_NHAN_VIEN PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    email NVARCHAR(150) NOT NULL,
    mat_khau_hash NVARCHAR(255) NOT NULL,
    chuc_vu NVARCHAR(20) NOT NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_NHAN_VIEN_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_NHAN_VIEN_email UNIQUE (email),
    CONSTRAINT CK_NHAN_VIEN_chuc_vu CHECK (chuc_vu IN (N'Admin', N'Nhân viên')),
    CONSTRAINT CK_NHAN_VIEN_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Khóa'))
);
GO

CREATE TABLE dbo.HANH_KHACH (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_HANH_KHACH PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    loai_giay_to NVARCHAR(30) NOT NULL,
    so_giay_to NVARCHAR(50) NOT NULL,
    ngay_sinh DATE NULL,
    quoc_tich NVARCHAR(80) NULL,

    CONSTRAINT UQ_HANH_KHACH_giay_to UNIQUE (loai_giay_to, so_giay_to),
    CONSTRAINT CK_HANH_KHACH_loai_giay_to CHECK (loai_giay_to IN (N'CCCD', N'Hộ chiếu', N'Giấy khai sinh', N'VNeID'))
);
GO

/*=============================================================================
  2. NHÓM TÀU - TOA - GHẾ - GA - CHUYẾN - LỊCH DỪNG
=============================================================================*/

CREATE TABLE dbo.TAU (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TAU PRIMARY KEY,
    ma_tau NVARCHAR(10) NOT NULL,
    ten_tau NVARCHAR(100) NOT NULL,
    chieu_di NVARCHAR(20) NOT NULL CONSTRAINT DF_TAU_chieu_di DEFAULT N'Không xác định',
    thuoc_tuyen_thong_nhat BIT NOT NULL CONSTRAINT DF_TAU_thong_nhat DEFAULT 0,
    mo_ta NVARCHAR(MAX) NULL,
    trang_thai NVARCHAR(50) NOT NULL CONSTRAINT DF_TAU_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_TAU_ma_tau UNIQUE (ma_tau),
    CONSTRAINT CK_TAU_chieu_di CHECK (chieu_di IN (N'Chẵn', N'Lẻ', N'Không xác định')),
    CONSTRAINT CK_TAU_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng'))
);
GO

CREATE TABLE dbo.TOA_TAU (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TOA_TAU PRIMARY KEY,
    tau_id INT NOT NULL,
    so_toa INT NOT NULL,
    loai_toa NVARCHAR(40) NOT NULL,
    suc_chua INT NOT NULL,
    trang_thai NVARCHAR(50) NOT NULL CONSTRAINT DF_TOA_TAU_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT FK_TOA_TAU_TAU FOREIGN KEY (tau_id) REFERENCES dbo.TAU(id),
    CONSTRAINT UQ_TOA_TAU_tau_so_toa UNIQUE (tau_id, so_toa),
    CONSTRAINT CK_TOA_TAU_so_toa CHECK (so_toa > 0),
    CONSTRAINT CK_TOA_TAU_suc_chua CHECK (suc_chua > 0),
    CONSTRAINT CK_TOA_TAU_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng')),
    CONSTRAINT CK_TOA_TAU_loai_toa CHECK (
        loai_toa IN (
            N'Ghế ngồi cứng',
            N'Ghế ngồi mềm',
            N'Nằm cứng 6 người',
            N'Nằm mềm 4 người',
            N'VIP 2 giường',
            N'VIP 4 giường'
        )
    )
);
GO

CREATE TABLE dbo.GHE (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_GHE PRIMARY KEY,
    toa_tau_id INT NOT NULL,
    so_ghe NVARCHAR(10) NOT NULL,
    tang INT NULL,
    loai_cho NVARCHAR(20) NOT NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_GHE_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT FK_GHE_TOA_TAU FOREIGN KEY (toa_tau_id) REFERENCES dbo.TOA_TAU(id),
    CONSTRAINT UQ_GHE_toa_so_ghe UNIQUE (toa_tau_id, so_ghe),
    CONSTRAINT CK_GHE_tang CHECK (tang IS NULL OR tang IN (1, 2, 3)),
    CONSTRAINT CK_GHE_loai_cho CHECK (loai_cho IN (N'Ghế', N'Giường')),
    CONSTRAINT CK_GHE_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Bảo trì', N'Khóa'))
);
GO

CREATE TABLE dbo.GA (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_GA PRIMARY KEY,
    ma_ga NVARCHAR(10) NOT NULL,
    ten_ga NVARCHAR(100) NOT NULL,
    tinh_thanh NVARCHAR(100) NULL,
    ly_trinh_km INT NULL,
    dia_chi NVARCHAR(MAX) NULL,
    trang_thai NVARCHAR(50) NOT NULL CONSTRAINT DF_GA_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_GA_ma_ga UNIQUE (ma_ga),
    CONSTRAINT CK_GA_ly_trinh CHECK (ly_trinh_km IS NULL OR ly_trinh_km >= 0),
    CONSTRAINT CK_GA_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng'))
);
GO

CREATE TABLE dbo.CHUYEN_TAU (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CHUYEN_TAU PRIMARY KEY,
    tau_id INT NOT NULL,
    ma_chuyen NVARCHAR(30) NOT NULL,
    ngay_chay DATE NOT NULL,
    gio_khoi_hanh DATETIME2(0) NOT NULL,
    gio_den_du_kien DATETIME2(0) NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_CHUYEN_TAU_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT FK_CHUYEN_TAU_TAU FOREIGN KEY (tau_id) REFERENCES dbo.TAU(id),
    CONSTRAINT UQ_CHUYEN_TAU_ma_chuyen UNIQUE (ma_chuyen),
    CONSTRAINT CK_CHUYEN_TAU_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Hủy', N'Hoàn thành')),
    CONSTRAINT CK_CHUYEN_TAU_thoi_gian CHECK (gio_den_du_kien IS NULL OR gio_den_du_kien > gio_khoi_hanh)
);
GO

CREATE TABLE dbo.LICH_DUNG (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_LICH_DUNG PRIMARY KEY,
    chuyen_tau_id INT NOT NULL,
    ga_id INT NOT NULL,
    thu_tu_dung INT NOT NULL,
    thoi_gian_den DATETIME2(0) NULL,
    thoi_gian_di DATETIME2(0) NULL,

    CONSTRAINT FK_LICH_DUNG_CHUYEN_TAU FOREIGN KEY (chuyen_tau_id) REFERENCES dbo.CHUYEN_TAU(id),
    CONSTRAINT FK_LICH_DUNG_GA FOREIGN KEY (ga_id) REFERENCES dbo.GA(id),
    CONSTRAINT UQ_LICH_DUNG_chuyen_ga UNIQUE (chuyen_tau_id, ga_id),
    CONSTRAINT UQ_LICH_DUNG_chuyen_thu_tu UNIQUE (chuyen_tau_id, thu_tu_dung),
    CONSTRAINT CK_LICH_DUNG_thu_tu CHECK (thu_tu_dung > 0),
    CONSTRAINT CK_LICH_DUNG_co_thoi_gian CHECK (thoi_gian_den IS NOT NULL OR thoi_gian_di IS NOT NULL),
    CONSTRAINT CK_LICH_DUNG_den_truoc_di CHECK (thoi_gian_den IS NULL OR thoi_gian_di IS NULL OR thoi_gian_den <= thoi_gian_di)
);
GO

/*=============================================================================
  3. NHÓM CẤU HÌNH GIÁ - ƯU ĐÃI - KHUYẾN MÃI
=============================================================================*/

CREATE TABLE dbo.DOI_TUONG_UU_DAI (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DOI_TUONG_UU_DAI PRIMARY KEY,
    ma_doi_tuong NVARCHAR(30) NOT NULL,
    ten_doi_tuong NVARCHAR(100) NOT NULL,
    phan_tram_giam DECIMAL(5,2) NOT NULL CONSTRAINT DF_DOI_TUONG_UU_DAI_phan_tram DEFAULT 0,
    tuoi_min INT NULL,
    tuoi_max INT NULL,
    can_giay_to_chung_minh BIT NOT NULL CONSTRAINT DF_DOI_TUONG_UU_DAI_can_giay_to DEFAULT 0,
    hieu_luc_tu DATETIME2(0) NULL,
    hieu_luc_den DATETIME2(0) NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_DOI_TUONG_UU_DAI_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_DOI_TUONG_UU_DAI_ma UNIQUE (ma_doi_tuong),
    CONSTRAINT CK_DOI_TUONG_UU_DAI_phan_tram CHECK (phan_tram_giam BETWEEN 0 AND 100),
    CONSTRAINT CK_DOI_TUONG_UU_DAI_tuoi CHECK (
        (tuoi_min IS NULL OR tuoi_min >= 0)
        AND (tuoi_max IS NULL OR tuoi_max >= 0)
        AND (tuoi_min IS NULL OR tuoi_max IS NULL OR tuoi_min <= tuoi_max)
    ),
    CONSTRAINT CK_DOI_TUONG_UU_DAI_hieu_luc CHECK (hieu_luc_tu IS NULL OR hieu_luc_den IS NULL OR hieu_luc_tu < hieu_luc_den),
    CONSTRAINT CK_DOI_TUONG_UU_DAI_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng', N'Hết hạn'))
);
GO

CREATE TABLE dbo.KHUYEN_MAI (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_KHUYEN_MAI PRIMARY KEY,
    ma_khuyen_mai NVARCHAR(30) NOT NULL,
    ten_chuong_trinh NVARCHAR(200) NOT NULL,
    phan_tram_giam DECIMAL(5,2) NOT NULL CONSTRAINT DF_KHUYEN_MAI_phan_tram DEFAULT 0,
    giam_toi_da DECIMAL(12,2) NULL,
    gia_tri_don_toi_thieu DECIMAL(12,2) NOT NULL CONSTRAINT DF_KHUYEN_MAI_min DEFAULT 0,
    phuong_thuc_tt_ap_dung NVARCHAR(30) NULL,
    ngay_bat_dau DATETIME2(0) NOT NULL,
    ngay_ket_thuc DATETIME2(0) NOT NULL,
    so_luong_toi_da INT NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_KHUYEN_MAI_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT UQ_KHUYEN_MAI_ma UNIQUE (ma_khuyen_mai),
    CONSTRAINT CK_KHUYEN_MAI_phan_tram CHECK (phan_tram_giam BETWEEN 0 AND 100),
    CONSTRAINT CK_KHUYEN_MAI_tien CHECK (
        (giam_toi_da IS NULL OR giam_toi_da >= 0)
        AND gia_tri_don_toi_thieu >= 0
        AND (so_luong_toi_da IS NULL OR so_luong_toi_da >= 0)
    ),
    CONSTRAINT CK_KHUYEN_MAI_phuong_thuc CHECK (
        phuong_thuc_tt_ap_dung IS NULL
        OR phuong_thuc_tt_ap_dung IN (N'VNPay', N'MoMo', N'OnePay', N'Tiền mặt', N'Chuyển khoản', N'ATM', N'Thẻ ATM')
    ),
    CONSTRAINT CK_KHUYEN_MAI_ngay CHECK (ngay_bat_dau < ngay_ket_thuc),
    CONSTRAINT CK_KHUYEN_MAI_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng', N'Hết hạn'))
);
GO

CREATE TABLE dbo.BANG_GIA (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_BANG_GIA PRIMARY KEY,
    ga_di_id INT NOT NULL,
    ga_den_id INT NOT NULL,
    loai_toa_ap_dung NVARCHAR(40) NOT NULL,
    tang_ap_dung INT NULL,
    gia_co_so DECIMAL(12,2) NOT NULL,
    phu_thu_cao_diem_mac_dinh DECIMAL(12,2) NOT NULL CONSTRAINT DF_BANG_GIA_phu_thu DEFAULT 0,
    hieu_luc_tu DATETIME2(0) NOT NULL,
    hieu_luc_den DATETIME2(0) NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_BANG_GIA_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT FK_BANG_GIA_GA_DI FOREIGN KEY (ga_di_id) REFERENCES dbo.GA(id),
    CONSTRAINT FK_BANG_GIA_GA_DEN FOREIGN KEY (ga_den_id) REFERENCES dbo.GA(id),
    CONSTRAINT CK_BANG_GIA_ga CHECK (ga_di_id <> ga_den_id),
    CONSTRAINT CK_BANG_GIA_loai_toa CHECK (
        loai_toa_ap_dung IN (
            N'Ghế ngồi cứng',
            N'Ghế ngồi mềm',
            N'Nằm cứng 6 người',
            N'Nằm mềm 4 người',
            N'VIP 2 giường',
            N'VIP 4 giường'
        )
    ),
    CONSTRAINT CK_BANG_GIA_tang CHECK (tang_ap_dung IS NULL OR tang_ap_dung IN (1, 2, 3)),
    CONSTRAINT CK_BANG_GIA_tien CHECK (gia_co_so >= 0 AND phu_thu_cao_diem_mac_dinh >= 0),
    CONSTRAINT CK_BANG_GIA_hieu_luc CHECK (hieu_luc_den IS NULL OR hieu_luc_tu < hieu_luc_den),
    CONSTRAINT CK_BANG_GIA_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng', N'Hết hạn'))
);
GO

/*=============================================================================
  4. NHÓM ĐẶT CHỖ - GIỮ CHỖ - VÉ - THANH TOÁN - HOÀN TIỀN
=============================================================================*/

CREATE TABLE dbo.DAT_CHO (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DAT_CHO PRIMARY KEY,
    khach_hang_id INT NOT NULL,
    khuyen_mai_id INT NULL,
    ma_dat_cho NVARCHAR(30) NOT NULL,
    loai_don_hang NVARCHAR(20) NOT NULL CONSTRAINT DF_DAT_CHO_loai_don DEFAULT N'Cá nhân',
    loai_hanh_trinh NVARCHAR(20) NOT NULL CONSTRAINT DF_DAT_CHO_hanh_trinh DEFAULT N'Một chiều',
    ngay_dat DATETIME2(0) NOT NULL CONSTRAINT DF_DAT_CHO_ngay_dat DEFAULT SYSDATETIME(),
    tong_tien_ve_goc DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_tien_goc DEFAULT 0,
    thue_vat DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_vat DEFAULT 0,
    phi_thanh_toan DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_phi_tt DEFAULT 0,
    tong_giam_khuyen_mai DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_giam_km DEFAULT 0,
    giam_gia_khu_hoi DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_giam_kh DEFAULT 0,
    tong_thanh_toan DECIMAL(12,2) NOT NULL CONSTRAINT DF_DAT_CHO_tong DEFAULT 0,
    thoi_gian_het_han DATETIME2(0) NOT NULL,
    trang_thai NVARCHAR(30) NOT NULL CONSTRAINT DF_DAT_CHO_trang_thai DEFAULT N'Chờ thanh toán',

    CONSTRAINT FK_DAT_CHO_KHACH_HANG FOREIGN KEY (khach_hang_id) REFERENCES dbo.KHACH_HANG(id),
    CONSTRAINT FK_DAT_CHO_KHUYEN_MAI FOREIGN KEY (khuyen_mai_id) REFERENCES dbo.KHUYEN_MAI(id),
    CONSTRAINT UQ_DAT_CHO_ma UNIQUE (ma_dat_cho),
    CONSTRAINT CK_DAT_CHO_loai_don CHECK (loai_don_hang IN (N'Cá nhân', N'Tập thể')),
    CONSTRAINT CK_DAT_CHO_loai_hanh_trinh CHECK (loai_hanh_trinh IN (N'Một chiều', N'Khứ hồi')),
    CONSTRAINT CK_DAT_CHO_tien CHECK (
        tong_tien_ve_goc >= 0
        AND thue_vat >= 0
        AND phi_thanh_toan >= 0
        AND tong_giam_khuyen_mai >= 0
        AND giam_gia_khu_hoi >= 0
        AND tong_thanh_toan >= 0
    ),
    CONSTRAINT CK_DAT_CHO_trang_thai CHECK (
        trang_thai IN (
            N'Chờ thanh toán',
            N'Đang thanh toán',
            N'Đã thanh toán',
            N'Hết hạn',
            N'Đã hủy',
            N'Hoàn tiền một phần',
            N'Hoàn tiền toàn bộ'
        )
    )
);
GO

CREATE TABLE dbo.GIU_CHO (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_GIU_CHO PRIMARY KEY,
    dat_cho_id INT NOT NULL,
    chuyen_tau_id INT NOT NULL,
    ghe_id INT NOT NULL,
    ga_di_id INT NOT NULL,
    ga_den_id INT NOT NULL,
    thoi_gian_giu DATETIME2(0) NOT NULL CONSTRAINT DF_GIU_CHO_thoi_gian_giu DEFAULT SYSDATETIME(),
    thoi_gian_het_han DATETIME2(0) NOT NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_GIU_CHO_trang_thai DEFAULT N'Đang giữ',

    CONSTRAINT FK_GIU_CHO_DAT_CHO FOREIGN KEY (dat_cho_id) REFERENCES dbo.DAT_CHO(id),
    CONSTRAINT FK_GIU_CHO_CHUYEN_TAU FOREIGN KEY (chuyen_tau_id) REFERENCES dbo.CHUYEN_TAU(id),
    CONSTRAINT FK_GIU_CHO_GHE FOREIGN KEY (ghe_id) REFERENCES dbo.GHE(id),
    CONSTRAINT FK_GIU_CHO_GA_DI FOREIGN KEY (ga_di_id) REFERENCES dbo.GA(id),
    CONSTRAINT FK_GIU_CHO_GA_DEN FOREIGN KEY (ga_den_id) REFERENCES dbo.GA(id),
    CONSTRAINT CK_GIU_CHO_ga CHECK (ga_di_id <> ga_den_id),
    CONSTRAINT CK_GIU_CHO_thoi_gian CHECK (thoi_gian_het_han > thoi_gian_giu),
    CONSTRAINT CK_GIU_CHO_trang_thai CHECK (trang_thai IN (N'Đang giữ', N'Đã chuyển vé', N'Hết hạn', N'Đã hủy'))
);
GO

CREATE TABLE dbo.VE (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_VE PRIMARY KEY,
    dat_cho_id INT NOT NULL,
    chuyen_tau_id INT NOT NULL,
    ghe_id INT NOT NULL,
    hanh_khach_id INT NOT NULL,
    doi_tuong_uu_dai_id INT NULL,
    ga_di_id INT NOT NULL,
    ga_den_id INT NOT NULL,
    ma_ve NVARCHAR(40) NOT NULL,
    gia_co_so DECIMAL(12,2) NOT NULL,
    giam_doi_tuong DECIMAL(12,2) NOT NULL CONSTRAINT DF_VE_giam_doi_tuong DEFAULT 0,
    phu_thu_cao_diem DECIMAL(12,2) NOT NULL CONSTRAINT DF_VE_phu_thu DEFAULT 0,
    gia_ve_chi_tiet DECIMAL(12,2) NOT NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_VE_trang_thai DEFAULT N'Chờ thanh toán',

    CONSTRAINT FK_VE_DAT_CHO FOREIGN KEY (dat_cho_id) REFERENCES dbo.DAT_CHO(id),
    CONSTRAINT FK_VE_CHUYEN_TAU FOREIGN KEY (chuyen_tau_id) REFERENCES dbo.CHUYEN_TAU(id),
    CONSTRAINT FK_VE_GHE FOREIGN KEY (ghe_id) REFERENCES dbo.GHE(id),
    CONSTRAINT FK_VE_HANH_KHACH FOREIGN KEY (hanh_khach_id) REFERENCES dbo.HANH_KHACH(id),
    CONSTRAINT FK_VE_DOI_TUONG_UU_DAI FOREIGN KEY (doi_tuong_uu_dai_id) REFERENCES dbo.DOI_TUONG_UU_DAI(id),
    CONSTRAINT FK_VE_GA_DI FOREIGN KEY (ga_di_id) REFERENCES dbo.GA(id),
    CONSTRAINT FK_VE_GA_DEN FOREIGN KEY (ga_den_id) REFERENCES dbo.GA(id),
    CONSTRAINT UQ_VE_ma UNIQUE (ma_ve),
    CONSTRAINT CK_VE_ga CHECK (ga_di_id <> ga_den_id),
    CONSTRAINT CK_VE_tien CHECK (
        gia_co_so >= 0
        AND giam_doi_tuong >= 0
        AND phu_thu_cao_diem >= 0
        AND gia_ve_chi_tiet >= 0
    ),
    CONSTRAINT CK_VE_trang_thai CHECK (trang_thai IN (N'Chờ thanh toán', N'Hợp lệ', N'Đã sử dụng', N'Đã trả', N'Đã hủy'))
);
GO

CREATE TABLE dbo.THANH_TOAN (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_THANH_TOAN PRIMARY KEY,
    dat_cho_id INT NOT NULL,
    ma_giao_dich NVARCHAR(100) NULL,
    request_id NVARCHAR(100) NOT NULL,
    phuong_thuc NVARCHAR(30) NOT NULL,
    so_tien DECIMAL(12,2) NOT NULL,
    ngay_tao DATETIME2(0) NOT NULL CONSTRAINT DF_THANH_TOAN_ngay_tao DEFAULT SYSDATETIME(),
    ngay_thanh_toan DATETIME2(0) NULL,
    trang_thai NVARCHAR(30) NOT NULL CONSTRAINT DF_THANH_TOAN_trang_thai DEFAULT N'Pending',

    CONSTRAINT FK_THANH_TOAN_DAT_CHO FOREIGN KEY (dat_cho_id) REFERENCES dbo.DAT_CHO(id),
    CONSTRAINT UQ_THANH_TOAN_request_id UNIQUE (request_id),
    CONSTRAINT CK_THANH_TOAN_phuong_thuc CHECK (phuong_thuc IN (N'VNPay', N'MoMo', N'OnePay', N'Tiền mặt', N'Chuyển khoản', N'ATM', N'Thẻ ATM')),
    CONSTRAINT CK_THANH_TOAN_so_tien CHECK (so_tien >= 0),
    CONSTRAINT CK_THANH_TOAN_trang_thai CHECK (trang_thai IN (N'Pending', N'Thành công', N'Thất bại', N'Hủy', N'Đang hoàn tiền', N'Đã hoàn tiền'))
);
GO

CREATE TABLE dbo.HOAN_TIEN (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_HOAN_TIEN PRIMARY KEY,
    thanh_toan_id INT NOT NULL,
    ve_id INT NOT NULL,
    so_tien_hoan DECIMAL(12,2) NOT NULL,
    ma_giao_dich_hoan NVARCHAR(100) NULL,
    thoi_gian_yeu_cau DATETIME2(0) NOT NULL CONSTRAINT DF_HOAN_TIEN_yeu_cau DEFAULT SYSDATETIME(),
    thoi_gian_hoan_tat DATETIME2(0) NULL,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_HOAN_TIEN_trang_thai DEFAULT N'Chờ xử lý',

    CONSTRAINT FK_HOAN_TIEN_THANH_TOAN FOREIGN KEY (thanh_toan_id) REFERENCES dbo.THANH_TOAN(id),
    CONSTRAINT FK_HOAN_TIEN_VE FOREIGN KEY (ve_id) REFERENCES dbo.VE(id),
    CONSTRAINT CK_HOAN_TIEN_tien CHECK (so_tien_hoan >= 0),
    CONSTRAINT CK_HOAN_TIEN_thoi_gian CHECK (thoi_gian_hoan_tat IS NULL OR thoi_gian_hoan_tat >= thoi_gian_yeu_cau),
    CONSTRAINT CK_HOAN_TIEN_trang_thai CHECK (trang_thai IN (N'Chờ xử lý', N'Hoàn tất', N'Từ chối'))
);
GO

/*=============================================================================
  5. NHÓM CHÍNH SÁCH ĐỔI/TRẢ VÀ LỊCH SỬ HẬU MÃI
=============================================================================*/

CREATE TABLE dbo.CHINH_SACH_DOI_TRA (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CHINH_SACH_DOI_TRA PRIMARY KEY,
    ten_chinh_sach NVARCHAR(200) NOT NULL,
    loai_don_hang_ap_dung NVARCHAR(20) NOT NULL CONSTRAINT DF_CSDT_loai_don DEFAULT N'Tất cả',
    chieu_tau_ap_dung NVARCHAR(20) NOT NULL CONSTRAINT DF_CSDT_chieu DEFAULT N'Tất cả',
    truoc_khoi_hanh_tu_gio INT NULL,
    truoc_khoi_hanh_den_gio INT NULL,
    ty_le_khau_tru DECIMAL(5,2) NOT NULL CONSTRAINT DF_CSDT_ty_le DEFAULT 0,
    phi_doi_co_dinh DECIMAL(12,2) NOT NULL CONSTRAINT DF_CSDT_phi_doi DEFAULT 0,
    cho_phep_doi BIT NOT NULL CONSTRAINT DF_CSDT_cho_doi DEFAULT 1,
    cho_phep_tra BIT NOT NULL CONSTRAINT DF_CSDT_cho_tra DEFAULT 1,
    hieu_luc_tu DATETIME2(0) NOT NULL,
    hieu_luc_den DATETIME2(0) NULL,
    do_uu_tien INT NOT NULL CONSTRAINT DF_CSDT_uu_tien DEFAULT 0,
    trang_thai NVARCHAR(20) NOT NULL CONSTRAINT DF_CSDT_trang_thai DEFAULT N'Hoạt động',

    CONSTRAINT CK_CSDT_loai_don CHECK (loai_don_hang_ap_dung IN (N'Cá nhân', N'Tập thể', N'Tất cả')),
    CONSTRAINT CK_CSDT_chieu CHECK (chieu_tau_ap_dung IN (N'Chẵn', N'Lẻ', N'Tất cả')),
    CONSTRAINT CK_CSDT_gio CHECK (
        (truoc_khoi_hanh_tu_gio IS NULL OR truoc_khoi_hanh_tu_gio >= 0)
        AND (truoc_khoi_hanh_den_gio IS NULL OR truoc_khoi_hanh_den_gio >= 0)
        AND (truoc_khoi_hanh_tu_gio IS NULL OR truoc_khoi_hanh_den_gio IS NULL OR truoc_khoi_hanh_tu_gio <= truoc_khoi_hanh_den_gio)
    ),
    CONSTRAINT CK_CSDT_tien CHECK (ty_le_khau_tru BETWEEN 0 AND 100 AND phi_doi_co_dinh >= 0),
    CONSTRAINT CK_CSDT_hieu_luc CHECK (hieu_luc_den IS NULL OR hieu_luc_tu < hieu_luc_den),
    CONSTRAINT CK_CSDT_trang_thai CHECK (trang_thai IN (N'Hoạt động', N'Tạm dừng', N'Hết hạn'))
);
GO

CREATE TABLE dbo.LICH_SU_DOI_TRA (
    id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_LICH_SU_DOI_TRA PRIMARY KEY,
    ve_id INT NOT NULL,
    nhan_vien_id INT NULL,
    chinh_sach_id INT NULL,
    loai_giao_dich NVARCHAR(20) NOT NULL,
    ly_do NVARCHAR(500) NULL,
    phi_doi DECIMAL(12,2) NOT NULL CONSTRAINT DF_LSDT_phi_doi DEFAULT 0,
    ty_le_khau_tru DECIMAL(5,2) NOT NULL CONSTRAINT DF_LSDT_ty_le DEFAULT 0,
    so_tien_hoan DECIMAL(12,2) NOT NULL CONSTRAINT DF_LSDT_hoan DEFAULT 0,
    thoi_gian_xu_ly DATETIME2(0) NOT NULL CONSTRAINT DF_LSDT_thoi_gian DEFAULT SYSDATETIME(),
    ghi_chu NVARCHAR(MAX) NULL,

    CONSTRAINT FK_LSDT_VE FOREIGN KEY (ve_id) REFERENCES dbo.VE(id),
    CONSTRAINT FK_LSDT_NHAN_VIEN FOREIGN KEY (nhan_vien_id) REFERENCES dbo.NHAN_VIEN(id),
    CONSTRAINT FK_LSDT_CHINH_SACH FOREIGN KEY (chinh_sach_id) REFERENCES dbo.CHINH_SACH_DOI_TRA(id),
    CONSTRAINT CK_LSDT_loai CHECK (loai_giao_dich IN (N'Đổi vé', N'Trả vé', N'Hủy vé')),
    CONSTRAINT CK_LSDT_tien CHECK (phi_doi >= 0 AND ty_le_khau_tru BETWEEN 0 AND 100 AND so_tien_hoan >= 0)
);
GO

/*=============================================================================
  6. INDEX PHỤC VỤ TRUY VẤN
=============================================================================*/

CREATE INDEX IX_TOA_TAU_tau_id ON dbo.TOA_TAU(tau_id);
CREATE INDEX IX_GHE_toa_tau_id ON dbo.GHE(toa_tau_id);
CREATE INDEX IX_CHUYEN_TAU_tau_ngay ON dbo.CHUYEN_TAU(tau_id, ngay_chay);
CREATE INDEX IX_LICH_DUNG_chuyen_thu_tu ON dbo.LICH_DUNG(chuyen_tau_id, thu_tu_dung);
CREATE INDEX IX_BANG_GIA_chang_loai ON dbo.BANG_GIA(ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, trang_thai);
CREATE INDEX IX_DAT_CHO_khach_trang_thai ON dbo.DAT_CHO(khach_hang_id, trang_thai, ngay_dat DESC);
CREATE INDEX IX_GIU_CHO_chuyen_ghe_trang_thai ON dbo.GIU_CHO(chuyen_tau_id, ghe_id, trang_thai, thoi_gian_het_han);
CREATE INDEX IX_VE_chuyen_ghe_trang_thai ON dbo.VE(chuyen_tau_id, ghe_id, trang_thai);
CREATE INDEX IX_VE_hanh_khach ON dbo.VE(hanh_khach_id);
CREATE INDEX IX_THANH_TOAN_dat_cho_trang_thai ON dbo.THANH_TOAN(dat_cho_id, trang_thai);
CREATE INDEX IX_HOAN_TIEN_ve_trang_thai ON dbo.HOAN_TIEN(ve_id, trang_thai);
CREATE INDEX IX_LSDT_ve ON dbo.LICH_SU_DOI_TRA(ve_id);

CREATE UNIQUE INDEX UX_THANH_TOAN_ma_giao_dich
ON dbo.THANH_TOAN(ma_giao_dich)
WHERE ma_giao_dich IS NOT NULL;


CREATE UNIQUE INDEX UX_HOAN_TIEN_ma_giao_dich_hoan
ON dbo.HOAN_TIEN(ma_giao_dich_hoan)
WHERE ma_giao_dich_hoan IS NOT NULL;

-- GĐ3: cleanup và đồng bộ trạng thái theo đơn.
CREATE INDEX IX_DAT_CHO_Cleanup ON dbo.DAT_CHO(trang_thai, thoi_gian_het_han);
CREATE INDEX IX_GIU_CHO_DatCho_TrangThai ON dbo.GIU_CHO(dat_cho_id, trang_thai);
CREATE INDEX IX_VE_DatCho_TrangThai ON dbo.VE(dat_cho_id, trang_thai);
CREATE INDEX IX_THANH_TOAN_DatCho_TrangThai ON dbo.THANH_TOAN(dat_cho_id, trang_thai);
CREATE INDEX IX_VE_Chuyen_Ghe_TrangThai ON dbo.VE(chuyen_tau_id, ghe_id, trang_thai);
CREATE INDEX IX_GIU_CHO_Chuyen_Ghe_TrangThai_HetHan ON dbo.GIU_CHO(chuyen_tau_id, ghe_id, trang_thai, thoi_gian_het_han);

-- GĐ4: refund admin DTO.
CREATE INDEX IX_HOAN_TIEN_TrangThai_ThoiGian
ON dbo.HOAN_TIEN(trang_thai, thoi_gian_yeu_cau DESC, id DESC)
INCLUDE (ve_id, thanh_toan_id, so_tien_hoan, ma_giao_dich_hoan, thoi_gian_hoan_tat);

CREATE INDEX IX_HOAN_TIEN_VeId_TrangThai
ON dbo.HOAN_TIEN(ve_id, trang_thai, id DESC)
INCLUDE (thanh_toan_id, so_tien_hoan, ma_giao_dich_hoan, thoi_gian_yeu_cau, thoi_gian_hoan_tat);

CREATE INDEX IX_HOAN_TIEN_ThanhToanId ON dbo.HOAN_TIEN(thanh_toan_id);

CREATE INDEX IX_LICH_SU_DOI_TRA_VeId_IdDesc
ON dbo.LICH_SU_DOI_TRA(ve_id, id DESC)
INCLUDE (ly_do, ty_le_khau_tru, phi_doi, so_tien_hoan, ghi_chu);

CREATE UNIQUE INDEX UX_HOAN_TIEN_OnePendingPerTicket
ON dbo.HOAN_TIEN(ve_id)
WHERE trang_thai = N'Chờ xử lý';

-- GĐ5: dashboard/reporting.
CREATE INDEX IX_THANH_TOAN_TrangThai_NgayThanhToan
ON dbo.THANH_TOAN(trang_thai, ngay_thanh_toan)
INCLUDE (so_tien, phuong_thuc, dat_cho_id);

CREATE INDEX IX_HOAN_TIEN_TrangThai_ThoiGianHoanTat
ON dbo.HOAN_TIEN(trang_thai, thoi_gian_hoan_tat)
INCLUDE (so_tien_hoan, ve_id, thanh_toan_id);

CREATE INDEX IX_DAT_CHO_TrangThai_NgayDat
ON dbo.DAT_CHO(trang_thai, ngay_dat)
INCLUDE (tong_thanh_toan, khach_hang_id, ma_dat_cho);

CREATE INDEX IX_VE_TrangThai_DatCho
ON dbo.VE(trang_thai, dat_cho_id)
INCLUDE (gia_ve_chi_tiet, ga_di_id, ga_den_id, ghe_id, chuyen_tau_id);

CREATE INDEX IX_KHACH_HANG_NgayTao
ON dbo.KHACH_HANG(ngay_tao)
INCLUDE (trang_thai);
GO


/*=============================================================================
  7. TRIGGER KIỂM TRA CHẶNG, CHỐNG TRÙNG GHẾ VÀ KIỂM SOÁT HOÀN TIỀN
=============================================================================*/

CREATE TRIGGER dbo.trg_GIU_CHO_ValidateSegmentAndOverlap
ON dbo.GIU_CHO
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Mọi giữ chỗ phải đi đúng chặng, đúng lịch dừng, ghế phải thuộc đúng tàu của chuyến.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.CHUYEN_TAU ct ON ct.id = i.chuyen_tau_id
        JOIN dbo.GHE ghe ON ghe.id = i.ghe_id
        JOIN dbo.TOA_TAU toa ON toa.id = ghe.toa_tau_id
        LEFT JOIN dbo.LICH_DUNG ld_di
            ON ld_di.chuyen_tau_id = i.chuyen_tau_id
           AND ld_di.ga_id = i.ga_di_id
        LEFT JOIN dbo.LICH_DUNG ld_den
            ON ld_den.chuyen_tau_id = i.chuyen_tau_id
           AND ld_den.ga_id = i.ga_den_id
        WHERE toa.tau_id <> ct.tau_id
           OR ld_di.id IS NULL
           OR ld_den.id IS NULL
           OR ld_di.thu_tu_dung >= ld_den.thu_tu_dung
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51010, N'GIU_CHO không hợp lệ: ghế phải thuộc đúng tàu, ga đi/ga đến phải thuộc lịch dừng và ga đi phải trước ga đến.', 1;
    END;

    DECLARE @I TABLE (
        id INT,
        dat_cho_id INT,
        chuyen_tau_id INT,
        ghe_id INT,
        thu_tu_di INT,
        thu_tu_den INT
    );

    INSERT INTO @I (id, dat_cho_id, chuyen_tau_id, ghe_id, thu_tu_di, thu_tu_den)
    SELECT
        i.id,
        i.dat_cho_id,
        i.chuyen_tau_id,
        i.ghe_id,
        ld_di.thu_tu_dung,
        ld_den.thu_tu_dung
    FROM inserted i
    JOIN dbo.LICH_DUNG ld_di
        ON ld_di.chuyen_tau_id = i.chuyen_tau_id
       AND ld_di.ga_id = i.ga_di_id
    JOIN dbo.LICH_DUNG ld_den
        ON ld_den.chuyen_tau_id = i.chuyen_tau_id
       AND ld_den.ga_id = i.ga_den_id
    WHERE i.trang_thai = N'Đang giữ';

    -- Chặn giữ chỗ trùng giữ chỗ khác trên cùng ghế/chặng giao nhau.
    IF EXISTS (
        SELECT 1
        FROM @I i
        JOIN dbo.GIU_CHO g WITH (UPDLOCK, HOLDLOCK)
            ON g.chuyen_tau_id = i.chuyen_tau_id
           AND g.ghe_id = i.ghe_id
           AND g.trang_thai = N'Đang giữ'
           AND g.id <> i.id
        JOIN dbo.LICH_DUNG g_di
            ON g_di.chuyen_tau_id = g.chuyen_tau_id
           AND g_di.ga_id = g.ga_di_id
        JOIN dbo.LICH_DUNG g_den
            ON g_den.chuyen_tau_id = g.chuyen_tau_id
           AND g_den.ga_id = g.ga_den_id
        WHERE i.thu_tu_di < g_den.thu_tu_dung
          AND g_di.thu_tu_dung < i.thu_tu_den
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51011, N'GIU_CHO bị trùng: ghế này đang được giữ trên một chặng giao nhau.', 1;
    END;

    -- Chặn giữ chỗ trùng với vé đã/chưa thanh toán nhưng đang chiếm ghế.
    IF EXISTS (
        SELECT 1
        FROM @I i
        JOIN dbo.VE v WITH (UPDLOCK, HOLDLOCK)
            ON v.chuyen_tau_id = i.chuyen_tau_id
           AND v.ghe_id = i.ghe_id
           AND v.trang_thai IN (N'Chờ thanh toán', N'Hợp lệ', N'Đã sử dụng')
           AND v.dat_cho_id <> i.dat_cho_id
        JOIN dbo.LICH_DUNG v_di
            ON v_di.chuyen_tau_id = v.chuyen_tau_id
           AND v_di.ga_id = v.ga_di_id
        JOIN dbo.LICH_DUNG v_den
            ON v_den.chuyen_tau_id = v.chuyen_tau_id
           AND v_den.ga_id = v.ga_den_id
        WHERE i.thu_tu_di < v_den.thu_tu_dung
          AND v_di.thu_tu_dung < i.thu_tu_den
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51012, N'GIU_CHO bị trùng: ghế này đã có vé đang chiếm trên một chặng giao nhau.', 1;
    END;
END;
GO

CREATE TRIGGER dbo.trg_VE_ValidateSegmentAndOverlap
ON dbo.VE
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Mọi vé phải đi đúng chặng, đúng lịch dừng, ghế phải thuộc đúng tàu của chuyến.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.CHUYEN_TAU ct ON ct.id = i.chuyen_tau_id
        JOIN dbo.GHE ghe ON ghe.id = i.ghe_id
        JOIN dbo.TOA_TAU toa ON toa.id = ghe.toa_tau_id
        LEFT JOIN dbo.LICH_DUNG ld_di
            ON ld_di.chuyen_tau_id = i.chuyen_tau_id
           AND ld_di.ga_id = i.ga_di_id
        LEFT JOIN dbo.LICH_DUNG ld_den
            ON ld_den.chuyen_tau_id = i.chuyen_tau_id
           AND ld_den.ga_id = i.ga_den_id
        WHERE toa.tau_id <> ct.tau_id
           OR ld_di.id IS NULL
           OR ld_den.id IS NULL
           OR ld_di.thu_tu_dung >= ld_den.thu_tu_dung
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51020, N'VE không hợp lệ: ghế phải thuộc đúng tàu, ga đi/ga đến phải thuộc lịch dừng và ga đi phải trước ga đến.', 1;
    END;

    DECLARE @I TABLE (
        id INT,
        dat_cho_id INT,
        chuyen_tau_id INT,
        ghe_id INT,
        thu_tu_di INT,
        thu_tu_den INT
    );

    INSERT INTO @I (id, dat_cho_id, chuyen_tau_id, ghe_id, thu_tu_di, thu_tu_den)
    SELECT
        i.id,
        i.dat_cho_id,
        i.chuyen_tau_id,
        i.ghe_id,
        ld_di.thu_tu_dung,
        ld_den.thu_tu_dung
    FROM inserted i
    JOIN dbo.LICH_DUNG ld_di
        ON ld_di.chuyen_tau_id = i.chuyen_tau_id
       AND ld_di.ga_id = i.ga_di_id
    JOIN dbo.LICH_DUNG ld_den
        ON ld_den.chuyen_tau_id = i.chuyen_tau_id
       AND ld_den.ga_id = i.ga_den_id
    WHERE i.trang_thai IN (N'Chờ thanh toán', N'Hợp lệ', N'Đã sử dụng');

    -- Chặn vé trùng vé đang chiếm ghế.
    IF EXISTS (
        SELECT 1
        FROM @I i
        JOIN dbo.VE v WITH (UPDLOCK, HOLDLOCK)
            ON v.chuyen_tau_id = i.chuyen_tau_id
           AND v.ghe_id = i.ghe_id
           AND v.trang_thai IN (N'Chờ thanh toán', N'Hợp lệ', N'Đã sử dụng')
           AND v.id <> i.id
        JOIN dbo.LICH_DUNG v_di
            ON v_di.chuyen_tau_id = v.chuyen_tau_id
           AND v_di.ga_id = v.ga_di_id
        JOIN dbo.LICH_DUNG v_den
            ON v_den.chuyen_tau_id = v.chuyen_tau_id
           AND v_den.ga_id = v.ga_den_id
        WHERE i.thu_tu_di < v_den.thu_tu_dung
          AND v_di.thu_tu_dung < i.thu_tu_den
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51021, N'VE bị trùng: ghế này đã có vé đang chiếm trên một chặng giao nhau.', 1;
    END;

    -- Chặn vé trùng với giữ chỗ đang active của đơn khác.
    IF EXISTS (
        SELECT 1
        FROM @I i
        JOIN dbo.GIU_CHO g WITH (UPDLOCK, HOLDLOCK)
            ON g.chuyen_tau_id = i.chuyen_tau_id
           AND g.ghe_id = i.ghe_id
           AND g.trang_thai = N'Đang giữ'
           AND g.dat_cho_id <> i.dat_cho_id
        JOIN dbo.LICH_DUNG g_di
            ON g_di.chuyen_tau_id = g.chuyen_tau_id
           AND g_di.ga_id = g.ga_di_id
        JOIN dbo.LICH_DUNG g_den
            ON g_den.chuyen_tau_id = g.chuyen_tau_id
           AND g_den.ga_id = g.ga_den_id
        WHERE i.thu_tu_di < g_den.thu_tu_dung
          AND g_di.thu_tu_dung < i.thu_tu_den
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51022, N'VE bị trùng: ghế này đang được giữ bởi đơn khác trên chặng giao nhau.', 1;
    END;
END;
GO

CREATE TRIGGER dbo.trg_HOAN_TIEN_ValidatePaymentTicket
ON dbo.HOAN_TIEN
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Vé hoàn tiền phải thuộc cùng DAT_CHO với giao dịch thanh toán.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.VE v ON v.id = i.ve_id
        JOIN dbo.THANH_TOAN tt ON tt.id = i.thanh_toan_id
        WHERE v.dat_cho_id <> tt.dat_cho_id
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51030, N'HOAN_TIEN không hợp lệ: vé và thanh toán không thuộc cùng đơn đặt chỗ.', 1;
    END;

    -- Không hoàn quá số tiền đã thanh toán.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN dbo.THANH_TOAN tt ON tt.id = i.thanh_toan_id
        WHERE i.so_tien_hoan > tt.so_tien
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51031, N'HOAN_TIEN không hợp lệ: số tiền hoàn lớn hơn số tiền thanh toán.', 1;
    END;

    -- Hoàn tất thì bắt buộc có thời gian hoàn tất.
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE trang_thai = N'Hoàn tất'
          AND thoi_gian_hoan_tat IS NULL
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51032, N'HOAN_TIEN không hợp lệ: trạng thái Hoàn tất phải có thời gian hoàn tất.', 1;
    END;
END;
GO

/*=============================================================================
  8. GỢI Ý QUY ƯỚC TRẠNG THÁI TRONG SERVICE LAYER
=============================================================================*/
/*
DAT_CHO:
  Chờ thanh toán -> Đang thanh toán -> Đã thanh toán
  Chờ thanh toán -> Hết hạn / Đã hủy
  Đã thanh toán -> Hoàn tiền một phần / Hoàn tiền toàn bộ

THANH_TOAN:
  Pending -> Thành công / Thất bại / Hủy
  Thành công -> Đang hoàn tiền -> Đã hoàn tiền

GIU_CHO:
  Đang giữ -> Đã chuyển vé / Hết hạn / Đã hủy

VE:
  Chờ thanh toán -> Hợp lệ -> Đã sử dụng / Đã trả / Đã hủy
*/
GO

PRINT N'Đã tạo xong schema VeTauDB theo ERD cải tiến.';
GO


/*=============================================================================
  9. DỮ LIỆU MẪU GIAI ĐOẠN 2 THEO ERD + USE CASE
=============================================================================*/

/*
===============================================================================
  Phần dữ liệu mẫu trong VeTauDB.sql
  Dữ liệu mẫu theo ERD + Use Case cải tiến cho VeTauDB
-------------------------------------------------------------------------------
  Mục tiêu Giai đoạn 2:
  - Có dữ liệu để tìm chuyến.
  - Có dữ liệu để chọn toa/ghế.
  - Có dữ liệu để kiểm tra ghế trống theo chặng qua GIU_CHO + VE.
  - Có dữ liệu để đặt vé, giữ chỗ, thanh toán giả lập.
  - Có dữ liệu để tính giá, phụ thu cao điểm, khuyến mãi, ưu đãi.
  - Có dữ liệu nền cho chính sách đổi/trả và hoàn tiền sau này.

  Cách chạy:
  Chạy toàn bộ file VeTauDB.sql một lần trong SSMS.

  Ghi chú:
  - File này dùng ngày động dựa trên SYSDATETIME(), nên luôn tạo chuyến tương lai.
  - File được viết theo hướng idempotent tương đối: nếu mã mẫu đã tồn tại thì không insert lại.
===============================================================================
*/

USE VeTauDB_CaiTien;
GO

SET NOCOUNT ON;

DECLARE @now DATETIME2(0) = SYSDATETIME();
DECLARE @today DATE = CAST(@now AS DATE);
DECLARE @ngayDi1 DATE = DATEADD(DAY, 1, @today);
DECLARE @ngayDi2 DATE = DATEADD(DAY, 2, @today);
DECLARE @ngayDi3 DATE = DATEADD(DAY, 3, @today);

DECLARE @base1 DATETIME2(0) = CAST(@ngayDi1 AS DATETIME2(0));
DECLARE @base2 DATETIME2(0) = CAST(@ngayDi2 AS DATETIME2(0));
DECLARE @base3 DATETIME2(0) = CAST(@ngayDi3 AS DATETIME2(0));

/*=============================================================================
  1. TÀI KHOẢN MẪU: KHÁCH HÀNG, ADMIN, NHÂN VIÊN
=============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.KHACH_HANG WHERE email = N'nguyenvana@example.com')
BEGIN
    INSERT INTO dbo.KHACH_HANG (ho_ten, email, so_dien_thoai, mat_khau_hash, ngay_sinh, gioi_tinh, dia_chi)
    VALUES (N'Nguyễn Văn A', N'nguyenvana@example.com', N'0900000001', N'123456_hash_demo', '1995-05-12', N'Nam', N'Hà Nội');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.KHACH_HANG WHERE email = N'tranthib@example.com')
BEGIN
    INSERT INTO dbo.KHACH_HANG (ho_ten, email, so_dien_thoai, mat_khau_hash, ngay_sinh, gioi_tinh, dia_chi)
    VALUES (N'Trần Thị B', N'tranthib@example.com', N'0900000002', N'123456_hash_demo', '2000-09-20', N'Nữ', N'Đà Nẵng');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.NHAN_VIEN WHERE email = N'admin@vetau.local')
BEGIN
    INSERT INTO dbo.NHAN_VIEN (ho_ten, email, mat_khau_hash, chuc_vu)
    VALUES (N'Quản trị viên Demo', N'admin@vetau.local', N'admin_hash_demo', N'Admin');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.NHAN_VIEN WHERE email = N'nvquay@vetau.local')
BEGIN
    INSERT INTO dbo.NHAN_VIEN (ho_ten, email, mat_khau_hash, chuc_vu)
    VALUES (N'Nhân viên quầy Demo', N'nvquay@vetau.local', N'nv_hash_demo', N'Nhân viên');
END;

/*=============================================================================
  2. GA MẪU
=============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'HNO')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'HNO', N'Hà Nội', N'Hà Nội', 0, N'120 Lê Duẩn, Hoàn Kiếm, Hà Nội');

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'VIN')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'VIN', N'Vinh', N'Nghệ An', 319, N'Đường Lê Ninh, TP Vinh');

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'HUE')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'HUE', N'Huế', N'Thừa Thiên Huế', 688, N'02 Bùi Thị Xuân, TP Huế');

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'DNA')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'DNA', N'Đà Nẵng', N'Đà Nẵng', 791, N'791 Hải Phòng, Đà Nẵng');

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'NTR')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'NTR', N'Nha Trang', N'Khánh Hòa', 1315, N'17 Thái Nguyên, Nha Trang');

IF NOT EXISTS (SELECT 1 FROM dbo.GA WHERE ma_ga = N'SGN')
    INSERT INTO dbo.GA (ma_ga, ten_ga, tinh_thanh, ly_trinh_km, dia_chi)
    VALUES (N'SGN', N'Sài Gòn', N'TP. Hồ Chí Minh', 1726, N'01 Nguyễn Thông, Quận 3, TP.HCM');

DECLARE @gaHNO INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'HNO');
DECLARE @gaVIN INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'VIN');
DECLARE @gaHUE INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'HUE');
DECLARE @gaDNA INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'DNA');
DECLARE @gaNTR INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'NTR');
DECLARE @gaSGN INT = (SELECT id FROM dbo.GA WHERE ma_ga = N'SGN');


/*=============================================================================
  3. TÀU - TOA - GHẾ MẪU
=============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.TAU WHERE ma_tau = N'SE1')
BEGIN
    INSERT INTO dbo.TAU (ma_tau, ten_tau, chieu_di, thuoc_tuyen_thong_nhat, mo_ta)
    VALUES (N'SE1', N'Tàu Thống Nhất SE1', N'Lẻ', 1, N'Tàu chiều Hà Nội đi Sài Gòn');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.TAU WHERE ma_tau = N'SE2')
BEGIN
    INSERT INTO dbo.TAU (ma_tau, ten_tau, chieu_di, thuoc_tuyen_thong_nhat, mo_ta)
    VALUES (N'SE2', N'Tàu Thống Nhất SE2', N'Chẵn', 1, N'Tàu chiều Sài Gòn đi Hà Nội');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.TAU WHERE ma_tau = N'TN1')
BEGIN
    INSERT INTO dbo.TAU (ma_tau, ten_tau, chieu_di, thuoc_tuyen_thong_nhat, mo_ta)
    VALUES (N'TN1', N'Tàu Nhanh TN1', N'Lẻ', 1, N'Tàu tăng cường dùng cho test khuyến mãi');
END;

DECLARE @tauSE1 INT = (SELECT id FROM dbo.TAU WHERE ma_tau = N'SE1');
DECLARE @tauSE2 INT = (SELECT id FROM dbo.TAU WHERE ma_tau = N'SE2');
DECLARE @tauTN1 INT = (SELECT id FROM dbo.TAU WHERE ma_tau = N'TN1');

DECLARE @TauMau TABLE (tau_id INT, so_toa INT, loai_toa NVARCHAR(40), suc_chua INT);
INSERT INTO @TauMau (tau_id, so_toa, loai_toa, suc_chua)
VALUES
(@tauSE1, 1, N'Ghế ngồi mềm', 12),
(@tauSE1, 2, N'Nằm mềm 4 người', 8),
(@tauSE2, 1, N'Ghế ngồi mềm', 12),
(@tauSE2, 2, N'Nằm mềm 4 người', 8),
(@tauTN1, 1, N'Ghế ngồi cứng', 10),
(@tauTN1, 2, N'Ghế ngồi mềm', 12);

INSERT INTO dbo.TOA_TAU (tau_id, so_toa, loai_toa, suc_chua)
SELECT tm.tau_id, tm.so_toa, tm.loai_toa, tm.suc_chua
FROM @TauMau tm
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.TOA_TAU t
    WHERE t.tau_id = tm.tau_id AND t.so_toa = tm.so_toa
);

DECLARE @toaId INT;
DECLARE @sucChua INT;
DECLARE @loaiToa NVARCHAR(40);
DECLARE cur_toa CURSOR LOCAL FAST_FORWARD FOR
    SELECT id, suc_chua, loai_toa FROM dbo.TOA_TAU WHERE tau_id IN (@tauSE1, @tauSE2, @tauTN1);

OPEN cur_toa;
FETCH NEXT FROM cur_toa INTO @toaId, @sucChua, @loaiToa;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @sucChua
    BEGIN
        DECLARE @soGhe NVARCHAR(10) = CASE WHEN @loaiToa LIKE N'Nằm%' THEN N'B' ELSE N'G' END + RIGHT(N'00' + CAST(@i AS NVARCHAR(3)), 2);
        DECLARE @tang INT = CASE WHEN @loaiToa LIKE N'Nằm%' THEN ((@i - 1) % 2) + 1 ELSE NULL END;
        DECLARE @loaiCho NVARCHAR(20) = CASE WHEN @loaiToa LIKE N'Nằm%' THEN N'Giường' ELSE N'Ghế' END;

        IF NOT EXISTS (SELECT 1 FROM dbo.GHE WHERE toa_tau_id = @toaId AND so_ghe = @soGhe)
        BEGIN
            INSERT INTO dbo.GHE (toa_tau_id, so_ghe, tang, loai_cho)
            VALUES (@toaId, @soGhe, @tang, @loaiCho);
        END;

        SET @i += 1;
    END;

    FETCH NEXT FROM cur_toa INTO @toaId, @sucChua, @loaiToa;
END;
CLOSE cur_toa;
DEALLOCATE cur_toa;

/*=============================================================================
  4. CHUYẾN TÀU VÀ LỊCH DỪNG MẪU (TỪ 07/05/2026 ĐẾN 15/06/2026)
=============================================================================*/

DECLARE @startDate DATE = '2026-05-07';
DECLARE @endDate DATE = '2026-06-15';
DECLARE @currentDate DATE = @startDate;

WHILE @currentDate <= @endDate
BEGIN
    -- Format mã ngày: yyyyMMdd (VD: 20260507)
    DECLARE @dateStr NVARCHAR(8) = FORMAT(@currentDate, 'yyyyMMdd');
    
    -- Mặc định SE1 chạy lúc 08:00, SE2 chạy lúc 06:00, TN1 chạy lúc 09:00
    DECLARE @gioSE1 DATETIME2(0) = DATEADD(HOUR, 8, CAST(@currentDate AS DATETIME2(0)));
    DECLARE @gioSE2 DATETIME2(0) = DATEADD(HOUR, 6, CAST(@currentDate AS DATETIME2(0)));
    DECLARE @gioTN1 DATETIME2(0) = DATEADD(HOUR, 9, CAST(@currentDate AS DATETIME2(0)));

    DECLARE @maSE1 NVARCHAR(30) = N'SE1-' + @dateStr;
    DECLARE @maSE2 NVARCHAR(30) = N'SE2-' + @dateStr;
    DECLARE @maTN1 NVARCHAR(30) = N'TN1-' + @dateStr;

    -- 4.1 Tạo chuyến tàu
    IF NOT EXISTS (SELECT 1 FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maSE1)
        INSERT INTO dbo.CHUYEN_TAU (tau_id, ma_chuyen, ngay_chay, gio_khoi_hanh, gio_den_du_kien)
        VALUES (@tauSE1, @maSE1, @currentDate, @gioSE1, DATEADD(HOUR, 36, @gioSE1));

    IF NOT EXISTS (SELECT 1 FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maSE2)
        INSERT INTO dbo.CHUYEN_TAU (tau_id, ma_chuyen, ngay_chay, gio_khoi_hanh, gio_den_du_kien)
        VALUES (@tauSE2, @maSE2, @currentDate, @gioSE2, DATEADD(HOUR, 36, @gioSE2));

    IF NOT EXISTS (SELECT 1 FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maTN1)
        INSERT INTO dbo.CHUYEN_TAU (tau_id, ma_chuyen, ngay_chay, gio_khoi_hanh, gio_den_du_kien)
        VALUES (@tauTN1, @maTN1, @currentDate, @gioTN1, DATEADD(HOUR, 18, @gioTN1));

    -- Lấy ID của các chuyến vừa tạo
    DECLARE @ctSE1 INT = (SELECT id FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maSE1);
    DECLARE @ctSE2 INT = (SELECT id FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maSE2);
    DECLARE @ctTN1 INT = (SELECT id FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maTN1);

    -- 4.2 Tạo lịch dừng dùng bảng tạm
    DECLARE @LichDung TABLE (chuyen_tau_id INT, ga_id INT, thu_tu INT, den DATETIME2(0), di DATETIME2(0));
    DELETE FROM @LichDung;

    -- SE1: Hà Nội -> Vinh -> Huế -> Đà Nẵng -> Nha Trang -> Sài Gòn
    INSERT INTO @LichDung VALUES
    (@ctSE1, @gaHNO, 1, NULL,                 @gioSE1),
    (@ctSE1, @gaVIN, 2, DATEADD(HOUR, 6, @gioSE1),  DATEADD(MINUTE, 390, @gioSE1)),
    (@ctSE1, @gaHUE, 3, DATEADD(HOUR, 14, @gioSE1), DATEADD(MINUTE, 870, @gioSE1)),
    (@ctSE1, @gaDNA, 4, DATEADD(HOUR, 16, @gioSE1), DATEADD(MINUTE, 990, @gioSE1)),
    (@ctSE1, @gaNTR, 5, DATEADD(HOUR, 26, @gioSE1), DATEADD(MINUTE, 1590, @gioSE1)),
    (@ctSE1, @gaSGN, 6, DATEADD(HOUR, 36, @gioSE1), NULL);

    -- SE2: Sài Gòn -> Nha Trang -> Đà Nẵng -> Huế -> Vinh -> Hà Nội
    INSERT INTO @LichDung VALUES
    (@ctSE2, @gaSGN, 1, NULL,                 @gioSE2),
    (@ctSE2, @gaNTR, 2, DATEADD(HOUR, 8, @gioSE2),  DATEADD(MINUTE, 495, @gioSE2)),
    (@ctSE2, @gaDNA, 3, DATEADD(HOUR, 20, @gioSE2), DATEADD(MINUTE, 1215, @gioSE2)),
    (@ctSE2, @gaHUE, 4, DATEADD(HOUR, 22, @gioSE2), DATEADD(MINUTE, 1335, @gioSE2)),
    (@ctSE2, @gaVIN, 5, DATEADD(HOUR, 30, @gioSE2), DATEADD(MINUTE, 1815, @gioSE2)),
    (@ctSE2, @gaHNO, 6, DATEADD(HOUR, 36, @gioSE2), NULL);

    -- TN1: Hà Nội -> Vinh -> Huế -> Đà Nẵng
    INSERT INTO @LichDung VALUES
    (@ctTN1, @gaHNO, 1, NULL,                 @gioTN1),
    (@ctTN1, @gaVIN, 2, DATEADD(HOUR, 6, @gioTN1),  DATEADD(MINUTE, 385, @gioTN1)),
    (@ctTN1, @gaHUE, 3, DATEADD(HOUR, 14, @gioTN1), DATEADD(MINUTE, 865, @gioTN1)),
    (@ctTN1, @gaDNA, 4, DATEADD(HOUR, 18, @gioTN1), NULL);

    -- Đẩy từ bảng tạm vào bảng thật
    INSERT INTO dbo.LICH_DUNG (chuyen_tau_id, ga_id, thu_tu_dung, thoi_gian_den, thoi_gian_di)
    SELECT ld.chuyen_tau_id, ld.ga_id, ld.thu_tu, ld.den, ld.di
    FROM @LichDung ld
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.LICH_DUNG x
        WHERE x.chuyen_tau_id = ld.chuyen_tau_id AND x.ga_id = ld.ga_id
    );

    -- Chuyển sang ngày tiếp theo trong vòng lặp
    SET @currentDate = DATEADD(DAY, 1, @currentDate);
END;

-- Chốt lại chuyến SE1 dùng cho dữ liệu demo ngày @ngayDi1.
-- Tránh bug dùng nhầm @ctSE1 của ngày cuối cùng trong vòng WHILE tạo chuyến.
DECLARE @ctSE1Demo INT = (
    SELECT id
    FROM dbo.CHUYEN_TAU
    WHERE ma_chuyen = N'SE1-' + CONVERT(CHAR(8), @ngayDi1, 112)
);

IF @ctSE1Demo IS NULL
BEGIN
    ;THROW 51040, N'Không tìm thấy chuyến SE1 demo theo @ngayDi1. Kiểm tra khoảng ngày tạo CHUYEN_TAU.', 1;
END;

/*=============================================================================
  5. BẢNG GIÁ, ƯU ĐÃI, KHUYẾN MÃI, CHÍNH SÁCH ĐỔI/TRẢ
=============================================================================*/

DECLARE @hieuLucTu DATETIME2(0) = DATEADD(DAY, -30, @now);
DECLARE @hieuLucDen DATETIME2(0) = DATEADD(YEAR, 1, @now);

DECLARE @GiaChang TABLE (
    ga_di_id INT,
    ga_den_id INT,
    gia_ghe_mem DECIMAL(12,2),
    gia_ghe_cung DECIMAL(12,2),
    gia_nam_mem DECIMAL(12,2),
    phu_thu DECIMAL(12,2)
);

INSERT INTO @GiaChang VALUES
(@gaHNO, @gaVIN, 220000, 170000, 330000, 10000),
(@gaHNO, @gaHUE, 420000, 350000, 610000, 20000),
(@gaHNO, @gaDNA, 480000, 390000, 690000, 25000),
(@gaHNO, @gaNTR, 720000, 590000, 980000, 35000),
(@gaHNO, @gaSGN, 890000, 720000, 1180000, 50000),
(@gaVIN, @gaHUE, 260000, 210000, 390000, 15000),
(@gaVIN, @gaDNA, 330000, 270000, 460000, 18000),
(@gaVIN, @gaSGN, 760000, 620000, 1030000, 45000),
(@gaHUE, @gaDNA, 120000, 90000, 180000, 5000),
(@gaDNA, @gaNTR, 350000, 280000, 500000, 20000),
(@gaDNA, @gaSGN, 560000, 460000, 790000, 30000),
(@gaNTR, @gaSGN, 260000, 210000, 390000, 15000);

-- Giá ghế mềm chiều xuôi
INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT ga_di_id, ga_den_id, N'Ghế ngồi mềm', NULL, gia_ghe_mem, phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_di_id AND bg.ga_den_id = g.ga_den_id
      AND bg.loai_toa_ap_dung = N'Ghế ngồi mềm' AND bg.tang_ap_dung IS NULL AND bg.trang_thai = N'Hoạt động'
);

-- Giá ghế mềm chiều ngược
INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT ga_den_id, ga_di_id, N'Ghế ngồi mềm', NULL, gia_ghe_mem, phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_den_id AND bg.ga_den_id = g.ga_di_id
      AND bg.loai_toa_ap_dung = N'Ghế ngồi mềm' AND bg.tang_ap_dung IS NULL AND bg.trang_thai = N'Hoạt động'
);

-- Giá ghế cứng chiều xuôi/ngược
INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT ga_di_id, ga_den_id, N'Ghế ngồi cứng', NULL, gia_ghe_cung, phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_di_id AND bg.ga_den_id = g.ga_den_id
      AND bg.loai_toa_ap_dung = N'Ghế ngồi cứng' AND bg.tang_ap_dung IS NULL AND bg.trang_thai = N'Hoạt động'
);

INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT ga_den_id, ga_di_id, N'Ghế ngồi cứng', NULL, gia_ghe_cung, phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_den_id AND bg.ga_den_id = g.ga_di_id
      AND bg.loai_toa_ap_dung = N'Ghế ngồi cứng' AND bg.tang_ap_dung IS NULL AND bg.trang_thai = N'Hoạt động'
);

-- Giá nằm mềm 4 người cho tầng 1 và tầng 2, chiều xuôi/ngược
DECLARE @TangGiaBang TABLE (tang INT, he_so DECIMAL(6,2));
INSERT INTO @TangGiaBang VALUES (1, 1.00), (2, 0.95);

INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT g.ga_di_id, g.ga_den_id, N'Nằm mềm 4 người', t.tang, ROUND(g.gia_nam_mem * t.he_so, 0), g.phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g CROSS JOIN @TangGiaBang t
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_di_id AND bg.ga_den_id = g.ga_den_id
      AND bg.loai_toa_ap_dung = N'Nằm mềm 4 người' AND bg.tang_ap_dung = t.tang AND bg.trang_thai = N'Hoạt động'
);

INSERT INTO dbo.BANG_GIA (ga_di_id, ga_den_id, loai_toa_ap_dung, tang_ap_dung, gia_co_so, phu_thu_cao_diem_mac_dinh, hieu_luc_tu, hieu_luc_den)
SELECT g.ga_den_id, g.ga_di_id, N'Nằm mềm 4 người', t.tang, ROUND(g.gia_nam_mem * t.he_so, 0), g.phu_thu, @hieuLucTu, @hieuLucDen
FROM @GiaChang g CROSS JOIN @TangGiaBang t
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.BANG_GIA bg
    WHERE bg.ga_di_id = g.ga_den_id AND bg.ga_den_id = g.ga_di_id
      AND bg.loai_toa_ap_dung = N'Nằm mềm 4 người' AND bg.tang_ap_dung = t.tang AND bg.trang_thai = N'Hoạt động'
);

-- Đối tượng ưu đãi
IF NOT EXISTS (SELECT 1 FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'NL')
    INSERT INTO dbo.DOI_TUONG_UU_DAI (ma_doi_tuong, ten_doi_tuong, phan_tram_giam, tuoi_min, tuoi_max, can_giay_to_chung_minh, hieu_luc_tu, hieu_luc_den)
    VALUES (N'NL', N'Người lớn', 0, 12, NULL, 0, @hieuLucTu, @hieuLucDen);

IF NOT EXISTS (SELECT 1 FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'TRE_EM')
    INSERT INTO dbo.DOI_TUONG_UU_DAI (ma_doi_tuong, ten_doi_tuong, phan_tram_giam, tuoi_min, tuoi_max, can_giay_to_chung_minh, hieu_luc_tu, hieu_luc_den)
    VALUES (N'TRE_EM', N'Trẻ em', 25, 0, 10, 1, @hieuLucTu, @hieuLucDen);

IF NOT EXISTS (SELECT 1 FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'SV')
    INSERT INTO dbo.DOI_TUONG_UU_DAI (ma_doi_tuong, ten_doi_tuong, phan_tram_giam, tuoi_min, tuoi_max, can_giay_to_chung_minh, hieu_luc_tu, hieu_luc_den)
    VALUES (N'SV', N'Học sinh / Sinh viên', 10, 11, 26, 1, @hieuLucTu, @hieuLucDen);

IF NOT EXISTS (SELECT 1 FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'NCT')
    INSERT INTO dbo.DOI_TUONG_UU_DAI (ma_doi_tuong, ten_doi_tuong, phan_tram_giam, tuoi_min, tuoi_max, can_giay_to_chung_minh, hieu_luc_tu, hieu_luc_den)
    VALUES (N'NCT', N'Người cao tuổi', 15, 60, NULL, 1, @hieuLucTu, @hieuLucDen);

-- Khuyến mãi
IF NOT EXISTS (SELECT 1 FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = N'KM10ONLINE')
    INSERT INTO dbo.KHUYEN_MAI (ma_khuyen_mai, ten_chuong_trinh, phan_tram_giam, giam_toi_da, gia_tri_don_toi_thieu, phuong_thuc_tt_ap_dung, ngay_bat_dau, ngay_ket_thuc, so_luong_toi_da)
    VALUES (N'KM10ONLINE', N'Giảm 10% thanh toán online', 10, 100000, 200000, N'VNPay', @hieuLucTu, @hieuLucDen, 1000);

IF NOT EXISTS (SELECT 1 FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = N'KM5ALL')
    INSERT INTO dbo.KHUYEN_MAI (ma_khuyen_mai, ten_chuong_trinh, phan_tram_giam, giam_toi_da, gia_tri_don_toi_thieu, phuong_thuc_tt_ap_dung, ngay_bat_dau, ngay_ket_thuc, so_luong_toi_da)
    VALUES (N'KM5ALL', N'Giảm 5% cho mọi phương thức', 5, 50000, 150000, NULL, @hieuLucTu, @hieuLucDen, 2000);

-- Chính sách đổi/trả
IF NOT EXISTS (SELECT 1 FROM dbo.CHINH_SACH_DOI_TRA WHERE ten_chinh_sach = N'Trả vé trước 24 giờ - cá nhân')
    INSERT INTO dbo.CHINH_SACH_DOI_TRA (ten_chinh_sach, loai_don_hang_ap_dung, chieu_tau_ap_dung, truoc_khoi_hanh_tu_gio, truoc_khoi_hanh_den_gio, ty_le_khau_tru, phi_doi_co_dinh, cho_phep_doi, cho_phep_tra, hieu_luc_tu, hieu_luc_den, do_uu_tien)
    VALUES (N'Trả vé trước 24 giờ - cá nhân', N'Cá nhân', N'Tất cả', 24, NULL, 10, 20000, 1, 1, @hieuLucTu, @hieuLucDen, 10);

IF NOT EXISTS (SELECT 1 FROM dbo.CHINH_SACH_DOI_TRA WHERE ten_chinh_sach = N'Trả vé từ 4 đến dưới 24 giờ')
    INSERT INTO dbo.CHINH_SACH_DOI_TRA (ten_chinh_sach, loai_don_hang_ap_dung, chieu_tau_ap_dung, truoc_khoi_hanh_tu_gio, truoc_khoi_hanh_den_gio, ty_le_khau_tru, phi_doi_co_dinh, cho_phep_doi, cho_phep_tra, hieu_luc_tu, hieu_luc_den, do_uu_tien)
    VALUES (N'Trả vé từ 4 đến dưới 24 giờ', N'Tất cả', N'Tất cả', 4, 24, 20, 30000, 1, 1, @hieuLucTu, @hieuLucDen, 20);

/*=============================================================================
  6. HÀNH KHÁCH, ĐƠN ĐẶT CHỖ, GIỮ CHỖ, VÉ VÀ THANH TOÁN MẪU
=============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'001199500001')
    INSERT INTO dbo.HANH_KHACH (ho_ten, loai_giay_to, so_giay_to, ngay_sinh, quoc_tich)
    VALUES (N'Nguyễn Văn A', N'CCCD', N'001199500001', '1995-05-12', N'Việt Nam');

IF NOT EXISTS (SELECT 1 FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'048200000002')
    INSERT INTO dbo.HANH_KHACH (ho_ten, loai_giay_to, so_giay_to, ngay_sinh, quoc_tich)
    VALUES (N'Lê Thị C', N'CCCD', N'048200000002', '2000-02-18', N'Việt Nam');

IF NOT EXISTS (SELECT 1 FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'075200300003')
    INSERT INTO dbo.HANH_KHACH (ho_ten, loai_giay_to, so_giay_to, ngay_sinh, quoc_tich)
    VALUES (N'Phạm Minh D', N'CCCD', N'075200300003', '2003-10-05', N'Việt Nam');

DECLARE @khA INT = (SELECT id FROM dbo.KHACH_HANG WHERE email = N'nguyenvana@example.com');
DECLARE @khB INT = (SELECT id FROM dbo.KHACH_HANG WHERE email = N'tranthib@example.com');
DECLARE @hkA INT = (SELECT id FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'001199500001');
DECLARE @hkC INT = (SELECT id FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'048200000002');
DECLARE @hkD INT = (SELECT id FROM dbo.HANH_KHACH WHERE loai_giay_to = N'CCCD' AND so_giay_to = N'075200300003');
DECLARE @kmOnline INT = (SELECT id FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = N'KM10ONLINE');
DECLARE @uuDaiSV INT = (SELECT id FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'SV');
DECLARE @uuDaiNL INT = (SELECT id FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = N'NL');

DECLARE @toaSE1GheMem INT = (
    SELECT id FROM dbo.TOA_TAU WHERE tau_id = @tauSE1 AND so_toa = 1
);
DECLARE @gheSE1_G01 INT = (SELECT id FROM dbo.GHE WHERE toa_tau_id = @toaSE1GheMem AND so_ghe = N'G01');
DECLARE @gheSE1_G02 INT = (SELECT id FROM dbo.GHE WHERE toa_tau_id = @toaSE1GheMem AND so_ghe = N'G02');
DECLARE @gheSE1_G03 INT = (SELECT id FROM dbo.GHE WHERE toa_tau_id = @toaSE1GheMem AND so_ghe = N'G03');

DECLARE @giaHnoDna DECIMAL(12,2) = (
    SELECT TOP 1 gia_co_so FROM dbo.BANG_GIA
    WHERE ga_di_id = @gaHNO AND ga_den_id = @gaDNA AND loai_toa_ap_dung = N'Ghế ngồi mềm' AND tang_ap_dung IS NULL AND trang_thai = N'Hoạt động'
    ORDER BY id
);
DECLARE @phuThuHnoDna DECIMAL(12,2) = (
    SELECT TOP 1 phu_thu_cao_diem_mac_dinh FROM dbo.BANG_GIA
    WHERE ga_di_id = @gaHNO AND ga_den_id = @gaDNA AND loai_toa_ap_dung = N'Ghế ngồi mềm' AND tang_ap_dung IS NULL AND trang_thai = N'Hoạt động'
    ORDER BY id
);
DECLARE @giaDnaSgn DECIMAL(12,2) = (
    SELECT TOP 1 gia_co_so FROM dbo.BANG_GIA
    WHERE ga_di_id = @gaDNA AND ga_den_id = @gaSGN AND loai_toa_ap_dung = N'Ghế ngồi mềm' AND tang_ap_dung IS NULL AND trang_thai = N'Hoạt động'
    ORDER BY id
);
DECLARE @phuThuDnaSgn DECIMAL(12,2) = (
    SELECT TOP 1 phu_thu_cao_diem_mac_dinh FROM dbo.BANG_GIA
    WHERE ga_di_id = @gaDNA AND ga_den_id = @gaSGN AND loai_toa_ap_dung = N'Ghế ngồi mềm' AND tang_ap_dung IS NULL AND trang_thai = N'Hoạt động'
    ORDER BY id
);

DECLARE @giamSV DECIMAL(12,2) = ROUND(@giaHnoDna * 0.10, 0);
DECLARE @giaVeHnoDna DECIMAL(12,2) = @giaHnoDna - @giamSV + @phuThuHnoDna;
DECLARE @giamKM DECIMAL(12,2) = CASE WHEN ROUND(@giaVeHnoDna * 0.10, 0) > 100000 THEN 100000 ELSE ROUND(@giaVeHnoDna * 0.10, 0) END;
DECLARE @tongThanhToan DECIMAL(12,2) = @giaVeHnoDna - @giamKM;

-- Đơn đã thanh toán + vé hợp lệ: chiếm ghế G01 chặng Hà Nội -> Đà Nẵng
IF NOT EXISTS (SELECT 1 FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_PAID_001')
BEGIN
    INSERT INTO dbo.DAT_CHO (
        khach_hang_id, khuyen_mai_id, ma_dat_cho, loai_don_hang, loai_hanh_trinh,
        tong_tien_ve_goc, thue_vat, phi_thanh_toan, tong_giam_khuyen_mai, giam_gia_khu_hoi,
        tong_thanh_toan, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @khA, @kmOnline, N'DC_DEMO_PAID_001', N'Cá nhân', N'Một chiều',
        @giaHnoDna, 0, 0, @giamKM, 0,
        @tongThanhToan, DATEADD(MINUTE, 30, @now), N'Đã thanh toán'
    );
END;

DECLARE @dcPaid INT = (SELECT id FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_PAID_001');

IF NOT EXISTS (SELECT 1 FROM dbo.THANH_TOAN WHERE request_id = N'REQ_DEMO_PAID_001')
BEGIN
    INSERT INTO dbo.THANH_TOAN (dat_cho_id, ma_giao_dich, request_id, phuong_thuc, so_tien, ngay_thanh_toan, trang_thai)
    VALUES (@dcPaid, N'GD_DEMO_PAID_001', N'REQ_DEMO_PAID_001', N'VNPay', @tongThanhToan, @now, N'Thành công');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.VE WHERE ma_ve = N'VE_DEMO_HNO_DNA_G01')
BEGIN
    INSERT INTO dbo.VE (
        dat_cho_id, chuyen_tau_id, ghe_id, hanh_khach_id, doi_tuong_uu_dai_id,
        ga_di_id, ga_den_id, ma_ve, gia_co_so, giam_doi_tuong, phu_thu_cao_diem, gia_ve_chi_tiet, trang_thai
    )
    VALUES (
        @dcPaid, @ctSE1Demo, @gheSE1_G01, @hkD, @uuDaiSV,
        @gaHNO, @gaDNA, N'VE_DEMO_HNO_DNA_G01', @giaHnoDna, @giamSV, @phuThuHnoDna, @giaVeHnoDna, N'Hợp lệ'
    );
END;

-- Cùng ghế G01 nhưng chặng không giao nhau Đà Nẵng -> Sài Gòn: chứng minh bán ghế theo chặng.
DECLARE @giaVeDnaSgn DECIMAL(12,2) = @giaDnaSgn + @phuThuDnaSgn;
IF NOT EXISTS (SELECT 1 FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_PAID_002')
BEGIN
    INSERT INTO dbo.DAT_CHO (
        khach_hang_id, khuyen_mai_id, ma_dat_cho, loai_don_hang, loai_hanh_trinh,
        tong_tien_ve_goc, thue_vat, phi_thanh_toan, tong_giam_khuyen_mai, giam_gia_khu_hoi,
        tong_thanh_toan, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @khB, NULL, N'DC_DEMO_PAID_002', N'Cá nhân', N'Một chiều',
        @giaDnaSgn, 0, 0, 0, 0,
        @giaVeDnaSgn, DATEADD(MINUTE, 30, @now), N'Đã thanh toán'
    );
END;

DECLARE @dcPaid2 INT = (SELECT id FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_PAID_002');

IF NOT EXISTS (SELECT 1 FROM dbo.THANH_TOAN WHERE request_id = N'REQ_DEMO_PAID_002')
BEGIN
    INSERT INTO dbo.THANH_TOAN (dat_cho_id, ma_giao_dich, request_id, phuong_thuc, so_tien, ngay_thanh_toan, trang_thai)
    VALUES (@dcPaid2, N'GD_DEMO_PAID_002', N'REQ_DEMO_PAID_002', N'MoMo', @giaVeDnaSgn, @now, N'Thành công');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.VE WHERE ma_ve = N'VE_DEMO_DNA_SGN_G01')
BEGIN
    INSERT INTO dbo.VE (
        dat_cho_id, chuyen_tau_id, ghe_id, hanh_khach_id, doi_tuong_uu_dai_id,
        ga_di_id, ga_den_id, ma_ve, gia_co_so, giam_doi_tuong, phu_thu_cao_diem, gia_ve_chi_tiet, trang_thai
    )
    VALUES (
        @dcPaid2, @ctSE1Demo, @gheSE1_G01, @hkC, @uuDaiNL,
        @gaDNA, @gaSGN, N'VE_DEMO_DNA_SGN_G01', @giaDnaSgn, 0, @phuThuDnaSgn, @giaVeDnaSgn, N'Hợp lệ'
    );
END;

-- Đơn đang giữ chỗ: chiếm ghế G02 chặng Hà Nội -> Đà Nẵng, dùng để test ghế đang giữ.
IF NOT EXISTS (SELECT 1 FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_HOLD_001')
BEGIN
    INSERT INTO dbo.DAT_CHO (
        khach_hang_id, khuyen_mai_id, ma_dat_cho, loai_don_hang, loai_hanh_trinh,
        tong_tien_ve_goc, thue_vat, phi_thanh_toan, tong_giam_khuyen_mai, giam_gia_khu_hoi,
        tong_thanh_toan, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @khB, NULL, N'DC_DEMO_HOLD_001', N'Cá nhân', N'Một chiều',
        @giaHnoDna, 0, 0, 0, 0,
        @giaHnoDna + @phuThuHnoDna, DATEADD(MINUTE, 30, @now), N'Chờ thanh toán'
    );
END;

DECLARE @dcHold INT = (SELECT id FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_HOLD_001');

IF NOT EXISTS (SELECT 1 FROM dbo.GIU_CHO WHERE dat_cho_id = @dcHold AND chuyen_tau_id = @ctSE1Demo AND ghe_id = @gheSE1_G02 AND trang_thai = N'Đang giữ')
BEGIN
    INSERT INTO dbo.GIU_CHO (dat_cho_id, chuyen_tau_id, ghe_id, ga_di_id, ga_den_id, thoi_gian_het_han, trang_thai)
    VALUES (@dcHold, @ctSE1Demo, @gheSE1_G02, @gaHNO, @gaDNA, DATEADD(MINUTE, 30, @now), N'Đang giữ');
END;

-- Đơn chờ thanh toán mẫu chưa chọn ghế cuối cùng: dùng cho màn hình đặt chỗ ở các bước sau.
IF NOT EXISTS (SELECT 1 FROM dbo.DAT_CHO WHERE ma_dat_cho = N'DC_DEMO_DRAFT_001')
BEGIN
    INSERT INTO dbo.DAT_CHO (
        khach_hang_id, khuyen_mai_id, ma_dat_cho, loai_don_hang, loai_hanh_trinh,
        tong_tien_ve_goc, thue_vat, phi_thanh_toan, tong_giam_khuyen_mai, giam_gia_khu_hoi,
        tong_thanh_toan, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @khA, NULL, N'DC_DEMO_DRAFT_001', N'Cá nhân', N'Một chiều',
        0, 0, 0, 0, 0,
        0, DATEADD(MINUTE, 30, @now), N'Chờ thanh toán'
    );
END;

/*=============================================================================
  7. TRUY VẤN KIỂM TRA NHANH SAU KHI CHẠY SEED
=============================================================================*/

PRINT N'Đã nạp xong dữ liệu mẫu Giai đoạn 2 theo ERD + Use Case cải tiến.';

SELECT N'GA' AS bang, COUNT(*) AS so_dong FROM dbo.GA
UNION ALL SELECT N'TAU', COUNT(*) FROM dbo.TAU
UNION ALL SELECT N'TOA_TAU', COUNT(*) FROM dbo.TOA_TAU
UNION ALL SELECT N'GHE', COUNT(*) FROM dbo.GHE
UNION ALL SELECT N'CHUYEN_TAU', COUNT(*) FROM dbo.CHUYEN_TAU
UNION ALL SELECT N'LICH_DUNG', COUNT(*) FROM dbo.LICH_DUNG
UNION ALL SELECT N'BANG_GIA', COUNT(*) FROM dbo.BANG_GIA
UNION ALL SELECT N'DOI_TUONG_UU_DAI', COUNT(*) FROM dbo.DOI_TUONG_UU_DAI
UNION ALL SELECT N'KHUYEN_MAI', COUNT(*) FROM dbo.KHUYEN_MAI
UNION ALL SELECT N'CHINH_SACH_DOI_TRA', COUNT(*) FROM dbo.CHINH_SACH_DOI_TRA
UNION ALL SELECT N'DAT_CHO', COUNT(*) FROM dbo.DAT_CHO
UNION ALL SELECT N'GIU_CHO', COUNT(*) FROM dbo.GIU_CHO
UNION ALL SELECT N'VE', COUNT(*) FROM dbo.VE
UNION ALL SELECT N'THANH_TOAN', COUNT(*) FROM dbo.THANH_TOAN;

-- Test tìm chuyến: Hà Nội -> Đà Nẵng, ngày mai.
SELECT
    ct.ma_chuyen,
    tau.ma_tau,
    ga_di.ten_ga AS ga_di,
    ga_den.ten_ga AS ga_den,
    ld_di.thoi_gian_di AS gio_di,
    ld_den.thoi_gian_den AS gio_den,
    ld_di.thu_tu_dung AS thu_tu_di,
    ld_den.thu_tu_dung AS thu_tu_den
FROM dbo.CHUYEN_TAU ct
JOIN dbo.TAU tau ON tau.id = ct.tau_id
JOIN dbo.LICH_DUNG ld_di ON ld_di.chuyen_tau_id = ct.id AND ld_di.ga_id = @gaHNO
JOIN dbo.LICH_DUNG ld_den ON ld_den.chuyen_tau_id = ct.id AND ld_den.ga_id = @gaDNA
JOIN dbo.GA ga_di ON ga_di.id = ld_di.ga_id
JOIN dbo.GA ga_den ON ga_den.id = ld_den.ga_id
WHERE ct.ngay_chay = @ngayDi1
  AND ct.trang_thai = N'Hoạt động'
  AND ld_di.thu_tu_dung < ld_den.thu_tu_dung;

-- Test trạng thái vài ghế trên chuyến SE1, chặng Hà Nội -> Đà Nẵng.
SELECT
    ghe.so_ghe,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM dbo.VE v
            JOIN dbo.LICH_DUNG v_di ON v_di.chuyen_tau_id = v.chuyen_tau_id AND v_di.ga_id = v.ga_di_id
            JOIN dbo.LICH_DUNG v_den ON v_den.chuyen_tau_id = v.chuyen_tau_id AND v_den.ga_id = v.ga_den_id
            WHERE v.chuyen_tau_id = @ctSE1Demo
              AND v.ghe_id = ghe.id
              AND v.trang_thai IN (N'Hợp lệ', N'Đã sử dụng')
              AND v_di.thu_tu_dung < (SELECT thu_tu_dung FROM dbo.LICH_DUNG WHERE chuyen_tau_id = @ctSE1Demo AND ga_id = @gaDNA)
              AND (SELECT thu_tu_dung FROM dbo.LICH_DUNG WHERE chuyen_tau_id = @ctSE1Demo AND ga_id = @gaHNO) < v_den.thu_tu_dung
        ) THEN N'Đã bán'
        WHEN EXISTS (
            SELECT 1 FROM dbo.GIU_CHO g
            JOIN dbo.LICH_DUNG g_di ON g_di.chuyen_tau_id = g.chuyen_tau_id AND g_di.ga_id = g.ga_di_id
            JOIN dbo.LICH_DUNG g_den ON g_den.chuyen_tau_id = g.chuyen_tau_id AND g_den.ga_id = g.ga_den_id
            WHERE g.chuyen_tau_id = @ctSE1Demo
              AND g.ghe_id = ghe.id
              AND g.trang_thai = N'Đang giữ'
              AND g.thoi_gian_het_han > @now
              AND g_di.thu_tu_dung < (SELECT thu_tu_dung FROM dbo.LICH_DUNG WHERE chuyen_tau_id = @ctSE1Demo AND ga_id = @gaDNA)
              AND (SELECT thu_tu_dung FROM dbo.LICH_DUNG WHERE chuyen_tau_id = @ctSE1Demo AND ga_id = @gaHNO) < g_den.thu_tu_dung
        ) THEN N'Đang giữ'
        ELSE N'Trống'
    END AS trang_thai_theo_chang
FROM dbo.GHE ghe
WHERE ghe.toa_tau_id = @toaSE1GheMem
ORDER BY ghe.so_ghe;
GO

/*=============================================================================
  10. DỮ LIỆU MẪU BỔ SUNG: 15 KỊCH BẢN GĐ1-GĐ2-GĐ3
=============================================================================*/

DECLARE @now DATETIME2(0) = SYSDATETIME();
DECLARE @hieuLucTu DATETIME2(0) = DATEADD(DAY, -30, @now);
DECLARE @hieuLucDen DATETIME2(0) = DATEADD(YEAR, 1, @now);

/*=============================================================================
  1. KHÁCH HÀNG MẪU BỔ SUNG
=============================================================================*/
INSERT INTO dbo.KHACH_HANG (ho_ten, email, so_dien_thoai, mat_khau_hash, ngay_sinh, gioi_tinh, dia_chi)
SELECT v.ho_ten, v.email, v.so_dien_thoai, v.mat_khau_hash, v.ngay_sinh, v.gioi_tinh, v.dia_chi
FROM (VALUES
    (N'Hoàng Minh Quân',       N'demo01@vetau.vn', N'0911000001', N'123456_hash_demo', CAST('1998-03-15' AS DATE), N'Nam',  N'Hà Nội'),
    (N'Đỗ Thảo My',            N'demo02@vetau.vn', N'0911000002', N'123456_hash_demo', CAST('2001-07-21' AS DATE), N'Nữ',   N'Huế'),
    (N'Vũ Quốc Huy',           N'demo03@vetau.vn', N'0911000003', N'123456_hash_demo', CAST('1992-11-03' AS DATE), N'Nam',  N'Đà Nẵng'),
    (N'Nguyễn An Nhiên',       N'demo04@vetau.vn', N'0911000004', N'123456_hash_demo', CAST('1988-01-19' AS DATE), N'Nữ',   N'Nha Trang'),
    (N'Trương Gia Bảo',        N'demo05@vetau.vn', N'0911000005', N'123456_hash_demo', CAST('2004-09-09' AS DATE), N'Nam',  N'TP. Hồ Chí Minh'),
    (N'Lâm Phương Linh',       N'demo06@vetau.vn', N'0911000006', N'123456_hash_demo', CAST('1999-12-30' AS DATE), N'Nữ',   N'Nghệ An'),
    (N'Phan Nhật Minh',        N'demo07@vetau.vn', N'0911000007', N'123456_hash_demo', CAST('1970-04-04' AS DATE), N'Nam',  N'Hà Nội'),
    (N'Bùi Khánh Vy',          N'demo08@vetau.vn', N'0911000008', N'123456_hash_demo', CAST('2005-06-25' AS DATE), N'Nữ',   N'Đà Nẵng'),
    (N'Đặng Thanh Tùng',       N'demo09@vetau.vn', N'0911000009', N'123456_hash_demo', CAST('1990-02-12' AS DATE), N'Nam',  N'Huế'),
    (N'Đinh Mai Anh',          N'demo10@vetau.vn', N'0911000010', N'123456_hash_demo', CAST('1996-10-08' AS DATE), N'Nữ',   N'TP. Hồ Chí Minh')
) AS v(ho_ten, email, so_dien_thoai, mat_khau_hash, ngay_sinh, gioi_tinh, dia_chi)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.KHACH_HANG kh WHERE kh.email = v.email
);

/*=============================================================================
  2. HÀNH KHÁCH MẪU BỔ SUNG
=============================================================================*/
INSERT INTO dbo.HANH_KHACH (ho_ten, loai_giay_to, so_giay_to, ngay_sinh, quoc_tich)
SELECT v.ho_ten, v.loai_giay_to, v.so_giay_to, v.ngay_sinh, v.quoc_tich
FROM (VALUES
    (N'Hoàng Minh Quân',    N'CCCD',           N'001098000101', CAST('1998-03-15' AS DATE), N'Việt Nam'),
    (N'Đỗ Thảo My',         N'CCCD',           N'046101000102', CAST('2001-07-21' AS DATE), N'Việt Nam'),
    (N'Vũ Quốc Huy',        N'CCCD',           N'048092000103', CAST('1992-11-03' AS DATE), N'Việt Nam'),
    (N'Nguyễn An Nhiên',    N'CCCD',           N'056088000104', CAST('1988-01-19' AS DATE), N'Việt Nam'),
    (N'Trương Gia Bảo',     N'CCCD',           N'079204000105', CAST('2004-09-09' AS DATE), N'Việt Nam'),
    (N'Lâm Phương Linh',    N'CCCD',           N'040099000106', CAST('1999-12-30' AS DATE), N'Việt Nam'),
    (N'Phan Nhật Minh',     N'CCCD',           N'001070000107', CAST('1962-04-04' AS DATE), N'Việt Nam'),
    (N'Bùi Khánh Vy',       N'CCCD',           N'048205000108', CAST('2005-06-25' AS DATE), N'Việt Nam'),
    (N'Đặng Thanh Tùng',    N'CCCD',           N'046090000109', CAST('1990-02-12' AS DATE), N'Việt Nam'),
    (N'Đinh Mai Anh',       N'CCCD',           N'079096000110', CAST('1996-10-08' AS DATE), N'Việt Nam'),
    (N'Em bé Nguyễn Minh',   N'Giấy khai sinh', N'GKS-SEED-001', CAST('2018-05-05' AS DATE), N'Việt Nam'),
    (N'Ông Trần Văn Sơn',    N'CCCD',           N'001060000112', CAST('1960-01-01' AS DATE), N'Việt Nam')
) AS v(ho_ten, loai_giay_to, so_giay_to, ngay_sinh, quoc_tich)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.HANH_KHACH hk
    WHERE hk.loai_giay_to = v.loai_giay_to
      AND hk.so_giay_to = v.so_giay_to
);

/*=============================================================================
  3. KHUYẾN MÃI MẪU BỔ SUNG
=============================================================================*/
IF NOT EXISTS (SELECT 1 FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = N'KM15MOMO')
BEGIN
    INSERT INTO dbo.KHUYEN_MAI (
        ma_khuyen_mai, ten_chuong_trinh, phan_tram_giam, giam_toi_da,
        gia_tri_don_toi_thieu, phuong_thuc_tt_ap_dung, ngay_bat_dau, ngay_ket_thuc, so_luong_toi_da, trang_thai
    )
    VALUES (
        N'KM15MOMO', N'Giảm 15% cho thanh toán MoMo', 15, 120000,
        250000, N'MoMo', @hieuLucTu, @hieuLucDen, 500, N'Hoạt động'
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = N'KM25REPORT')
BEGIN
    INSERT INTO dbo.KHUYEN_MAI (
        ma_khuyen_mai, ten_chuong_trinh, phan_tram_giam, giam_toi_da,
        gia_tri_don_toi_thieu, phuong_thuc_tt_ap_dung, ngay_bat_dau, ngay_ket_thuc, so_luong_toi_da, trang_thai
    )
    VALUES (
        N'KM25REPORT', N'Giảm 25% dữ liệu mẫu báo cáo', 25, 200000,
        500000, N'VNPay', @hieuLucTu, @hieuLucDen, 100, N'Hoạt động'
    );
END;

/*=============================================================================
  4. BẢNG KỊCH BẢN 15 ĐƠN/VÉ MẪU
=============================================================================*/
DECLARE @Scenario TABLE (
    ma_dat_cho NVARCHAR(30) NOT NULL,
    customer_email NVARCHAR(150) NOT NULL,
    passenger_doc NVARCHAR(50) NOT NULL,
    ma_chuyen NVARCHAR(30) NOT NULL,
    ma_ga_di NVARCHAR(10) NOT NULL,
    ma_ga_den NVARCHAR(10) NOT NULL,
    so_toa INT NOT NULL,
    so_ghe NVARCHAR(10) NOT NULL,
    loai_toa NVARCHAR(40) NOT NULL,
    tang INT NULL,
    ma_uu_dai NVARCHAR(30) NULL,
    ma_khuyen_mai NVARCHAR(30) NULL,
    phuong_thuc NVARCHAR(30) NULL,
    trang_thai_dat_cho NVARCHAR(30) NOT NULL,
    trang_thai_thanh_toan NVARCHAR(30) NULL,
    trang_thai_giu_cho NVARCHAR(20) NOT NULL,
    trang_thai_ve NVARCHAR(20) NOT NULL,
    refund_status NVARCHAR(20) NULL,
    ngay_dat_offset INT NOT NULL
);

INSERT INTO @Scenario VALUES
-- 1-4: Vé đã thanh toán hợp lệ, phục vụ test vé điện tử và báo cáo doanh thu.
(N'DC_SEED_PAID_001',   N'demo01@vetau.vn', N'001098000101', N'SE1-20260510', N'HNO', N'HUE', 1, N'G04', N'Ghế ngồi mềm', NULL, N'SV',  N'KM10ONLINE', N'VNPay',       N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ',       NULL,          -7),
(N'DC_SEED_PAID_002',   N'demo02@vetau.vn', N'046101000102', N'SE1-20260510', N'HUE', N'DNA', 1, N'G05', N'Ghế ngồi mềm', NULL, N'NL',  N'KM5ALL',     N'MoMo',        N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ',       NULL,          -6),
(N'DC_SEED_PAID_003',   N'demo03@vetau.vn', N'048092000103', N'SE1-20260511', N'DNA', N'NTR', 2, N'B01', N'Nằm mềm 4 người', 1, N'NL',  NULL,           N'Chuyển khoản',N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ',       NULL,          -5),
(N'DC_SEED_PAID_004',   N'demo04@vetau.vn', N'056088000104', N'SE2-20260512', N'SGN', N'NTR', 1, N'G04', N'Ghế ngồi mềm', NULL, N'NL',  NULL,           N'Tiền mặt',    N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ',       NULL,          -4),

-- 5: Đơn đang chờ thanh toán, có thanh toán Pending và ghế đang giữ.
(N'DC_SEED_PENDING_001',N'demo05@vetau.vn', N'079204000105', N'SE1-20260513', N'HNO', N'DNA', 1, N'G06', N'Ghế ngồi mềm', NULL, N'SV',  NULL,           N'VNPay',       N'Chờ thanh toán', N'Pending',   N'Đang giữ',     N'Chờ thanh toán', NULL,        0),

-- 6: Đơn hết hạn, phục vụ test Giai đoạn 3 cleanup.
(N'DC_SEED_EXPIRED_001',N'demo06@vetau.vn', N'040099000106', N'SE1-20260514', N'HNO', N'VIN', 1, N'G07', N'Ghế ngồi mềm', NULL, N'NL',  NULL,           N'VNPay',       N'Hết hạn',      N'Thất bại',  N'Hết hạn',      N'Đã hủy',       NULL,          -3),

-- 7-8: Vé đã trả, hoàn tiền chờ xử lý / hoàn tất.
(N'DC_SEED_RETURN_001', N'demo07@vetau.vn', N'001070000107', N'SE1-20260515', N'HNO', N'DNA', 1, N'G08', N'Ghế ngồi mềm', NULL, N'NCT', N'KM5ALL',     N'VNPay',       N'Hoàn tiền một phần', N'Thành công', N'Đã chuyển vé', N'Đã trả', N'Chờ xử lý', -2),
(N'DC_SEED_RETURN_002', N'demo08@vetau.vn', N'048205000108', N'SE1-20260516', N'HNO', N'HUE', 1, N'G09', N'Ghế ngồi mềm', NULL, N'SV',  N'KM15MOMO',   N'MoMo',        N'Hoàn tiền toàn bộ', N'Thành công', N'Đã chuyển vé', N'Đã trả', N'Hoàn tất', -1),

-- 9: Vé đã sử dụng.
(N'DC_SEED_USED_001',   N'demo09@vetau.vn', N'046090000109', N'SE1-20260517', N'VIN', N'HUE', 1, N'G10', N'Ghế ngồi mềm', NULL, N'NL',  NULL,           N'Tiền mặt',    N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Đã sử dụng',   NULL,          -10),

-- 10: Đơn đã hủy.
(N'DC_SEED_CANCEL_001', N'demo10@vetau.vn', N'079096000110', N'SE1-20260518', N'HNO', N'NTR', 1, N'G11', N'Ghế ngồi mềm', NULL, N'NL',  NULL,           N'VNPay',       N'Đã hủy',      N'Thất bại',  N'Đã hủy',      N'Đã hủy',       NULL,          -9),

-- 11-13: Dữ liệu doanh thu đa dạng tuyến/toa/chiều.
(N'DC_SEED_PAID_005',   N'demo03@vetau.vn', N'GKS-SEED-001', N'SE1-20260519', N'HNO', N'SGN', 2, N'B02', N'Nằm mềm 4 người', 2, N'TRE_EM', N'KM25REPORT', N'VNPay',    N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ', NULL, -8),
(N'DC_SEED_PAID_006',   N'demo04@vetau.vn', N'001060000112', N'SE2-20260519', N'SGN', N'HNO', 1, N'G05', N'Ghế ngồi mềm', NULL, N'NCT', N'KM5ALL',      N'MoMo',     N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ', NULL, -7),
(N'DC_SEED_PAID_007',   N'demo05@vetau.vn', N'001098000101', N'TN1-20260520', N'HNO', N'DNA', 1, N'G04', N'Ghế ngồi cứng', NULL, N'NL', NULL,            N'Tiền mặt', N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Hợp lệ', NULL, -6),

-- 14: Đơn đang giữ chỗ của TN1.
(N'DC_SEED_PENDING_002',N'demo06@vetau.vn', N'046101000102', N'TN1-20260521', N'HNO', N'HUE', 1, N'G05', N'Ghế ngồi cứng', NULL, N'SV', NULL,            NULL,        N'Chờ thanh toán', NULL,        N'Đang giữ',     N'Chờ thanh toán', NULL, 0),

-- 15: Vé đã trả nhưng yêu cầu hoàn tiền bị từ chối, phục vụ test admin refund.
(N'DC_SEED_RETURN_003', N'demo07@vetau.vn', N'048092000103', N'SE2-20260522', N'DNA', N'HNO', 1, N'G06', N'Ghế ngồi mềm', NULL, N'NL', NULL,             N'VNPay',    N'Đã thanh toán', N'Thành công', N'Đã chuyển vé', N'Đã trả', N'Từ chối', -5);

/*=============================================================================
  5. XỬ LÝ INSERT 15 KỊCH BẢN
=============================================================================*/
DECLARE
    @maDatCho NVARCHAR(30),
    @customerEmail NVARCHAR(150),
    @passengerDoc NVARCHAR(50),
    @maChuyen NVARCHAR(30),
    @maGaDi NVARCHAR(10),
    @maGaDen NVARCHAR(10),
    @soToa INT,
    @soGhe NVARCHAR(10),
    @loaiToa NVARCHAR(40),
    @tang INT,
    @maUuDai NVARCHAR(30),
    @maKM NVARCHAR(30),
    @phuongThuc NVARCHAR(30),
    @trangThaiDatCho NVARCHAR(30),
    @trangThaiThanhToan NVARCHAR(30),
    @trangThaiGiuCho NVARCHAR(20),
    @trangThaiVe NVARCHAR(20),
    @refundStatus NVARCHAR(20),
    @ngayDatOffset INT;

DECLARE
    @khId INT,
    @hkId INT,
    @ctId INT,
    @tauId INT,
    @gaDiId INT,
    @gaDenId INT,
    @toaId INT,
    @gheId INT,
    @uuDaiId INT,
    @ptUuDai DECIMAL(5,2),
    @kmId INT,
    @ptKM DECIMAL(5,2),
    @giamToiDa DECIMAL(12,2),
    @donMin DECIMAL(12,2),
    @giaCoSo DECIMAL(12,2),
    @phuThu DECIMAL(12,2),
    @giamDoiTuong DECIMAL(12,2),
    @giaVeChiTiet DECIMAL(12,2),
    @giamKM DECIMAL(12,2),
    @tongTienVeGoc DECIMAL(12,2),
    @tongThanhToan DECIMAL(12,2),
    @ngayDat DATETIME2(0),
    @thoiGianGiu DATETIME2(0),
    @thoiGianHetHan DATETIME2(0),
    @datChoId INT,
    @maVe NVARCHAR(40),
    @veId INT,
    @thanhToanId INT,
    @csId INT,
    @tyLeKhauTru DECIMAL(5,2),
    @phiDoi DECIMAL(12,2),
    @soTienHoan DECIMAL(12,2);

DECLARE curScenario CURSOR LOCAL FAST_FORWARD FOR
SELECT ma_dat_cho, customer_email, passenger_doc, ma_chuyen, ma_ga_di, ma_ga_den,
       so_toa, so_ghe, loai_toa, tang, ma_uu_dai, ma_khuyen_mai, phuong_thuc,
       trang_thai_dat_cho, trang_thai_thanh_toan, trang_thai_giu_cho, trang_thai_ve,
       refund_status, ngay_dat_offset
FROM @Scenario
ORDER BY ma_dat_cho;

OPEN curScenario;
FETCH NEXT FROM curScenario INTO
    @maDatCho, @customerEmail, @passengerDoc, @maChuyen, @maGaDi, @maGaDen,
    @soToa, @soGhe, @loaiToa, @tang, @maUuDai, @maKM, @phuongThuc,
    @trangThaiDatCho, @trangThaiThanhToan, @trangThaiGiuCho, @trangThaiVe,
    @refundStatus, @ngayDatOffset;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.DAT_CHO WHERE ma_dat_cho = @maDatCho)
    BEGIN
        PRINT N'Bỏ qua vì đã tồn tại: ' + @maDatCho;
        FETCH NEXT FROM curScenario INTO
            @maDatCho, @customerEmail, @passengerDoc, @maChuyen, @maGaDi, @maGaDen,
            @soToa, @soGhe, @loaiToa, @tang, @maUuDai, @maKM, @phuongThuc,
            @trangThaiDatCho, @trangThaiThanhToan, @trangThaiGiuCho, @trangThaiVe,
            @refundStatus, @ngayDatOffset;
        CONTINUE;
    END;

    SET @khId = (SELECT id FROM dbo.KHACH_HANG WHERE email = @customerEmail);
    SET @hkId = (SELECT id FROM dbo.HANH_KHACH WHERE so_giay_to = @passengerDoc);
    SET @ctId = (SELECT id FROM dbo.CHUYEN_TAU WHERE ma_chuyen = @maChuyen);
    SET @tauId = (SELECT tau_id FROM dbo.CHUYEN_TAU WHERE id = @ctId);
    SET @gaDiId = (SELECT id FROM dbo.GA WHERE ma_ga = @maGaDi);
    SET @gaDenId = (SELECT id FROM dbo.GA WHERE ma_ga = @maGaDen);
    SET @toaId = (SELECT id FROM dbo.TOA_TAU WHERE tau_id = @tauId AND so_toa = @soToa);
    SET @gheId = (SELECT id FROM dbo.GHE WHERE toa_tau_id = @toaId AND so_ghe = @soGhe);
    SET @uuDaiId = (SELECT id FROM dbo.DOI_TUONG_UU_DAI WHERE ma_doi_tuong = @maUuDai);
    SET @ptUuDai = ISNULL((SELECT phan_tram_giam FROM dbo.DOI_TUONG_UU_DAI WHERE id = @uuDaiId), 0);
    SET @kmId = (SELECT id FROM dbo.KHUYEN_MAI WHERE ma_khuyen_mai = @maKM);
    SET @ptKM = ISNULL((SELECT phan_tram_giam FROM dbo.KHUYEN_MAI WHERE id = @kmId), 0);
    SET @giamToiDa = (SELECT giam_toi_da FROM dbo.KHUYEN_MAI WHERE id = @kmId);
    SET @donMin = ISNULL((SELECT gia_tri_don_toi_thieu FROM dbo.KHUYEN_MAI WHERE id = @kmId), 0);

    SET @giaCoSo = (
        SELECT TOP 1 gia_co_so
        FROM dbo.BANG_GIA
        WHERE ga_di_id = @gaDiId
          AND ga_den_id = @gaDenId
          AND loai_toa_ap_dung = @loaiToa
          AND ((@tang IS NULL AND tang_ap_dung IS NULL) OR tang_ap_dung = @tang)
          AND trang_thai = N'Hoạt động'
        ORDER BY CASE WHEN tang_ap_dung IS NULL THEN 1 ELSE 0 END, id
    );

    SET @phuThu = (
        SELECT TOP 1 phu_thu_cao_diem_mac_dinh
        FROM dbo.BANG_GIA
        WHERE ga_di_id = @gaDiId
          AND ga_den_id = @gaDenId
          AND loai_toa_ap_dung = @loaiToa
          AND ((@tang IS NULL AND tang_ap_dung IS NULL) OR tang_ap_dung = @tang)
          AND trang_thai = N'Hoạt động'
        ORDER BY CASE WHEN tang_ap_dung IS NULL THEN 1 ELSE 0 END, id
    );

    IF @khId IS NULL OR @hkId IS NULL OR @ctId IS NULL OR @gaDiId IS NULL OR @gaDenId IS NULL OR @toaId IS NULL OR @gheId IS NULL OR @giaCoSo IS NULL
    BEGIN
        PRINT N'Không thể tạo scenario vì thiếu dữ liệu tham chiếu: ' + @maDatCho;
        FETCH NEXT FROM curScenario INTO
            @maDatCho, @customerEmail, @passengerDoc, @maChuyen, @maGaDi, @maGaDen,
            @soToa, @soGhe, @loaiToa, @tang, @maUuDai, @maKM, @phuongThuc,
            @trangThaiDatCho, @trangThaiThanhToan, @trangThaiGiuCho, @trangThaiVe,
            @refundStatus, @ngayDatOffset;
        CONTINUE;
    END;

    SET @giamDoiTuong = ROUND(@giaCoSo * @ptUuDai / 100.0, 0);
    SET @giaVeChiTiet = @giaCoSo - @giamDoiTuong + ISNULL(@phuThu, 0);
    SET @giamKM = 0;

    IF @kmId IS NOT NULL AND @giaVeChiTiet >= @donMin
    BEGIN
        SET @giamKM = ROUND(@giaVeChiTiet * @ptKM / 100.0, 0);
        IF @giamToiDa IS NOT NULL AND @giamKM > @giamToiDa
            SET @giamKM = @giamToiDa;
    END;

    SET @tongTienVeGoc = @giaCoSo + ISNULL(@phuThu, 0);
    SET @tongThanhToan = @giaVeChiTiet - @giamKM;
    IF @tongThanhToan < 0 SET @tongThanhToan = 0;

    SET @ngayDat = DATEADD(DAY, @ngayDatOffset, @now);
    SET @thoiGianGiu = NULL;
    SET @thoiGianHetHan = NULL;

    IF @trangThaiDatCho = N'Hết hạn' OR @trangThaiDatCho = N'Đã hủy'
    BEGIN
        SET @thoiGianGiu = DATEADD(MINUTE, -80, @now);
        SET @thoiGianHetHan = DATEADD(MINUTE, -40, @now);
    END
    ELSE
    BEGIN
        SET @thoiGianGiu = DATEADD(MINUTE, -10, @now);
        SET @thoiGianHetHan = DATEADD(MINUTE, 30, @now);
    END;

    INSERT INTO dbo.DAT_CHO (
        khach_hang_id, khuyen_mai_id, ma_dat_cho, loai_don_hang, loai_hanh_trinh,
        ngay_dat, tong_tien_ve_goc, thue_vat, phi_thanh_toan, tong_giam_khuyen_mai,
        giam_gia_khu_hoi, tong_thanh_toan, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @khId, @kmId, @maDatCho, N'Cá nhân', N'Một chiều',
        @ngayDat, @tongTienVeGoc, 0, 0, @giamKM,
        0, @tongThanhToan, @thoiGianHetHan, @trangThaiDatCho
    );

    SET @datChoId = SCOPE_IDENTITY();
    SET @maVe = REPLACE(@maDatCho, N'DC_', N'VE_');

    INSERT INTO dbo.GIU_CHO (
        dat_cho_id, chuyen_tau_id, ghe_id, ga_di_id, ga_den_id,
        thoi_gian_giu, thoi_gian_het_han, trang_thai
    )
    VALUES (
        @datChoId, @ctId, @gheId, @gaDiId, @gaDenId,
        @thoiGianGiu, @thoiGianHetHan, @trangThaiGiuCho
    );

    INSERT INTO dbo.VE (
        dat_cho_id, chuyen_tau_id, ghe_id, hanh_khach_id, doi_tuong_uu_dai_id,
        ga_di_id, ga_den_id, ma_ve, gia_co_so, giam_doi_tuong,
        phu_thu_cao_diem, gia_ve_chi_tiet, trang_thai
    )
    VALUES (
        @datChoId, @ctId, @gheId, @hkId, @uuDaiId,
        @gaDiId, @gaDenId, @maVe, @giaCoSo, @giamDoiTuong,
        ISNULL(@phuThu, 0), @giaVeChiTiet, @trangThaiVe
    );

    SET @veId = SCOPE_IDENTITY();
    SET @thanhToanId = NULL;

    IF @trangThaiThanhToan IS NOT NULL AND @phuongThuc IS NOT NULL
    BEGIN
        INSERT INTO dbo.THANH_TOAN (
            dat_cho_id, ma_giao_dich, request_id, phuong_thuc, so_tien,
            ngay_tao, ngay_thanh_toan, trang_thai
        )
        VALUES (
            @datChoId,
            CASE WHEN @trangThaiThanhToan = N'Thành công' THEN N'GD_' + @maDatCho ELSE NULL END,
            N'REQ_' + @maDatCho,
            @phuongThuc,
            @tongThanhToan,
            @ngayDat,
            CASE WHEN @trangThaiThanhToan = N'Thành công' THEN DATEADD(MINUTE, 5, @ngayDat) ELSE NULL END,
            CASE
                WHEN @refundStatus = N'Chờ xử lý' THEN N'Đang hoàn tiền'
                WHEN @refundStatus = N'Hoàn tất' THEN N'Đã hoàn tiền'
                ELSE @trangThaiThanhToan
            END
        );

        SET @thanhToanId = SCOPE_IDENTITY();
    END;

    IF @refundStatus IS NOT NULL AND @thanhToanId IS NOT NULL
    BEGIN
        SET @csId = (
            SELECT TOP 1 id FROM dbo.CHINH_SACH_DOI_TRA
            WHERE trang_thai = N'Hoạt động' AND cho_phep_tra = 1
            ORDER BY do_uu_tien
        );
        SET @tyLeKhauTru = ISNULL((SELECT ty_le_khau_tru FROM dbo.CHINH_SACH_DOI_TRA WHERE id = @csId), 10);
        SET @phiDoi = ISNULL((SELECT phi_doi_co_dinh FROM dbo.CHINH_SACH_DOI_TRA WHERE id = @csId), 20000);
        SET @soTienHoan = @giaVeChiTiet - ROUND(@giaVeChiTiet * @tyLeKhauTru / 100.0, 0) - @phiDoi;
        IF @soTienHoan < 0 SET @soTienHoan = 0;

        IF NOT EXISTS (SELECT 1 FROM dbo.LICH_SU_DOI_TRA WHERE ve_id = @veId AND loai_giao_dich = N'Trả vé')
        BEGIN
            INSERT INTO dbo.LICH_SU_DOI_TRA (
                ve_id, nhan_vien_id, chinh_sach_id, loai_giao_dich, ly_do,
                phi_doi, ty_le_khau_tru, so_tien_hoan, thoi_gian_xu_ly, ghi_chu
            )
            VALUES (
                @veId, NULL, @csId, N'Trả vé', N'Dữ liệu mẫu kiểm thử hoàn tiền',
                @phiDoi, @tyLeKhauTru, @soTienHoan, DATEADD(MINUTE, 20, @ngayDat), @refundStatus
            );
        END;

        IF NOT EXISTS (SELECT 1 FROM dbo.HOAN_TIEN WHERE ve_id = @veId)
        BEGIN
            INSERT INTO dbo.HOAN_TIEN (
                thanh_toan_id, ve_id, so_tien_hoan, ma_giao_dich_hoan,
                thoi_gian_yeu_cau, thoi_gian_hoan_tat, trang_thai
            )
            VALUES (
                @thanhToanId,
                @veId,
                @soTienHoan,
                CASE WHEN @refundStatus = N'Hoàn tất' THEN N'REF_' + @maDatCho ELSE NULL END,
                DATEADD(MINUTE, 21, @ngayDat),
                CASE WHEN @refundStatus IN (N'Hoàn tất', N'Từ chối') THEN DATEADD(MINUTE, 45, @ngayDat) ELSE NULL END,
                @refundStatus
            );
        END;
    END;

    PRINT N'Đã thêm scenario: ' + @maDatCho + N' / Vé: ' + @maVe;

    FETCH NEXT FROM curScenario INTO
        @maDatCho, @customerEmail, @passengerDoc, @maChuyen, @maGaDi, @maGaDen,
        @soToa, @soGhe, @loaiToa, @tang, @maUuDai, @maKM, @phuongThuc,
        @trangThaiDatCho, @trangThaiThanhToan, @trangThaiGiuCho, @trangThaiVe,
        @refundStatus, @ngayDatOffset;
END;

CLOSE curScenario;
DEALLOCATE curScenario;

/*=============================================================================
  6. TRUY VẤN KIỂM TRA NHANH SAU KHI CHẠY SEED
=============================================================================*/
PRINT N'Hoàn tất seed 15 kịch bản dữ liệu mẫu.';

SELECT N'KHACH_HANG' AS bang, COUNT(*) AS so_dong FROM dbo.KHACH_HANG
UNION ALL SELECT N'HANH_KHACH', COUNT(*) FROM dbo.HANH_KHACH
UNION ALL SELECT N'DAT_CHO', COUNT(*) FROM dbo.DAT_CHO
UNION ALL SELECT N'GIU_CHO', COUNT(*) FROM dbo.GIU_CHO
UNION ALL SELECT N'VE', COUNT(*) FROM dbo.VE
UNION ALL SELECT N'THANH_TOAN', COUNT(*) FROM dbo.THANH_TOAN
UNION ALL SELECT N'HOAN_TIEN', COUNT(*) FROM dbo.HOAN_TIEN
UNION ALL SELECT N'LICH_SU_DOI_TRA', COUNT(*) FROM dbo.LICH_SU_DOI_TRA;

SELECT
    dc.ma_dat_cho,
    dc.trang_thai AS trang_thai_dat_cho,
    tt.trang_thai AS trang_thai_thanh_toan,
    gc.trang_thai AS trang_thai_giu_cho,
    v.ma_ve,
    v.trang_thai AS trang_thai_ve,
    ht.trang_thai AS trang_thai_hoan_tien,
    dc.tong_thanh_toan
FROM dbo.DAT_CHO dc
LEFT JOIN dbo.THANH_TOAN tt ON tt.dat_cho_id = dc.id
LEFT JOIN dbo.GIU_CHO gc ON gc.dat_cho_id = dc.id
LEFT JOIN dbo.VE v ON v.dat_cho_id = dc.id
LEFT JOIN dbo.HOAN_TIEN ht ON ht.ve_id = v.id
WHERE dc.ma_dat_cho LIKE N'DC_SEED_%'
ORDER BY dc.ma_dat_cho;

SELECT
    dc.trang_thai AS trang_thai_dat_cho,
    COUNT(*) AS so_don,
    SUM(dc.tong_thanh_toan) AS tong_tien
FROM dbo.DAT_CHO dc
WHERE dc.ma_dat_cho LIKE N'DC_SEED_%'
GROUP BY dc.trang_thai
ORDER BY dc.trang_thai;
GO


/*=============================================================================
  11. FINAL VERIFY GĐ8 - KIỂM TRA TOÀN VẸN SAU KHI HỢP NHẤT
=============================================================================*/

PRINT N'1. Tổng hợp trạng thái DAT_CHO';
SELECT trang_thai, COUNT(*) AS so_luong
FROM dbo.DAT_CHO
GROUP BY trang_thai
ORDER BY trang_thai;
GO

PRINT N'2. Tổng hợp trạng thái GIU_CHO';
SELECT trang_thai, COUNT(*) AS so_luong
FROM dbo.GIU_CHO
GROUP BY trang_thai
ORDER BY trang_thai;
GO

PRINT N'3. Tổng hợp trạng thái VE';
SELECT trang_thai, COUNT(*) AS so_luong
FROM dbo.VE
GROUP BY trang_thai
ORDER BY trang_thai;
GO

PRINT N'4. Tổng hợp trạng thái THANH_TOAN';
SELECT trang_thai, COUNT(*) AS so_luong, COALESCE(SUM(so_tien), 0) AS tong_tien
FROM dbo.THANH_TOAN
GROUP BY trang_thai
ORDER BY trang_thai;
GO

PRINT N'5. Tổng hợp trạng thái HOAN_TIEN';
SELECT trang_thai, COUNT(*) AS so_luong, COALESCE(SUM(so_tien_hoan), 0) AS tong_tien_hoan
FROM dbo.HOAN_TIEN
GROUP BY trang_thai
ORDER BY trang_thai;
GO

PRINT N'6. Kiểm tra mã vé trùng';
SELECT ma_ve, COUNT(*) AS so_lan
FROM dbo.VE
GROUP BY ma_ve
HAVING COUNT(*) > 1;
GO

PRINT N'7. Kiểm tra hoàn tiền Chờ xử lý bị trùng theo vé';
SELECT ve_id, COUNT(*) AS so_yeu_cau_cho_xu_ly
FROM dbo.HOAN_TIEN
WHERE trang_thai = N'Chờ xử lý'
GROUP BY ve_id
HAVING COUNT(*) > 1;
GO

PRINT N'8. Kiểm tra DAT_CHO có trạng thái lạ';
SELECT id, ma_dat_cho, trang_thai
FROM dbo.DAT_CHO
WHERE trang_thai NOT IN (
    N'Chờ thanh toán',
    N'Đang thanh toán',
    N'Đã thanh toán',
    N'Đã hủy',
    N'Hết hạn',
    N'Hoàn tiền một phần',
    N'Hoàn tiền toàn bộ'
);
GO

PRINT N'9. Kiểm tra GIU_CHO có trạng thái lạ';
SELECT id, dat_cho_id, chuyen_tau_id, ghe_id, trang_thai
FROM dbo.GIU_CHO
WHERE trang_thai NOT IN (N'Đang giữ', N'Đã chuyển vé', N'Hết hạn', N'Đã hủy');
GO

PRINT N'10. Kiểm tra VE có trạng thái lạ';
SELECT id, ma_ve, trang_thai
FROM dbo.VE
WHERE trang_thai NOT IN (N'Chờ thanh toán', N'Hợp lệ', N'Đã sử dụng', N'Đã trả', N'Đã hủy');
GO

PRINT N'11. Kiểm tra THANH_TOAN có trạng thái lạ';
SELECT id, dat_cho_id, trang_thai
FROM dbo.THANH_TOAN
WHERE trang_thai NOT IN (N'Pending', N'Thành công', N'Thất bại', N'Hủy', N'Đang hoàn tiền', N'Đã hoàn tiền');
GO

PRINT N'12. Kiểm tra HOAN_TIEN có trạng thái lạ';
SELECT id, ve_id, trang_thai
FROM dbo.HOAN_TIEN
WHERE trang_thai NOT IN (N'Chờ xử lý', N'Hoàn tất', N'Từ chối');
GO

PRINT N'13. Kiểm tra VE có ghế không thuộc đúng tàu của chuyến';
SELECT v.id, v.ma_ve, v.chuyen_tau_id, v.ghe_id
FROM dbo.VE v
JOIN dbo.CHUYEN_TAU ct ON ct.id = v.chuyen_tau_id
JOIN dbo.GHE g ON g.id = v.ghe_id
JOIN dbo.TOA_TAU toa ON toa.id = g.toa_tau_id
WHERE toa.tau_id <> ct.tau_id;
GO

PRINT N'14. Kiểm tra GIU_CHO có ghế không thuộc đúng tàu của chuyến';
SELECT gc.id, gc.dat_cho_id, gc.chuyen_tau_id, gc.ghe_id
FROM dbo.GIU_CHO gc
JOIN dbo.CHUYEN_TAU ct ON ct.id = gc.chuyen_tau_id
JOIN dbo.GHE g ON g.id = gc.ghe_id
JOIN dbo.TOA_TAU toa ON toa.id = g.toa_tau_id
WHERE toa.tau_id <> ct.tau_id;
GO

PRINT N'15. Kiểm tra VE có chặng không hợp lệ theo lịch dừng';
SELECT v.id, v.ma_ve, v.chuyen_tau_id, v.ga_di_id, v.ga_den_id
FROM dbo.VE v
LEFT JOIN dbo.LICH_DUNG ld_di ON ld_di.chuyen_tau_id = v.chuyen_tau_id AND ld_di.ga_id = v.ga_di_id
LEFT JOIN dbo.LICH_DUNG ld_den ON ld_den.chuyen_tau_id = v.chuyen_tau_id AND ld_den.ga_id = v.ga_den_id
WHERE ld_di.id IS NULL OR ld_den.id IS NULL OR ld_di.thu_tu_dung >= ld_den.thu_tu_dung;
GO

PRINT N'16. Kiểm tra GIU_CHO có chặng không hợp lệ theo lịch dừng';
SELECT gc.id, gc.dat_cho_id, gc.chuyen_tau_id, gc.ga_di_id, gc.ga_den_id
FROM dbo.GIU_CHO gc
LEFT JOIN dbo.LICH_DUNG ld_di ON ld_di.chuyen_tau_id = gc.chuyen_tau_id AND ld_di.ga_id = gc.ga_di_id
LEFT JOIN dbo.LICH_DUNG ld_den ON ld_den.chuyen_tau_id = gc.chuyen_tau_id AND ld_den.ga_id = gc.ga_den_id
WHERE ld_di.id IS NULL OR ld_den.id IS NULL OR ld_di.thu_tu_dung >= ld_den.thu_tu_dung;
GO

PRINT N'17. Kiểm tra HOAN_TIEN có thanh toán không cùng đơn với vé';
SELECT ht.id AS hoan_tien_id, ht.ve_id, ht.thanh_toan_id,
       v.dat_cho_id AS dat_cho_cua_ve,
       tt.dat_cho_id AS dat_cho_cua_thanh_toan
FROM dbo.HOAN_TIEN ht
JOIN dbo.VE v ON v.id = ht.ve_id
JOIN dbo.THANH_TOAN tt ON tt.id = ht.thanh_toan_id
WHERE v.dat_cho_id <> tt.dat_cho_id;
GO

PRINT N'18. Kiểm tra HOAN_TIEN hoàn quá số tiền thanh toán';
SELECT ht.id AS hoan_tien_id, ht.so_tien_hoan, tt.so_tien AS so_tien_thanh_toan
FROM dbo.HOAN_TIEN ht
JOIN dbo.THANH_TOAN tt ON tt.id = ht.thanh_toan_id
WHERE ht.so_tien_hoan > tt.so_tien;
GO

PRINT N'19. Kiểm tra dữ liệu dashboard/report';
SELECT N'Thanh toán thành công' AS chi_so, COUNT(*) AS so_luong, COALESCE(SUM(so_tien), 0) AS tong_tien
FROM dbo.THANH_TOAN
WHERE trang_thai = N'Thành công'
UNION ALL
SELECT N'Thanh toán đang hoàn tiền', COUNT(*), COALESCE(SUM(so_tien), 0)
FROM dbo.THANH_TOAN
WHERE trang_thai = N'Đang hoàn tiền'
UNION ALL
SELECT N'Thanh toán đã hoàn tiền', COUNT(*), COALESCE(SUM(so_tien), 0)
FROM dbo.THANH_TOAN
WHERE trang_thai = N'Đã hoàn tiền';
GO

PRINT N'20. Kiểm tra dữ liệu refund admin';
SELECT TOP 20
    ht.id AS hoan_tien_id,
    ht.ve_id,
    v.ma_ve,
    dc.ma_dat_cho,
    tt.trang_thai AS trang_thai_thanh_toan,
    ht.so_tien_hoan,
    ht.trang_thai AS trang_thai_hoan_tien,
    ht.thoi_gian_yeu_cau,
    ht.thoi_gian_hoan_tat
FROM dbo.HOAN_TIEN ht
JOIN dbo.VE v ON v.id = ht.ve_id
JOIN dbo.THANH_TOAN tt ON tt.id = ht.thanh_toan_id
JOIN dbo.DAT_CHO dc ON dc.id = v.dat_cho_id
ORDER BY ht.id DESC;
GO

PRINT N'Hoàn tất FINAL_UNIFIED_VeTauDB_GD8.sql.';
GO
