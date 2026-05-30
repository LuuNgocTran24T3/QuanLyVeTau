using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class DatCho
{
    public int Id { get; set; }

    public int KhachHangId { get; set; }

    public int? KhuyenMaiId { get; set; }

    public string MaDatCho { get; set; } = null!;

    public string LoaiDonHang { get; set; } = null!;

    public string LoaiHanhTrinh { get; set; } = null!;

    public DateTime NgayDat { get; set; }

    public decimal TongTienVeGoc { get; set; }

    public decimal ThueVat { get; set; }

    public decimal PhiThanhToan { get; set; }

    public decimal TongGiamKhuyenMai { get; set; }

    public decimal GiamGiaKhuHoi { get; set; }

    public decimal TongThanhToan { get; set; }

    public DateTime ThoiGianHetHan { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ICollection<GiuCho> GiuChos { get; set; } = new List<GiuCho>();

    public virtual KhachHang KhachHang { get; set; } = null!;

    public virtual KhuyenMai? KhuyenMai { get; set; }

    public virtual ICollection<ThanhToan> ThanhToans { get; set; } = new List<ThanhToan>();

    public virtual ICollection<Ve> Ves { get; set; } = new List<Ve>();
}
