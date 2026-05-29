namespace QuanLyVeTau.Extensions
{ 
    public static class StringExtension 
    { 
        public static string ToUpperFirst(this string text) 
        { 
            if (string.IsNullOrEmpty(text)) 
                return text; 
            return char.ToUpper(text[0]) + text.Substring(1); 
        } 
    } 
}
