using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface IAccountRepository
    {
        Task<User> FindUserByEmailAsync(string email);
        Task<bool> CheckUsernameAsync(string userName);
        Task<User> GetUserAsync(Guid apiKey);
        Task<bool> RegisterUserAsync(User user);
        Task<User> SignInUsersAsync(string email, string password);
        Task<bool> UpdateUserAsync(User user);
        Task DeleteUserAsync(Guid id);
        Task InsertUserAsync(User user);
        Task<User> ConfirmRegistrationAsync(User user);
    }
}

