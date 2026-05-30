using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class KhuyenMai
{
    public int Id { get; set; }

    public string MaKhuyenMai { get; set; } = null!;

    public string TenChuongTrinh { get; set; } = null!;

    public decimal PhanTramGiam { get; set; }

    public decimal? GiamToiDa { get; set; }

    public decimal GiaTriDonToiThieu { get; set; }

    public string? PhuongThucTtApDung { get; set; }

    public DateTime NgayBatDau { get; set; }

    public DateTime NgayKetThuc { get; set; }

    public int? SoLuongToiDa { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<DatCho> DatChos { get; set; } = new List<DatCho>();
}
