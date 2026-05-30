using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class TripController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public TripController(VeTauDbCaiTienContext context)
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

        var data = _context.ChuyenTaus.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(ChuyenTau model)
    {
        _context.ChuyenTaus.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.ChuyenTaus.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(ChuyenTau model)
    {
        _context.ChuyenTaus.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.ChuyenTaus.Find(id);
        _context.ChuyenTaus.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}