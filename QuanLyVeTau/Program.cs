using Microsoft.EntityFrameworkCore;
using QuanLyVeTau.Models;

var builder = WebApplication.CreateBuilder(args);

// MVC
builder.Services.AddControllersWithViews();

// SESSION
builder.Services.AddSession();

// DB CONTEXT
builder.Services.AddDbContext<VeTauDbCaiTienContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    ));

var app = builder.Build();

app.UseStaticFiles();

app.UseRouting();

app.UseSession();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}");

app.Run();