using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface IFriendsRepository
    {
        Task<List<Friend>> GetFriendsPagedAsync(TableMetadata? tableMetadata = null);

        Task<int> GetFriendsCountAsync();

        Task<Friend> GetActiveFriendRequestAsync(Guid userId, Guid friendId);
        Task<bool> RejectFriendRequest(Guid userId, Guid friendId);

        Task<List<Friend>> GetFriendsAsync();

        Task<Friend> GetFriendAsync(Guid id);

        Task<bool> InsertFriendAsync(Friend friend);

        Task<Friend> AcceptFriendRequestAsync(Friend friend);

        Task<bool> UpdateFriendAsync(Friend friend);

        Task DeleteFriendAsync(int id);
    }
}
