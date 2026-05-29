using System.ComponentModel.DataAnnotations;
namespace VeTauMVC.Validations 
{ 
    public class EmailValidation : ValidationAttribute 
    { 
        public override bool IsValid(object value) 
        { 
            if (value == null) 
                return false; 
            return value.ToString().Contains("@"); 
        } 
    } 
}