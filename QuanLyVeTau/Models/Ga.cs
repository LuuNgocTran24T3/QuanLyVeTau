using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class Ga
{
    public int Id { get; set; }

    public string MaGa { get; set; } = null!;

    public string TenGa { get; set; } = null!;

    public string? TinhThanh { get; set; }

    public int? LyTrinhKm { get; set; }

    public string? DiaChi { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<BangGium> BangGiumGaDens { get; set; } = new List<BangGium>();

    public virtual ICollection<BangGium> BangGiumGaDis { get; set; } = new List<BangGium>();

    public virtual ICollection<GiuCho> GiuChoGaDens { get; set; } = new List<GiuCho>();

    public virtual ICollection<GiuCho> GiuChoGaDis { get; set; } = new List<GiuCho>();

    public virtual ICollection<LichDung> LichDungs { get; set; } = new List<LichDung>();

    public virtual ICollection<Ve> VeGaDens { get; set; } = new List<Ve>();

    public virtual ICollection<Ve> VeGaDis { get; set; } = new List<Ve>();
}
