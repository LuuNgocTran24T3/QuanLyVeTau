using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class HanhKhach
{
    public int Id { get; set; }

    public string HoTen { get; set; } = null!;

    public string LoaiGiayTo { get; set; } = null!;

    public string SoGiayTo { get; set; } = null!;

    public DateOnly? NgaySinh { get; set; }

    public string? QuocTich { get; set; }

    public virtual ICollection<Ve> Ves { get; set; } = new List<Ve>();
}
