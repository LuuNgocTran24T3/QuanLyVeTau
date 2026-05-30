using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class ThanhToan
{
    public int Id { get; set; }

    public int DatChoId { get; set; }

    public string? MaGiaoDich { get; set; }

    public string RequestId { get; set; } = null!;

    public string PhuongThuc { get; set; } = null!;

    public decimal SoTien { get; set; }

    public DateTime NgayTao { get; set; }

    public DateTime? NgayThanhToan { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual DatCho DatCho { get; set; } = null!;

    public virtual ICollection<HoanTien> HoanTiens { get; set; } = new List<HoanTien>();
}
