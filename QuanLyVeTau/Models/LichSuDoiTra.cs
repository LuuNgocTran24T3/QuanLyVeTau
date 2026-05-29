using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class LichSuDoiTra
{
    public int Id { get; set; }

    public int VeId { get; set; }

    public int? NhanVienId { get; set; }

    public int? ChinhSachId { get; set; }

    public string LoaiGiaoDich { get; set; } = null!;

    public string? LyDo { get; set; }

    public decimal PhiDoi { get; set; }

    public decimal TyLeKhauTru { get; set; }

    public decimal SoTienHoan { get; set; }

    public DateTime ThoiGianXuLy { get; set; }

    public string? GhiChu { get; set; }

    public virtual ChinhSachDoiTra? ChinhSach { get; set; }

    public virtual NhanVien? NhanVien { get; set; }

    public virtual Ve Ve { get; set; } = null!;
}
