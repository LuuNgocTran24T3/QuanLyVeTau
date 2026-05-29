using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class PriorityObjectController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public PriorityObjectController(VeTauDbCaiTienContext context)
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

        var data = _context.DoiTuongUuDais.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(DoiTuongUuDai model)
    {
        _context.DoiTuongUuDais.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.DoiTuongUuDais.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(DoiTuongUuDai model)
    {
        _context.DoiTuongUuDais.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.DoiTuongUuDais.Find(id);
        _context.DoiTuongUuDais.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}