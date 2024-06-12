using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Persistence.Main
{
    public class AccountRepository : IAccountRepository
    {
        private readonly ApplicationDbContext _context;
       
        public AccountRepository(ApplicationDbContext context) 
        {
            _context = context;
        }

        public Task<bool> CheckUsernameAsync(string userName)
        {
            return _context.Users.AnyAsync(x => x.Username == userName);
        }

        public async Task<User> ConfirmRegistrationAsync(User user)
        {
             _context.UserAuthentications.FirstOrDefault(x => x.User == user).IsRegistered = true;
            var updatedUser = await _context.Users.Include(us => us.UserAuthentication).FirstOrDefaultAsync(u => u.Id == user.Id);
            var result =  await _context.SaveChangesAsync() > 0;
            if (!result && updatedUser == null) return null;
            return updatedUser;
          
        }

        public Task DeleteUserAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        public async Task<User> FindUserByEmailAsync(string email)
        {
            var user = await _context.Users.Include(u => u.UserAuthentication).FirstOrDefaultAsync(x => x.Email == email);
            if (user == null) return null;
            return user;
        }

        public async Task<User> GetUserAsync(Guid apiKey)
        {
            var userAuthentication = await _context.UserAuthentications.FirstOrDefaultAsync(x => x.ApiKey == apiKey);

            if (userAuthentication == null || userAuthentication.User == null)
            {
                return null;
            }

            return userAuthentication.User;
        }


        public Task InsertUserAsync(User user)
        {
            throw new NotImplementedException();
        }

        public async Task<bool> RegisterUserAsync(User user)
        {

            _context.Users.Add(user);
            _context.UserAuthentications.Add(user.UserAuthentication);
            var result = await _context.SaveChangesAsync() > 0;

            if(!result) return false;

            return true;
        }

        public async Task<User> SignInUsersAsync(string email, string password)
        {
            var signedInUser = await _context.Users.Include(u => u.UserAuthentication).FirstOrDefaultAsync(x => x.Email == email);
            if (signedInUser == null) return null;
            return signedInUser;
        }

        public async Task<bool> UpdateUserAsync(User user)
        {
            _context.Entry(user).State = EntityState.Modified;
            if (user.SchoolClass != null)
            {
                _context.Entry(user.SchoolClass).State = EntityState.Modified;
            }

            if (user.UserAuthentication != null)
            {
                _context.Entry(user.UserAuthentication).State = EntityState.Modified;
            }

            if (user.UserSpecialNeeds != null)
            {
                _context.Entry(user.UserSpecialNeeds).State = EntityState.Modified;
            }
            var success = await _context.SaveChangesAsync() > 0;
            if (!success) return false;
            return success;
        }
    }
}
