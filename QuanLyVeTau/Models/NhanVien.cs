using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class NhanVien
{
    public int Id { get; set; }

    public string HoTen { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string MatKhauHash { get; set; } = null!;

    public string ChucVu { get; set; } = null!;

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<LichSuDoiTra> LichSuDoiTras { get; set; } = new List<LichSuDoiTra>();
}
