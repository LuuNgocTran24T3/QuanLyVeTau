using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;
public class TrainController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public TrainController(VeTauDbCaiTienContext context)
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

        var data = _context.Taus.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(Tau model)
    {
        _context.Taus.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.Taus.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(Tau model)
    {
        _context.Taus.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.Taus.Find(id);
        _context.Taus.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}