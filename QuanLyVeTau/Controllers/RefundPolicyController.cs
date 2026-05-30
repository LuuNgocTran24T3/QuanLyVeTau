using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class RefundPolicyController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public RefundPolicyController(VeTauDbCaiTienContext context)
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

        var data = _context.ChinhSachDoiTras.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(ChinhSachDoiTra model)
    {
        _context.ChinhSachDoiTras.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.ChinhSachDoiTras.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(ChinhSachDoiTra model)
    {
        _context.ChinhSachDoiTras.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.ChinhSachDoiTras.Find(id);
        _context.ChinhSachDoiTras.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}