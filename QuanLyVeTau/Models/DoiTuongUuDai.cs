using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class DoiTuongUuDai
{
    public int Id { get; set; }

    public string MaDoiTuong { get; set; } = null!;

    public string TenDoiTuong { get; set; } = null!;

    public decimal PhanTramGiam { get; set; }

    public int? TuoiMin { get; set; }

    public int? TuoiMax { get; set; }

    public bool CanGiayToChungMinh { get; set; }

    public DateTime? HieuLucTu { get; set; }

    public DateTime? HieuLucDen { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<Ve> Ves { get; set; } = new List<Ve>();
}
