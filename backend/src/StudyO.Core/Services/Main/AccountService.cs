using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Core.Dtos.Main;
using StudyO.Core.Infrastructure.Helpers;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main
{
    public class AccountService : IAccountService
    {
        private readonly IAccountRepository _accountRepository;
        public AccountService(IAccountRepository accountRepository)
        {
            _accountRepository = accountRepository;
        }

        public Task<bool> CheckUsernameAsync(string username)
        {
            return _accountRepository.CheckUsernameAsync(username);
        }

        public Task<User> ConfirmRegistrationAsync(User user)
        {
            return _accountRepository.ConfirmRegistrationAsync(user);
        }

        public Task DeleteUserAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        public async Task<UserDto> FindUserByEmailAsync(string email)
        {
           var user = await _accountRepository.FindUserByEmailAsync(email);
           if (user == null) return null;
              return UserDto.CreateDto(user);
        }

        public Task<UserDto> GetUserAsync()
        {
            throw new NotImplementedException();
        }

        public Task InsertUserAsync(UserDto userDto)
        {
            throw new NotImplementedException();
        }

        public async Task<bool> RegisterUserAsync(User user)
        {
           return await _accountRepository.RegisterUserAsync(user);
        }

        public async Task<UserDto> SignInUsersAsync(string email, string password)
        {
            var user = await _accountRepository.SignInUsersAsync(email, password);
            if (user == null) return null;
            return UserDto.CreateDto(user);
           
        }

        public async Task<bool> UpdateUserAsync(UserDto userDto)
        {
            var user =  UserDto.ToModel(userDto);
           return await _accountRepository.UpdateUserAsync(user);
        }

        public async Task<bool> VerifyPasswordAsync(string email, string password)
        {
            var user = await _accountRepository.FindUserByEmailAsync(email);
            if (user == null)
            {
                return false; 
            }

            var hashedPassword = PasswordHasher.HashPassword(password);
            return hashedPassword == user.Password;
        }
    }
}
