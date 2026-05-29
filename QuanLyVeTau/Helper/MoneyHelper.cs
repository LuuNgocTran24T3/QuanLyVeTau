namespace QuanLyVeTau.Helper
{ 
    public static class MoneyHelper 
    { 
        public static string FormatMoney(decimal money) 
        { 
            return string.Format("{0:N0} VNĐ", money); 
        } 
    } 
}
