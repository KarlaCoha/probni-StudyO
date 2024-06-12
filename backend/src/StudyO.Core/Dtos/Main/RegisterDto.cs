using System.ComponentModel.DataAnnotations;
using StudyO.Domain.Models.Main;

namespace StudyO.Core.Dtos.Main
{
    public class RegisterDto
    {
        [Required]
        public string Name { get; set; }

        [Required]
        public string LastName { get; set; }
      
        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        // [RegularExpression("(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{4,8}$", ErrorMessage = "Password must be complex")]
        public string Password { get; set; }

        [Required]
        public string Username { get; set; }

        public string? DeviceToken { get; set; }

        public static User ToUser(RegisterDto registerDto, Guid apiKey)
        {
            return new User
            {
                Id = Guid.NewGuid(),
                FirstName = registerDto.Name,
                LastName = registerDto.LastName,
                Username = registerDto.Username,
                Email = registerDto.Email,
                Password = registerDto.Password,
                UserAuthentication = new UserAuthentication
                {
                    ApiKey = apiKey
                }
            };
        }


    }
}
