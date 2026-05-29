using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class PaymentController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public PaymentController(VeTauDbCaiTienContext context)
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

        var data = _context.ThanhToans.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(ThanhToan model)
    {
        _context.ThanhToans.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.ThanhToans.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(ThanhToan model)
    {
        _context.ThanhToans.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.ThanhToans.Find(id);
        _context.ThanhToans.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}