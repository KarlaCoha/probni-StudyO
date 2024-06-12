using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Core.Dtos.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface IAccountService
    {
        Task<bool> RegisterUserAsync(User user);

        Task<UserDto> SignInUsersAsync(string email, string password);

        Task<UserDto> GetUserAsync();
        Task<UserDto> FindUserByEmailAsync(string email); 
        Task<bool> CheckUsernameAsync(string username); 

        Task InsertUserAsync(UserDto userDto);

        Task<bool> UpdateUserAsync(UserDto userDto);

        Task DeleteUserAsync(Guid id);

        Task<bool> VerifyPasswordAsync(string email, string password);
        Task<User> ConfirmRegistrationAsync(User user);
    }
}
