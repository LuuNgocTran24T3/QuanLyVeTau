using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;
public class TrainCarController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public TrainCarController(VeTauDbCaiTienContext context)
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

        var data = _context.ToaTaus.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(ToaTau model)
    {
        _context.ToaTaus.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.ToaTaus.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(ToaTau model)
    {
        _context.ToaTaus.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.ToaTaus.Find(id);
        _context.ToaTaus.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}