using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using System.Threading.Tasks;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface IUserService
    {
        Task<PagedListDto<UserDto>> GetUsersPagedAsync(TableMetadata? tableMetadata);

        Task<List<UserDto>> GetUsersAsync();

        Task<int> GetUsersCountAsync();

        Task<UserDto> GetUserAsync(Guid id);

        Task InsertUserAsync(UserDto userDto);
        Task<bool> InsertQuizzChallengeAsync(ChallengeRequestDto challengeRequestDto);
        Task<ChallengeRequestDto> GetQuizzChallengesAsync(ChallengeRequestDto challengeRequestDto);

        Task<bool> UpdateUserAsync(UserDto userDto);

        Task DeleteUserAsync(Guid id);
    }
}
