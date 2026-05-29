using Microsoft.AspNetCore.Mvc;

namespace QuanLyVeTau.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}