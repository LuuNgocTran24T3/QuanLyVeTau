using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class SeatController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public SeatController(VeTauDbCaiTienContext context)
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

        var data = _context.Ghes.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(Ghe model)
    {
        _context.Ghes.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.Ghes.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(Ghe model)
    {
        _context.Ghes.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.Ghes.Find(id);
        _context.Ghes.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}