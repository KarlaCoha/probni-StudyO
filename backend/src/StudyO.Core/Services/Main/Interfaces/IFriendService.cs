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
    public interface IFriendService
    {
        Task<PagedListDto<FriendDto>> GetFriendsPagedAsync(TableMetadata? tableMetadata);

        Task<List<FriendDto>> GetFriendsAsync();

        Task<int> GetFriendsCountAsync();

        Task<FriendDto> GetFriendAsync(Guid id);

        Task<bool> InsertFriendAsync(Friend friend);

        Task<Friend> AcceptFriendRequestAsync(Friend friend);

        Task<bool> UpdateFriendAsync(FriendDto friendDto);
        Task<Friend> GetActiveFriendRequestAsync(FriendActionDto friendActionDto);
        Task<bool> RejectFriendRequest(FriendActionDto friendActionDto);

        Task DeleteFriendAsync(int id);
    }
}
