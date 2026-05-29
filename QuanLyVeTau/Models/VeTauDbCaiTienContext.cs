using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace QuanLyVeTau.Models;

public partial class VeTauDbCaiTienContext : DbContext
{
    public VeTauDbCaiTienContext()
    {
    }

    public VeTauDbCaiTienContext(DbContextOptions<VeTauDbCaiTienContext> options)
        : base(options)
    {
    }

    public virtual DbSet<BangGia> BangGia { get; set; }

    public virtual DbSet<ChinhSachDoiTra> ChinhSachDoiTras { get; set; }

    public virtual DbSet<ChuyenTau> ChuyenTaus { get; set; }

    public virtual DbSet<DatCho> DatChos { get; set; }

    public virtual DbSet<DoiTuongUuDai> DoiTuongUuDais { get; set; }

    public virtual DbSet<Ga> Gas { get; set; }

    public virtual DbSet<Ghe> Ghes { get; set; }

    public virtual DbSet<GiuCho> GiuChos { get; set; }

    public virtual DbSet<HanhKhach> HanhKhaches { get; set; }

    public virtual DbSet<HoanTien> HoanTiens { get; set; }

    public virtual DbSet<KhachHang> KhachHangs { get; set; }

    public virtual DbSet<KhuyenMai> KhuyenMais { get; set; }

    public virtual DbSet<LichDung> LichDungs { get; set; }

    public virtual DbSet<LichSuDoiTra> LichSuDoiTras { get; set; }

    public virtual DbSet<NhanVien> NhanViens { get; set; }

    public virtual DbSet<Tau> Taus { get; set; }

    public virtual DbSet<ThanhToan> ThanhToans { get; set; }

    public virtual DbSet<ToaTau> ToaTaus { get; set; }

    public virtual DbSet<Ve> Ves { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.;Database=VeTauDB_CaiTien;Trusted_Connection=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<BangGia>(entity =>
        {
            entity.ToTable("BANG_GIA");

            entity.HasIndex(e => new { e.GaDiId, e.GaDenId, e.LoaiToaApDung, e.TangApDung, e.TrangThai }, "IX_BANG_GIA_chang_loai");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.GaDenId).HasColumnName("ga_den_id");
            entity.Property(e => e.GaDiId).HasColumnName("ga_di_id");
            entity.Property(e => e.GiaCoSo)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("gia_co_so");
            entity.Property(e => e.HieuLucDen)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_den");
            entity.Property(e => e.HieuLucTu)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_tu");
            entity.Property(e => e.LoaiToaApDung)
                .HasMaxLength(40)
                .HasColumnName("loai_toa_ap_dung");
            entity.Property(e => e.PhuThuCaoDiemMacDinh)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("phu_thu_cao_diem_mac_dinh");
            entity.Property(e => e.TangApDung).HasColumnName("tang_ap_dung");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_BANG_GIA_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.GaDen).WithMany(p => p.BangGiumGaDens)
                .HasForeignKey(d => d.GaDenId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BANG_GIA_GA_DEN");

            entity.HasOne(d => d.GaDi).WithMany(p => p.BangGiumGaDis)
                .HasForeignKey(d => d.GaDiId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_BANG_GIA_GA_DI");
        });

        modelBuilder.Entity<ChinhSachDoiTra>(entity =>
        {
            entity.ToTable("CHINH_SACH_DOI_TRA");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChieuTauApDung)
                .HasMaxLength(20)
                .HasDefaultValue("Tất cả", "DF_CSDT_chieu")
                .HasColumnName("chieu_tau_ap_dung");
            entity.Property(e => e.ChoPhepDoi)
                .HasDefaultValue(true, "DF_CSDT_cho_doi")
                .HasColumnName("cho_phep_doi");
            entity.Property(e => e.ChoPhepTra)
                .HasDefaultValue(true, "DF_CSDT_cho_tra")
                .HasColumnName("cho_phep_tra");
            entity.Property(e => e.DoUuTien).HasColumnName("do_uu_tien");
            entity.Property(e => e.HieuLucDen)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_den");
            entity.Property(e => e.HieuLucTu)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_tu");
            entity.Property(e => e.LoaiDonHangApDung)
                .HasMaxLength(20)
                .HasDefaultValue("Tất cả", "DF_CSDT_loai_don")
                .HasColumnName("loai_don_hang_ap_dung");
            entity.Property(e => e.PhiDoiCoDinh)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("phi_doi_co_dinh");
            entity.Property(e => e.TenChinhSach)
                .HasMaxLength(200)
                .HasColumnName("ten_chinh_sach");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_CSDT_trang_thai")
                .HasColumnName("trang_thai");
            entity.Property(e => e.TruocKhoiHanhDenGio).HasColumnName("truoc_khoi_hanh_den_gio");
            entity.Property(e => e.TruocKhoiHanhTuGio).HasColumnName("truoc_khoi_hanh_tu_gio");
            entity.Property(e => e.TyLeKhauTru)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("ty_le_khau_tru");
        });

        modelBuilder.Entity<ChuyenTau>(entity =>
        {
            entity.ToTable("CHUYEN_TAU");

            entity.HasIndex(e => new { e.TauId, e.NgayChay }, "IX_CHUYEN_TAU_tau_ngay");

            entity.HasIndex(e => e.MaChuyen, "UQ_CHUYEN_TAU_ma_chuyen").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.GioDenDuKien)
                .HasPrecision(0)
                .HasColumnName("gio_den_du_kien");
            entity.Property(e => e.GioKhoiHanh)
                .HasPrecision(0)
                .HasColumnName("gio_khoi_hanh");
            entity.Property(e => e.MaChuyen)
                .HasMaxLength(30)
                .HasColumnName("ma_chuyen");
            entity.Property(e => e.NgayChay).HasColumnName("ngay_chay");
            entity.Property(e => e.TauId).HasColumnName("tau_id");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_CHUYEN_TAU_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.Tau).WithMany(p => p.ChuyenTaus)
                .HasForeignKey(d => d.TauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_CHUYEN_TAU_TAU");
        });

        modelBuilder.Entity<DatCho>(entity =>
        {
            entity.ToTable("DAT_CHO");

            entity.HasIndex(e => new { e.TrangThai, e.ThoiGianHetHan }, "IX_DAT_CHO_Cleanup");

            entity.HasIndex(e => new { e.TrangThai, e.NgayDat }, "IX_DAT_CHO_TrangThai_NgayDat");

            entity.HasIndex(e => new { e.KhachHangId, e.TrangThai, e.NgayDat }, "IX_DAT_CHO_khach_trang_thai").IsDescending(false, false, true);

            entity.HasIndex(e => e.MaDatCho, "UQ_DAT_CHO_ma").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.GiamGiaKhuHoi)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("giam_gia_khu_hoi");
            entity.Property(e => e.KhachHangId).HasColumnName("khach_hang_id");
            entity.Property(e => e.KhuyenMaiId).HasColumnName("khuyen_mai_id");
            entity.Property(e => e.LoaiDonHang)
                .HasMaxLength(20)
                .HasDefaultValue("Cá nhân", "DF_DAT_CHO_loai_don")
                .HasColumnName("loai_don_hang");
            entity.Property(e => e.LoaiHanhTrinh)
                .HasMaxLength(20)
                .HasDefaultValue("Một chiều", "DF_DAT_CHO_hanh_trinh")
                .HasColumnName("loai_hanh_trinh");
            entity.Property(e => e.MaDatCho)
                .HasMaxLength(30)
                .HasColumnName("ma_dat_cho");
            entity.Property(e => e.NgayDat)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_DAT_CHO_ngay_dat")
                .HasColumnName("ngay_dat");
            entity.Property(e => e.PhiThanhToan)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("phi_thanh_toan");
            entity.Property(e => e.ThoiGianHetHan)
                .HasPrecision(0)
                .HasColumnName("thoi_gian_het_han");
            entity.Property(e => e.ThueVat)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("thue_vat");
            entity.Property(e => e.TongGiamKhuyenMai)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("tong_giam_khuyen_mai");
            entity.Property(e => e.TongThanhToan)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("tong_thanh_toan");
            entity.Property(e => e.TongTienVeGoc)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("tong_tien_ve_goc");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(30)
                .HasDefaultValue("Chờ thanh toán", "DF_DAT_CHO_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.KhachHang).WithMany(p => p.DatChos)
                .HasForeignKey(d => d.KhachHangId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DAT_CHO_KHACH_HANG");

            entity.HasOne(d => d.KhuyenMai).WithMany(p => p.DatChos)
                .HasForeignKey(d => d.KhuyenMaiId)
                .HasConstraintName("FK_DAT_CHO_KHUYEN_MAI");
        });

        modelBuilder.Entity<DoiTuongUuDai>(entity =>
        {
            entity.ToTable("DOI_TUONG_UU_DAI");

            entity.HasIndex(e => e.MaDoiTuong, "UQ_DOI_TUONG_UU_DAI_ma").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CanGiayToChungMinh).HasColumnName("can_giay_to_chung_minh");
            entity.Property(e => e.HieuLucDen)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_den");
            entity.Property(e => e.HieuLucTu)
                .HasPrecision(0)
                .HasColumnName("hieu_luc_tu");
            entity.Property(e => e.MaDoiTuong)
                .HasMaxLength(30)
                .HasColumnName("ma_doi_tuong");
            entity.Property(e => e.PhanTramGiam)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("phan_tram_giam");
            entity.Property(e => e.TenDoiTuong)
                .HasMaxLength(100)
                .HasColumnName("ten_doi_tuong");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_DOI_TUONG_UU_DAI_trang_thai")
                .HasColumnName("trang_thai");
            entity.Property(e => e.TuoiMax).HasColumnName("tuoi_max");
            entity.Property(e => e.TuoiMin).HasColumnName("tuoi_min");
        });

        modelBuilder.Entity<Ga>(entity =>
        {
            entity.ToTable("GA");

            entity.HasIndex(e => e.MaGa, "UQ_GA_ma_ga").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DiaChi).HasColumnName("dia_chi");
            entity.Property(e => e.LyTrinhKm).HasColumnName("ly_trinh_km");
            entity.Property(e => e.MaGa)
                .HasMaxLength(10)
                .HasColumnName("ma_ga");
            entity.Property(e => e.TenGa)
                .HasMaxLength(100)
                .HasColumnName("ten_ga");
            entity.Property(e => e.TinhThanh)
                .HasMaxLength(100)
                .HasColumnName("tinh_thanh");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động", "DF_GA_trang_thai")
                .HasColumnName("trang_thai");
        });

        modelBuilder.Entity<Ghe>(entity =>
        {
            entity.ToTable("GHE");

            entity.HasIndex(e => e.ToaTauId, "IX_GHE_toa_tau_id");

            entity.HasIndex(e => new { e.ToaTauId, e.SoGhe }, "UQ_GHE_toa_so_ghe").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.LoaiCho)
                .HasMaxLength(20)
                .HasColumnName("loai_cho");
            entity.Property(e => e.SoGhe)
                .HasMaxLength(10)
                .HasColumnName("so_ghe");
            entity.Property(e => e.Tang).HasColumnName("tang");
            entity.Property(e => e.ToaTauId).HasColumnName("toa_tau_id");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_GHE_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.ToaTau).WithMany(p => p.Ghes)
                .HasForeignKey(d => d.ToaTauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GHE_TOA_TAU");
        });

        modelBuilder.Entity<GiuCho>(entity =>
        {
            entity.ToTable("GIU_CHO", tb => tb.HasTrigger("trg_GIU_CHO_ValidateSegmentAndOverlap"));

            entity.HasIndex(e => new { e.ChuyenTauId, e.GheId, e.TrangThai, e.ThoiGianHetHan }, "IX_GIU_CHO_Chuyen_Ghe_TrangThai_HetHan");

            entity.HasIndex(e => new { e.DatChoId, e.TrangThai }, "IX_GIU_CHO_DatCho_TrangThai");

            entity.HasIndex(e => new { e.ChuyenTauId, e.GheId, e.TrangThai, e.ThoiGianHetHan }, "IX_GIU_CHO_chuyen_ghe_trang_thai");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChuyenTauId).HasColumnName("chuyen_tau_id");
            entity.Property(e => e.DatChoId).HasColumnName("dat_cho_id");
            entity.Property(e => e.GaDenId).HasColumnName("ga_den_id");
            entity.Property(e => e.GaDiId).HasColumnName("ga_di_id");
            entity.Property(e => e.GheId).HasColumnName("ghe_id");
            entity.Property(e => e.ThoiGianGiu)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_GIU_CHO_thoi_gian_giu")
                .HasColumnName("thoi_gian_giu");
            entity.Property(e => e.ThoiGianHetHan)
                .HasPrecision(0)
                .HasColumnName("thoi_gian_het_han");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Đang giữ", "DF_GIU_CHO_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.ChuyenTau).WithMany(p => p.GiuChos)
                .HasForeignKey(d => d.ChuyenTauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GIU_CHO_CHUYEN_TAU");

            entity.HasOne(d => d.DatCho).WithMany(p => p.GiuChos)
                .HasForeignKey(d => d.DatChoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GIU_CHO_DAT_CHO");

            entity.HasOne(d => d.GaDen).WithMany(p => p.GiuChoGaDens)
                .HasForeignKey(d => d.GaDenId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GIU_CHO_GA_DEN");

            entity.HasOne(d => d.GaDi).WithMany(p => p.GiuChoGaDis)
                .HasForeignKey(d => d.GaDiId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GIU_CHO_GA_DI");

            entity.HasOne(d => d.Ghe).WithMany(p => p.GiuChos)
                .HasForeignKey(d => d.GheId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_GIU_CHO_GHE");
        });

        modelBuilder.Entity<HanhKhach>(entity =>
        {
            entity.ToTable("HANH_KHACH");

            entity.HasIndex(e => new { e.LoaiGiayTo, e.SoGiayTo }, "UQ_HANH_KHACH_giay_to").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("ho_ten");
            entity.Property(e => e.LoaiGiayTo)
                .HasMaxLength(30)
                .HasColumnName("loai_giay_to");
            entity.Property(e => e.NgaySinh).HasColumnName("ngay_sinh");
            entity.Property(e => e.QuocTich)
                .HasMaxLength(80)
                .HasColumnName("quoc_tich");
            entity.Property(e => e.SoGiayTo)
                .HasMaxLength(50)
                .HasColumnName("so_giay_to");
        });

        modelBuilder.Entity<HoanTien>(entity =>
        {
            entity.ToTable("HOAN_TIEN", tb => tb.HasTrigger("trg_HOAN_TIEN_ValidatePaymentTicket"));

            entity.HasIndex(e => e.ThanhToanId, "IX_HOAN_TIEN_ThanhToanId");

            entity.HasIndex(e => new { e.TrangThai, e.ThoiGianYeuCau, e.Id }, "IX_HOAN_TIEN_TrangThai_ThoiGian").IsDescending(false, true, true);

            entity.HasIndex(e => new { e.TrangThai, e.ThoiGianHoanTat }, "IX_HOAN_TIEN_TrangThai_ThoiGianHoanTat");

            entity.HasIndex(e => new { e.VeId, e.TrangThai, e.Id }, "IX_HOAN_TIEN_VeId_TrangThai").IsDescending(false, false, true);

            entity.HasIndex(e => new { e.VeId, e.TrangThai }, "IX_HOAN_TIEN_ve_trang_thai");

            entity.HasIndex(e => e.VeId, "UX_HOAN_TIEN_OnePendingPerTicket")
                .IsUnique()
                .HasFilter("([trang_thai]=N'Chờ xử lý')");

            entity.HasIndex(e => e.MaGiaoDichHoan, "UX_HOAN_TIEN_ma_giao_dich_hoan")
                .IsUnique()
                .HasFilter("([ma_giao_dich_hoan] IS NOT NULL)");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.MaGiaoDichHoan)
                .HasMaxLength(100)
                .HasColumnName("ma_giao_dich_hoan");
            entity.Property(e => e.SoTienHoan)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("so_tien_hoan");
            entity.Property(e => e.ThanhToanId).HasColumnName("thanh_toan_id");
            entity.Property(e => e.ThoiGianHoanTat)
                .HasPrecision(0)
                .HasColumnName("thoi_gian_hoan_tat");
            entity.Property(e => e.ThoiGianYeuCau)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_HOAN_TIEN_yeu_cau")
                .HasColumnName("thoi_gian_yeu_cau");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Chờ xử lý", "DF_HOAN_TIEN_trang_thai")
                .HasColumnName("trang_thai");
            entity.Property(e => e.VeId).HasColumnName("ve_id");

            entity.HasOne(d => d.ThanhToan).WithMany(p => p.HoanTiens)
                .HasForeignKey(d => d.ThanhToanId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HOAN_TIEN_THANH_TOAN");

            entity.HasOne(d => d.Ve).WithOne(p => p.HoanTien)
                .HasForeignKey<HoanTien>(d => d.VeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_HOAN_TIEN_VE");
        });

        modelBuilder.Entity<KhachHang>(entity =>
        {
            entity.ToTable("KHACH_HANG");

            entity.HasIndex(e => e.NgayTao, "IX_KHACH_HANG_NgayTao");

            entity.HasIndex(e => e.Email, "UQ_KHACH_HANG_email").IsUnique();

            entity.HasIndex(e => e.SoDienThoai, "UQ_KHACH_HANG_so_dien_thoai").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DiaChi).HasColumnName("dia_chi");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.GioiTinh)
                .HasMaxLength(10)
                .HasColumnName("gioi_tinh");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("ho_ten");
            entity.Property(e => e.MatKhauHash)
                .HasMaxLength(255)
                .HasColumnName("mat_khau_hash");
            entity.Property(e => e.NgaySinh).HasColumnName("ngay_sinh");
            entity.Property(e => e.NgayTao)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_KHACH_HANG_ngay_tao")
                .HasColumnName("ngay_tao");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(15)
                .HasColumnName("so_dien_thoai");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_KHACH_HANG_trang_thai")
                .HasColumnName("trang_thai");
        });

        modelBuilder.Entity<KhuyenMai>(entity =>
        {
            entity.ToTable("KHUYEN_MAI");

            entity.HasIndex(e => e.MaKhuyenMai, "UQ_KHUYEN_MAI_ma").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.GiaTriDonToiThieu)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("gia_tri_don_toi_thieu");
            entity.Property(e => e.GiamToiDa)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("giam_toi_da");
            entity.Property(e => e.MaKhuyenMai)
                .HasMaxLength(30)
                .HasColumnName("ma_khuyen_mai");
            entity.Property(e => e.NgayBatDau)
                .HasPrecision(0)
                .HasColumnName("ngay_bat_dau");
            entity.Property(e => e.NgayKetThuc)
                .HasPrecision(0)
                .HasColumnName("ngay_ket_thuc");
            entity.Property(e => e.PhanTramGiam)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("phan_tram_giam");
            entity.Property(e => e.PhuongThucTtApDung)
                .HasMaxLength(30)
                .HasColumnName("phuong_thuc_tt_ap_dung");
            entity.Property(e => e.SoLuongToiDa).HasColumnName("so_luong_toi_da");
            entity.Property(e => e.TenChuongTrinh)
                .HasMaxLength(200)
                .HasColumnName("ten_chuong_trinh");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_KHUYEN_MAI_trang_thai")
                .HasColumnName("trang_thai");
        });

        modelBuilder.Entity<LichDung>(entity =>
        {
            entity.ToTable("LICH_DUNG");

            entity.HasIndex(e => new { e.ChuyenTauId, e.ThuTuDung }, "IX_LICH_DUNG_chuyen_thu_tu");

            entity.HasIndex(e => new { e.ChuyenTauId, e.GaId }, "UQ_LICH_DUNG_chuyen_ga").IsUnique();

            entity.HasIndex(e => new { e.ChuyenTauId, e.ThuTuDung }, "UQ_LICH_DUNG_chuyen_thu_tu").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChuyenTauId).HasColumnName("chuyen_tau_id");
            entity.Property(e => e.GaId).HasColumnName("ga_id");
            entity.Property(e => e.ThoiGianDen)
                .HasPrecision(0)
                .HasColumnName("thoi_gian_den");
            entity.Property(e => e.ThoiGianDi)
                .HasPrecision(0)
                .HasColumnName("thoi_gian_di");
            entity.Property(e => e.ThuTuDung).HasColumnName("thu_tu_dung");

            entity.HasOne(d => d.ChuyenTau).WithMany(p => p.LichDungs)
                .HasForeignKey(d => d.ChuyenTauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LICH_DUNG_CHUYEN_TAU");

            entity.HasOne(d => d.Ga).WithMany(p => p.LichDungs)
                .HasForeignKey(d => d.GaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LICH_DUNG_GA");
        });

        modelBuilder.Entity<LichSuDoiTra>(entity =>
        {
            entity.ToTable("LICH_SU_DOI_TRA");

            entity.HasIndex(e => new { e.VeId, e.Id }, "IX_LICH_SU_DOI_TRA_VeId_IdDesc").IsDescending(false, true);

            entity.HasIndex(e => e.VeId, "IX_LSDT_ve");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChinhSachId).HasColumnName("chinh_sach_id");
            entity.Property(e => e.GhiChu).HasColumnName("ghi_chu");
            entity.Property(e => e.LoaiGiaoDich)
                .HasMaxLength(20)
                .HasColumnName("loai_giao_dich");
            entity.Property(e => e.LyDo)
                .HasMaxLength(500)
                .HasColumnName("ly_do");
            entity.Property(e => e.NhanVienId).HasColumnName("nhan_vien_id");
            entity.Property(e => e.PhiDoi)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("phi_doi");
            entity.Property(e => e.SoTienHoan)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("so_tien_hoan");
            entity.Property(e => e.ThoiGianXuLy)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_LSDT_thoi_gian")
                .HasColumnName("thoi_gian_xu_ly");
            entity.Property(e => e.TyLeKhauTru)
                .HasColumnType("decimal(5, 2)")
                .HasColumnName("ty_le_khau_tru");
            entity.Property(e => e.VeId).HasColumnName("ve_id");

            entity.HasOne(d => d.ChinhSach).WithMany(p => p.LichSuDoiTras)
                .HasForeignKey(d => d.ChinhSachId)
                .HasConstraintName("FK_LSDT_CHINH_SACH");

            entity.HasOne(d => d.NhanVien).WithMany(p => p.LichSuDoiTras)
                .HasForeignKey(d => d.NhanVienId)
                .HasConstraintName("FK_LSDT_NHAN_VIEN");

            entity.HasOne(d => d.Ve).WithMany(p => p.LichSuDoiTras)
                .HasForeignKey(d => d.VeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_LSDT_VE");
        });

        modelBuilder.Entity<NhanVien>(entity =>
        {
            entity.ToTable("NHAN_VIEN");

            entity.HasIndex(e => e.Email, "UQ_NHAN_VIEN_email").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChucVu)
                .HasMaxLength(20)
                .HasColumnName("chuc_vu");
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .HasColumnName("email");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("ho_ten");
            entity.Property(e => e.MatKhauHash)
                .HasMaxLength(255)
                .HasColumnName("mat_khau_hash");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Hoạt động", "DF_NHAN_VIEN_trang_thai")
                .HasColumnName("trang_thai");
        });

        modelBuilder.Entity<Tau>(entity =>
        {
            entity.ToTable("TAU");

            entity.HasIndex(e => e.MaTau, "UQ_TAU_ma_tau").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChieuDi)
                .HasMaxLength(20)
                .HasDefaultValue("Không xác định", "DF_TAU_chieu_di")
                .HasColumnName("chieu_di");
            entity.Property(e => e.MaTau)
                .HasMaxLength(10)
                .HasColumnName("ma_tau");
            entity.Property(e => e.MoTa).HasColumnName("mo_ta");
            entity.Property(e => e.TenTau)
                .HasMaxLength(100)
                .HasColumnName("ten_tau");
            entity.Property(e => e.ThuocTuyenThongNhat).HasColumnName("thuoc_tuyen_thong_nhat");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động", "DF_TAU_trang_thai")
                .HasColumnName("trang_thai");
        });

        modelBuilder.Entity<ThanhToan>(entity =>
        {
            entity.ToTable("THANH_TOAN");

            entity.HasIndex(e => new { e.DatChoId, e.TrangThai }, "IX_THANH_TOAN_DatCho_TrangThai");

            entity.HasIndex(e => new { e.TrangThai, e.NgayThanhToan }, "IX_THANH_TOAN_TrangThai_NgayThanhToan");

            entity.HasIndex(e => new { e.DatChoId, e.TrangThai }, "IX_THANH_TOAN_dat_cho_trang_thai");

            entity.HasIndex(e => e.RequestId, "UQ_THANH_TOAN_request_id").IsUnique();

            entity.HasIndex(e => e.MaGiaoDich, "UX_THANH_TOAN_ma_giao_dich")
                .IsUnique()
                .HasFilter("([ma_giao_dich] IS NOT NULL)");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.DatChoId).HasColumnName("dat_cho_id");
            entity.Property(e => e.MaGiaoDich)
                .HasMaxLength(100)
                .HasColumnName("ma_giao_dich");
            entity.Property(e => e.NgayTao)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_THANH_TOAN_ngay_tao")
                .HasColumnName("ngay_tao");
            entity.Property(e => e.NgayThanhToan)
                .HasPrecision(0)
                .HasColumnName("ngay_thanh_toan");
            entity.Property(e => e.PhuongThuc)
                .HasMaxLength(30)
                .HasColumnName("phuong_thuc");
            entity.Property(e => e.RequestId)
                .HasMaxLength(100)
                .HasColumnName("request_id");
            entity.Property(e => e.SoTien)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("so_tien");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(30)
                .HasDefaultValue("Pending", "DF_THANH_TOAN_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.DatCho).WithMany(p => p.ThanhToans)
                .HasForeignKey(d => d.DatChoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_THANH_TOAN_DAT_CHO");
        });

        modelBuilder.Entity<ToaTau>(entity =>
        {
            entity.ToTable("TOA_TAU");

            entity.HasIndex(e => e.TauId, "IX_TOA_TAU_tau_id");

            entity.HasIndex(e => new { e.TauId, e.SoToa }, "UQ_TOA_TAU_tau_so_toa").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.LoaiToa)
                .HasMaxLength(40)
                .HasColumnName("loai_toa");
            entity.Property(e => e.SoToa).HasColumnName("so_toa");
            entity.Property(e => e.SucChua).HasColumnName("suc_chua");
            entity.Property(e => e.TauId).HasColumnName("tau_id");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động", "DF_TOA_TAU_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.Tau).WithMany(p => p.ToaTaus)
                .HasForeignKey(d => d.TauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_TOA_TAU_TAU");
        });

        modelBuilder.Entity<Ve>(entity =>
        {
            entity.ToTable("VE", tb => tb.HasTrigger("trg_VE_ValidateSegmentAndOverlap"));

            entity.HasIndex(e => new { e.ChuyenTauId, e.GheId, e.TrangThai }, "IX_VE_Chuyen_Ghe_TrangThai");

            entity.HasIndex(e => new { e.DatChoId, e.TrangThai }, "IX_VE_DatCho_TrangThai");

            entity.HasIndex(e => new { e.TrangThai, e.DatChoId }, "IX_VE_TrangThai_DatCho");

            entity.HasIndex(e => new { e.ChuyenTauId, e.GheId, e.TrangThai }, "IX_VE_chuyen_ghe_trang_thai");

            entity.HasIndex(e => e.HanhKhachId, "IX_VE_hanh_khach");

            entity.HasIndex(e => e.MaVe, "UQ_VE_ma").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChuyenTauId).HasColumnName("chuyen_tau_id");
            entity.Property(e => e.DatChoId).HasColumnName("dat_cho_id");
            entity.Property(e => e.DoiTuongUuDaiId).HasColumnName("doi_tuong_uu_dai_id");
            entity.Property(e => e.GaDenId).HasColumnName("ga_den_id");
            entity.Property(e => e.GaDiId).HasColumnName("ga_di_id");
            entity.Property(e => e.GheId).HasColumnName("ghe_id");
            entity.Property(e => e.GiaCoSo)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("gia_co_so");
            entity.Property(e => e.GiaVeChiTiet)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("gia_ve_chi_tiet");
            entity.Property(e => e.GiamDoiTuong)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("giam_doi_tuong");
            entity.Property(e => e.HanhKhachId).HasColumnName("hanh_khach_id");
            entity.Property(e => e.MaVe)
                .HasMaxLength(40)
                .HasColumnName("ma_ve");
            entity.Property(e => e.PhuThuCaoDiem)
                .HasColumnType("decimal(12, 2)")
                .HasColumnName("phu_thu_cao_diem");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Chờ thanh toán", "DF_VE_trang_thai")
                .HasColumnName("trang_thai");

            entity.HasOne(d => d.ChuyenTau).WithMany(p => p.Ves)
                .HasForeignKey(d => d.ChuyenTauId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_CHUYEN_TAU");

            entity.HasOne(d => d.DatCho).WithMany(p => p.Ves)
                .HasForeignKey(d => d.DatChoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_DAT_CHO");

            entity.HasOne(d => d.DoiTuongUuDai).WithMany(p => p.Ves)
                .HasForeignKey(d => d.DoiTuongUuDaiId)
                .HasConstraintName("FK_VE_DOI_TUONG_UU_DAI");

            entity.HasOne(d => d.GaDen).WithMany(p => p.VeGaDens)
                .HasForeignKey(d => d.GaDenId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_GA_DEN");

            entity.HasOne(d => d.GaDi).WithMany(p => p.VeGaDis)
                .HasForeignKey(d => d.GaDiId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_GA_DI");

            entity.HasOne(d => d.Ghe).WithMany(p => p.Ves)
                .HasForeignKey(d => d.GheId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_GHE");

            entity.HasOne(d => d.HanhKhach).WithMany(p => p.Ves)
                .HasForeignKey(d => d.HanhKhachId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VE_HANH_KHACH");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
