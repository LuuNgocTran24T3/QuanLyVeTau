using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class KhachHang
{
    public int Id { get; set; }

    public string HoTen { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? SoDienThoai { get; set; }

    public string MatKhauHash { get; set; } = null!;

    public DateOnly? NgaySinh { get; set; }

    public string? GioiTinh { get; set; }

    public string? DiaChi { get; set; }

    public DateTime NgayTao { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<DatCho> DatChos { get; set; } = new List<DatCho>();
}
