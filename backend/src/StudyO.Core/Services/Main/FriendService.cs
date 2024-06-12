using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Core.Dtos.Main;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Core.Services.Main
{
    public class FriendService : IFriendService
    {
        private readonly IFriendsRepository _friendsRepository;
        public FriendService(IFriendsRepository friendsRepository)
        {
            _friendsRepository = friendsRepository;
        }

        public async Task<Friend> AcceptFriendRequestAsync(Friend friend)
        {
            return await _friendsRepository.AcceptFriendRequestAsync(friend);
        }

        public Task DeleteFriendAsync(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<Friend> GetActiveFriendRequestAsync(FriendActionDto friendActionDto)
        {
            return await _friendsRepository.GetActiveFriendRequestAsync(friendActionDto.UserId, friendActionDto.FriendId);
        }

        public async Task<FriendDto> GetFriendAsync(Guid id)
        {
            var friend = await _friendsRepository.GetFriendAsync(id);
            return FriendDto.ToDto(friend);
        }

        public Task<List<FriendDto>> GetFriendsAsync()
        {
            throw new NotImplementedException();
        }

        public Task<int> GetFriendsCountAsync()
        {
            throw new NotImplementedException();
        }

        public Task<PagedListDto<FriendDto>> GetFriendsPagedAsync(TableMetadata? tableMetadata)
        {
            throw new NotImplementedException();
        }

        public Task InsertFriendAsync(FriendDto FriendDto)
        {
            throw new NotImplementedException();
        }

        public async Task<bool> InsertFriendAsync(Friend friend)
        {
            return await _friendsRepository.InsertFriendAsync(friend);
        }

        public async  Task<bool> RejectFriendRequest(FriendActionDto friendActionDto)
        {
            return await _friendsRepository.RejectFriendRequest(friendActionDto.UserId, friendActionDto.FriendId);
        }


        public Task<bool> UpdateFriendAsync(FriendDto friend)
        {
            throw new NotImplementedException();
        }

    }
}
