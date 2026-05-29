using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;
public class TicketController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public TicketController(VeTauDbCaiTienContext context)
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

        var data = _context.Ves.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(Ve model)
    {
        _context.Ves.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.Ves.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(Ve model)
    {
        _context.Ves.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.Ves.Find(id);
        _context.Ves.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}