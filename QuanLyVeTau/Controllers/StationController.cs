using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class StationController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public StationController(VeTauDbCaiTienContext context)
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

        var data = _context.Gas.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(Ga model)
    {
        _context.Gas.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.Gas.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(Ga model)
    {
        _context.Gas.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.Gas.Find(id);
        _context.Gas.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}