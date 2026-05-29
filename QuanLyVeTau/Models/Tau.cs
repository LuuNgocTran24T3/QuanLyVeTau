using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class Tau
{
    public int Id { get; set; }

    public string MaTau { get; set; } = null!;

    public string TenTau { get; set; } = null!;

    public string ChieuDi { get; set; } = null!;

    public bool ThuocTuyenThongNhat { get; set; }

    public string? MoTa { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<ChuyenTau> ChuyenTaus { get; set; } = new List<ChuyenTau>();

    public virtual ICollection<ToaTau> ToaTaus { get; set; } = new List<ToaTau>();
}
