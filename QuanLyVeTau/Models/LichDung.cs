using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class LichDung
{
    public int Id { get; set; }

    public int ChuyenTauId { get; set; }

    public int GaId { get; set; }

    public int ThuTuDung { get; set; }

    public DateTime? ThoiGianDen { get; set; }

    public DateTime? ThoiGianDi { get; set; }

    public virtual ChuyenTau ChuyenTau { get; set; } = null!;

    public virtual Ga Ga { get; set; } = null!;
}
