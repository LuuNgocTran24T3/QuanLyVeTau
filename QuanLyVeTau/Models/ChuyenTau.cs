using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class ChuyenTau
{
    public int Id { get; set; }

    public int TauId { get; set; }

    public string MaChuyen { get; set; } = null!;

    public DateOnly NgayChay { get; set; }

    public DateTime GioKhoiHanh { get; set; }

    public DateTime? GioDenDuKien { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<GiuCho> GiuChos { get; set; } = new List<GiuCho>();

    public virtual ICollection<LichDung> LichDungs { get; set; } = new List<LichDung>();

    public virtual Tau Tau { get; set; } = null!;

    public virtual ICollection<Ve> Ves { get; set; } = new List<Ve>();
}
