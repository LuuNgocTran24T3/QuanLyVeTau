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
            var customer = _context.KhachHangs
                .FirstOrDefault(x =>
                    x.Email == email &&
                    x.MatKhauHash == password);

            if (customer != null)
            {
                HttpContext.Session.SetString("userName", customer.HoTen);
                HttpContext.Session.SetString("role", "Customer");
                HttpContext.Session.SetString("userId", customer.Id.ToString());
                return RedirectToAction("Index", "Home");
            }

            var staff = _context.NhanViens
                .FirstOrDefault(x =>
                    x.Email == email &&
                    x.MatKhauHash == password);

            if (staff != null)
            {
                HttpContext.Session.SetString("userName", staff.HoTen);
                HttpContext.Session.SetString("role", "Staff");
                HttpContext.Session.SetString("userId", staff.Id.ToString());

                return RedirectToAction("Index", "Dashboard");
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