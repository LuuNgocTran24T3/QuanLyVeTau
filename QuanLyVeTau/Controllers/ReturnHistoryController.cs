using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;
public class ReturnHistoryController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public ReturnHistoryController(VeTauDbCaiTienContext context)
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

        var data = _context.LichSuDoiTras.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(LichSuDoiTra model)
    {
        _context.LichSuDoiTras.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.LichSuDoiTras.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(LichSuDoiTra model)
    {
        _context.LichSuDoiTras.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.LichSuDoiTras.Find(id);
        _context.LichSuDoiTras.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}