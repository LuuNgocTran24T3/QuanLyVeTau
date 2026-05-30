using QuanLyVeTau.Models;
namespace QuanLyVeTau.Business 
{ 
    public class BookingBusiness 
    { 
        public bool CheckSeatBooked(bool booked) 
        { 
            return !booked; 
        } 

        public decimal CalculateTotal(decimal price, int quantity) 
        { 
            return price * quantity; 
        } 
        
        public decimal Discount(decimal total, decimal percent) 
        { 
            return total - (total * percent / 100); 
        } 
        public bool CheckDuplicateSeat(int seatId, int tripId, List<GiuCho> bookings) 
        { 
            return bookings.Any(x => x.GheId == seatId && x.ChuyenTauId == tripId); 
        }
    }
}