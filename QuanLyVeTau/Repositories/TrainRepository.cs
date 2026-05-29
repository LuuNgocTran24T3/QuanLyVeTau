using QuanLyVeTau.Models;
namespace QuanLyVeTau.Repositories 
{ 
    public class TrainRepository 
    { 
        private readonly VeTauDbCaiTienContext _context; 
        public TrainRepository(VeTauDbCaiTienContext context) 
        { 
            _context = context; 
        } 
        public List<Tau> GetAll() 
        { 
            return _context.Taus.ToList(); 
        } 
    } 
}