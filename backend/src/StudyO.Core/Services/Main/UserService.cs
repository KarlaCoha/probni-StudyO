using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<PagedListDto<UserDto>> GetUsersPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _userRepository.GetUsersCountAsync();
            var users = await _userRepository.GetUsersPagedAsync(tableMetadata);
            var userDtos = new List<UserDto>();

            foreach (var user in users)
            {
                userDtos.Add(UserDto.CreateDto(user));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<UserDto>() { Data = userDtos, Page = pagingMetadata };
        }

        public async Task<List<UserDto>> GetUsersAsync()
        {
            var users = await _userRepository.GetUsersAsync();
            var userDtos = new List<UserDto>();
            foreach (var user in users)
            {
                userDtos.Add(UserDto.CreateDto(user));
            }

            return userDtos;
        }

        public async Task<int> GetUsersCountAsync()
        {
            return await _userRepository.GetUsersCountAsync();
        }

        public async Task<UserDto> GetUserAsync(Guid id)
        {
            var user = await _userRepository.GetUserAsync(id);
            return UserDto.CreateDto(user);
        }

        public async Task InsertUserAsync(UserDto userDto)
        {
            await _userRepository.InsertUserAsync(UserDto.ToModel(userDto));
        }

        public async Task<bool> UpdateUserAsync(UserDto userDto)
        {
           return await _userRepository.UpdateUserAsync(UserDto.ToModel(userDto));
        }

        public async Task DeleteUserAsync(Guid id)
        {
            await _userRepository.DeleteUserAsync(id);
        }

        public async Task<bool> InsertQuizzChallengeAsync(ChallengeRequestDto challengeRequestDto)
        {
            return await _userRepository.InsertQuizzChallengeAsync(ChallengeRequestDto.ToChallengeModel(challengeRequestDto));
        }

        public async Task<ChallengeRequestDto> GetQuizzChallengesAsync(ChallengeRequestDto challengeRequestDto)
        {
            var challenge = await _userRepository.GetQuizzChallengesAsync(ChallengeRequestDto.ToChallengeModel(challengeRequestDto));
           return ChallengeRequestDto.ToChallengeRequestDto(challenge);
        }
    }
}
