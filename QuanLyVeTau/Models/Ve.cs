using System;
using System.Collections.Generic;

namespace QuanLyVeTau.Models;

public partial class Ve
{
    public int Id { get; set; }

    public int DatChoId { get; set; }

    public int ChuyenTauId { get; set; }

    public int GheId { get; set; }

    public int HanhKhachId { get; set; }

    public int? DoiTuongUuDaiId { get; set; }

    public int GaDiId { get; set; }

    public int GaDenId { get; set; }

    public string MaVe { get; set; } = null!;

    public decimal GiaCoSo { get; set; }

    public decimal GiamDoiTuong { get; set; }

    public decimal PhuThuCaoDiem { get; set; }

    public decimal GiaVeChiTiet { get; set; }

    public string TrangThai { get; set; } = null!;

    public virtual ChuyenTau ChuyenTau { get; set; } = null!;

    public virtual DatCho DatCho { get; set; } = null!;

    public virtual DoiTuongUuDai? DoiTuongUuDai { get; set; }

    public virtual Ga GaDen { get; set; } = null!;

    public virtual Ga GaDi { get; set; } = null!;

    public virtual Ghe Ghe { get; set; } = null!;

    public virtual HanhKhach HanhKhach { get; set; } = null!;

    public virtual HoanTien? HoanTien { get; set; }

    public virtual ICollection<LichSuDoiTra> LichSuDoiTras { get; set; } = new List<LichSuDoiTra>();
}
