using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class BookingController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public BookingController(VeTauDbCaiTienContext context)
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

        var data = _context.DatChos.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(DatCho model)
    {
        _context.DatChos.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.DatChos.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(DatCho model)
    {
        _context.DatChos.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.DatChos.Find(id);
        _context.DatChos.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}