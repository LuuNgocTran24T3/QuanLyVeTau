using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class HoanTien
{
    public int Id { get; set; }

    public int ThanhToanId { get; set; }

    public int VeId { get; set; }

    public decimal SoTienHoan { get; set; }

    public string? MaGiaoDichHoan { get; set; }

    public DateTime ThoiGianYeuCau { get; set; }

    public DateTime? ThoiGianHoanTat { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ThanhToan ThanhToan { get; set; } = null!;

    public virtual Ve Ve { get; set; } = null!;
}
