using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class ToaTau
{
    public int Id { get; set; }

    public int TauId { get; set; }

    public int SoToa { get; set; }

    public string LoaiToa { get; set; } = null!;

    public int SucChua { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<Ghe> Ghes { get; set; } = new List<Ghe>();

    public virtual Tau Tau { get; set; } = null!;
}
