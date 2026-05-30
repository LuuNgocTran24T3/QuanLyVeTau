using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class GiuCho
{
    public int Id { get; set; }

    public int DatChoId { get; set; }

    public int ChuyenTauId { get; set; }

    public int GheId { get; set; }

    public int GaDiId { get; set; }

    public int GaDenId { get; set; }

    public DateTime ThoiGianGiu { get; set; }

    public DateTime ThoiGianHetHan { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ChuyenTau ChuyenTau { get; set; } = null!;

    public virtual DatCho DatCho { get; set; } = null!;

    public virtual Ga GaDen { get; set; } = null!;

    public virtual Ga GaDi { get; set; } = null!;

    public virtual Ghe Ghe { get; set; } = null!;
}
