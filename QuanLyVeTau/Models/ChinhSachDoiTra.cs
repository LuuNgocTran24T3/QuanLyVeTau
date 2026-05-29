using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class ChinhSachDoiTra
{
    public int Id { get; set; }

    public string TenChinhSach { get; set; } = null!;

    public string LoaiDonHangApDung { get; set; } = null!;

    public string ChieuTauApDung { get; set; } = null!;

    public int? TruocKhoiHanhTuGio { get; set; }

    public int? TruocKhoiHanhDenGio { get; set; }

    public decimal TyLeKhauTru { get; set; }

    public decimal PhiDoiCoDinh { get; set; }

    public bool ChoPhepDoi { get; set; }

    public bool ChoPhepTra { get; set; }

    public DateTime HieuLucTu { get; set; }

    public DateTime? HieuLucDen { get; set; }

    public int DoUuTien { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<LichSuDoiTra> LichSuDoiTras { get; set; } = new List<LichSuDoiTra>();
}
