using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class DashboardController : Controller
{
    private readonly VeTauDbCaiTienContext _context;

    public DashboardController(VeTauDbCaiTienContext context)
    {
        _context = context;
    }

    public IActionResult Index()
    {
        if (HttpContext.Session.GetString("role") != "Staff")
        {
            return RedirectToAction("Login", "Account");
        }

        ViewBag.TotalTrain = _context.Taus.Count();
        ViewBag.TotalTicket = _context.Ves.Count();
        ViewBag.TotalCustomer = _context.KhachHangs.Count();

        return View();
    }
}