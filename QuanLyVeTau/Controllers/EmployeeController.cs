using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class EmployeeController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public EmployeeController(VeTauDbCaiTienContext context)
    {
        _context = context;
    }

    // READ
    public IActionResult Index()
    {
        if (HttpContext.Session.GetString("role") != "Staff")
        {
            return RedirectToAction("Login", "Account");
        }

        var data = _context.NhanViens.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(NhanVien model)
    {
        _context.NhanViens.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.NhanViens.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(NhanVien model)
    {
        _context.NhanViens.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.NhanViens.Find(id);
        _context.NhanViens.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}