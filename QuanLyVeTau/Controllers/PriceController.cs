using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class PriceController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public PriceController(VeTauDbCaiTienContext context)
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

        var data = _context.BangGias.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(BangGia model)
    {
        _context.BangGias.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.BangGias.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(BangGia model)
    {
        _context.BangGias.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.BangGias.Find(id);
        _context.BangGias.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}