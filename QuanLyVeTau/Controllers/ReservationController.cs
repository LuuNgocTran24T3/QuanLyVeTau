using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class ReservationController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public ReservationController(VeTauDbCaiTienContext context)
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

        var data = _context.GiuChos.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(GiuCho model)
    {
        _context.GiuChos.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.GiuChos.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(GiuCho model)
    {
        _context.GiuChos.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.GiuChos.Find(id);
        _context.GiuChos.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}