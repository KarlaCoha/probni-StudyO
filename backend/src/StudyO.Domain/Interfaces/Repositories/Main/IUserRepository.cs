using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface IUserRepository 
	{
		Task<List<User>> GetUsersPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetUsersCountAsync();
		
		Task<List<User>> GetUsersAsync();

		Task<User> GetUserAsync(Guid id); 

		Task InsertUserAsync(User user);

        Task<bool> UpdateUserAsync(User user);
        Task<bool> InsertQuizzChallengeAsync(Challenge challenge);
        Task<Challenge> GetQuizzChallengesAsync(Challenge challenge);

        Task DeleteUserAsync(Guid id);
	}
}
