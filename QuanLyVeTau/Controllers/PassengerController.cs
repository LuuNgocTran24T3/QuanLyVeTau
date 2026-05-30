using Microsoft.AspNetCore.Mvc;
using QuanLyVeTau.Models;

public class PassengerController : Controller
{
    private readonly VeTauDbCaiTienContext _context;
    public PassengerController(VeTauDbCaiTienContext context)
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

        var data = _context.HanhKhaches.ToList();
        return View(data);
    }

    // CREATE - GET
    public IActionResult Create()
    {
        return View();
    }

    // CREATE - POST
    [HttpPost]
    public IActionResult Create(HanhKhach model)
    {
        _context.HanhKhaches.Add(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // EDIT - GET
    public IActionResult Edit(int id)
    {
        var data = _context.HanhKhaches.Find(id);
        return View(data);
    }

    // EDIT - POST
    [HttpPost]
    public IActionResult Edit(HanhKhach model)
    {
        _context.HanhKhaches.Update(model);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }

    // DELETE
    public IActionResult Delete(int id)
    {
        var data = _context.HanhKhaches.Find(id);
        _context.HanhKhaches.Remove(data);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
}