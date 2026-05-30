using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class RefundController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public RefundController(VeTauDbCaiTienContext context)
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

        var data = _context.HoanTiens.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(HoanTien model)
    {
        _context.HoanTiens.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.HoanTiens.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(HoanTien model)
    {
        _context.HoanTiens.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.HoanTiens.Find(id);
        _context.HoanTiens.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}