using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class Ghe
{
    public int Id { get; set; }

    public int ToaTauId { get; set; }

    public string SoGhe { get; set; } = null!;

    public int? Tang { get; set; }

    public string LoaiCho { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<GiuCho> GiuChos { get; set; } = new List<GiuCho>();

    public virtual ToaTau ToaTau { get; set; } = null!;

    public virtual ICollection<Ve> Ves { get; set; } = new List<Ve>();
}
