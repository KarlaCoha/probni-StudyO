using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Repositories.Main
{
    public class UserRepository : IUserRepository 
	{
		private readonly ApplicationDbContext _context;
        public UserRepository(ApplicationDbContext context)
        {
            _context = context;
        }
		
		public async Task<List<User>> GetUsersPagedAsync(TableMetadata? tableMetadata)
		{
			var query = PagingHelper.CreateTableQuery(_context.Users, tableMetadata);
            return await query.ToListAsync();
		}

		public async Task<int> GetUsersCountAsync()
		{
			return await _context.Users.CountAsync();
		}

		public async Task<List<User>> GetUsersAsync()
		{
			return await _context.Users.Include(u => u.UserAuthentication).ToListAsync();
		}

		public async Task<User> GetUserAsync(Guid id)
		{
            return await _context.Users
                         .Include(u => u.UserAuthentication)
                         .FirstOrDefaultAsync(u => u.Id == id);
        }

		public async Task InsertUserAsync(User user)
		{
            _context.Users.Add(user);
			await _context.SaveChangesAsync();
		}

        public async Task<bool> UpdateUserAsync(User user)
        {
            var existingUser = await _context.Users
                .Include(u => u.UserSpecialNeeds)
                .Include(u => u.UserAuthentication)
                .Include(u => u.SchoolClass)
                .FirstOrDefaultAsync(u => u.Id == user.Id);

            if (existingUser != null)
            {
                _context.Entry(existingUser).CurrentValues.SetValues(user);

                if (user.SchoolClassId.HasValue)
                {
                    existingUser.SchoolClass = await _context.SchoolClasses.FindAsync(user.SchoolClassId.Value);
                }
                else
                {
                    existingUser.SchoolClass = null;
                }

                if (user.UserAuthentication != null)
                {
                    var existingAuth = await _context.UserAuthentications.FindAsync(user.UserAuthentication.UserId);
                    if (existingAuth != null)
                    {
                        _context.Entry(existingAuth).CurrentValues.SetValues(user.UserAuthentication);
                    }
                    else
                    {
                        existingUser.UserAuthentication = user.UserAuthentication;
                    }
                }
                else
                {
                    existingUser.UserAuthentication = null;
                }
               
                if (user.SpecialNeeds != null)
                {
                    existingUser.SpecialNeeds = await _context.SpecialNeeds.FindAsync(user.SpecialNeedsId.Value);
                }
                else
                {
                    existingUser.SpecialNeeds = null;
                }

                if (user.SpecialNeedsId == null)
                {
                    existingUser.UserSpecialNeeds.Clear();
                }
                else
                {
                    var existingSpecialNeedLink = existingUser.UserSpecialNeeds
                        .FirstOrDefault(usn => usn.SpecialNeedId == user.SpecialNeedsId);

                    if (existingSpecialNeedLink == null)
                    {
                        existingUser.UserSpecialNeeds.Add(new UserSpecialNeed
                        {
                            UserId = user.Id,
                            SpecialNeedId = user.SpecialNeedsId.Value
                        });
                    }
                }
                if (user.Friends != null) 
                {
                    var existingUserFriends = existingUser.Friends.ToList();
                    var userFriends = user.Friends.ToList();
                    if (existingUserFriends.Count > 0) 
                    {
                        foreach (var existingFriend in existingUserFriends)
                        {
                            if (!userFriends.Any(f => f.Id == existingFriend.Id))
                            {
                                existingUser.Friends.Remove(existingFriend);
                            }
                        }
                    }
                    foreach (var userFriend in userFriends)
                    {
                        if (!existingUserFriends.Any(f => f.Id == userFriend.Id))
                        {
                            existingUser.Friends.Add(userFriend);
                        }
                    }
                }
                
               return await _context.SaveChangesAsync() >0;
            }

            return false;
        }



        public async Task DeleteUserAsync(Guid id)
		{
			var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();
            }
		}

        public async Task<bool> InsertQuizzChallengeAsync(Challenge challenge)
        {
            if (challenge == null) return false;

            
            var existingChallenge = await _context.Challenges
                .AsNoTracking()
                .FirstOrDefaultAsync(c => c.Id == challenge.Id);

            if (existingChallenge == null)
            {
                _context.Challenges.Add(challenge);
            }
            else
            {
                _context.Attach(challenge);
                _context.Entry(challenge).State = EntityState.Modified;
            }

            return await _context.SaveChangesAsync() > 0;
        }


        public async Task<Challenge> GetQuizzChallengesAsync(Challenge challenge)
        {
            return await _context.Challenges.Where(u => u.SenderId == challenge.SenderId && u.ReceiverId == challenge.ReceiverId).AsNoTracking().FirstOrDefaultAsync();
        }
    }
}
