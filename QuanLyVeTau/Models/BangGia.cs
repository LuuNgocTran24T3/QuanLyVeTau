using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class BangGia
{
    public int Id { get; set; }

    public int GaDiId { get; set; }

    public int GaDenId { get; set; }

    public string LoaiToaApDung { get; set; } = null!;

    public int? TangApDung { get; set; }

    public decimal GiaCoSo { get; set; }

    public decimal PhuThuCaoDiemMacDinh { get; set; }

    public DateTime HieuLucTu { get; set; }

    public DateTime? HieuLucDen { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual Ga GaDen { get; set; } = null!;

    public virtual Ga GaDi { get; set; } = null!;
}
