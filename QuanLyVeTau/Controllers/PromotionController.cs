using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class PromotionController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public PromotionController(VeTauDbCaiTienContext context)
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

        var data = _context.KhuyenMais.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(KhuyenMai model)
    {
        _context.KhuyenMais.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.KhuyenMais.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(KhuyenMai model)
    {
        _context.KhuyenMais.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.KhuyenMais.Find(id);
        _context.KhuyenMais.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}