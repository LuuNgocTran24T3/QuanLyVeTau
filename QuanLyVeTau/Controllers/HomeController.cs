using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

namespace QuanLyVeTau.Controllers
{
    public class HomeController : Controller
    {
        private readonly VeTauDbCaiTienContext _context;

        public HomeController(VeTauDbCaiTienContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            ViewBag.TotalTrain = _context.Taus.Count();
            ViewBag.TotalTicket = _context.Ves.Count();
            ViewBag.TotalCustomer = _context.KhachHangs.Count();

            return View();
        }
    }
}