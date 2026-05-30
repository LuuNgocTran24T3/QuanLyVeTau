using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class ScheduleController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public ScheduleController(VeTauDbCaiTienContext context)
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

        var data = _context.LichDungs.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(LichDung model)
    {
        _context.LichDungs.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.LichDungs.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(LichDung model)
    {
        _context.LichDungs.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.LichDungs.Find(id);
        _context.LichDungs.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}