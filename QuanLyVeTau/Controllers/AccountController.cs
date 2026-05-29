using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

namespace QuanLyVeTau.Controllers
{
    public class AccountController : Controller
    {
        private readonly VeTauDbCaiTienContext _context;

        // constructor
        public AccountController(VeTauDbCaiTienContext context)
        {
            _context = context;
        }

        // GET LOGIN
        public IActionResult Login()
        {
            return View();
        }

        // POST LOGIN
        [HttpPost]
        public IActionResult Login(string email, string password)
        {
            var user = _context.KhachHangs
                .FirstOrDefault(x =>
                    x.Email == email &&
                    x.MatKhauHash == password);

            if (user != null)
            {
                HttpContext.Session.SetString(
                    "user",
                    user.Email
                );

                return RedirectToAction(
                    "Index",
                    "Home"
                );
            }

            ViewBag.Error = "Sai tài khoản hoặc mật khẩu";

            return View();
        }

        // LOGOUT
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();

            return RedirectToAction("Login");
        }
    }
}