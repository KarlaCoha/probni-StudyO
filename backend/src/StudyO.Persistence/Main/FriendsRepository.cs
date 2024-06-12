using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Persistence.Main
{
    internal class FriendsRepository : IFriendsRepository
    {
        private readonly ApplicationDbContext _context;

        public FriendsRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public Task DeleteFriendAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<Friend> GetActiveFriendRequestAsync(Guid userId, Guid friendId)
        {
             var friendRequest = await _context.Friends
                .FirstOrDefaultAsync(f => f.UserId == userId && f.FriendId == friendId && f.Status == "Pending");

            if (friendRequest == null)
            {
                return null;
            }

            return friendRequest;
        }

        public async Task<Friend> GetFriendAsync(Guid id)
        {
           return _context.Friends.FirstOrDefaultAsync(f => f.Id == id).Result;
        }

        public Task<List<Friend>> GetFriendsAsync()
        {
            throw new NotImplementedException();
        }

        public Task<int> GetFriendsCountAsync()
        {
            throw new NotImplementedException();
        }

        public Task<List<Friend>> GetFriendsPagedAsync(TableMetadata? tableMetadata = null)
        {
            throw new NotImplementedException();
        }

        public async Task<bool> InsertFriendAsync(Friend friend)
        {
           await _context.Friends.AddAsync(friend);

           return await _context.SaveChangesAsync() > 0;

        }

        public async Task<Friend> AcceptFriendRequestAsync(Friend friend)
        {
            var friendRequest = await _context.Friends
              .FirstOrDefaultAsync(f => f.UserId == friend.UserId && f.FriendId == friend.FriendId && f.Status == "Pending");

            if (friendRequest == null)
            {
                return null;
            }

            friendRequest.Status = "Accepted";
            await _context.SaveChangesAsync();

            return friendRequest;
        }

        public async Task<bool> RejectFriendRequest(Guid userId, Guid friendId)
        {
            var friendRequest = await _context.Friends
                 .FirstOrDefaultAsync(f => f.UserId == userId && f.FriendId == friendId && f.Status == "Pending");

            if (friendRequest == null)
            {
                return false;
            }

            _context.Friends.Remove(friendRequest);
            await _context.SaveChangesAsync();

            return true;
        }

        public Task<bool> UpdateFriendAsync(Friend friend)
        {
            throw new NotImplementedException();
        }

    }
}
