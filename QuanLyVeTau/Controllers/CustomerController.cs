using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class CustomerController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public CustomerController(VeTauDbCaiTienContext context)
    {
        _context = context;
    }

    // READ
    public IActionResult Index()
    {
        if (HttpContext.Session.GetString("role") != "Customer")
        {
            return RedirectToAction("Login", "Account");
        }

        var data = _context.KhachHangs.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(KhachHang model)
    {
        _context.KhachHangs.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.KhachHangs.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(KhachHang model)
    {
        _context.KhachHangs.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.KhachHangs.Find(id);
        _context.KhachHangs.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}