using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface IAnswerRepository 
	{
		Task<List<Answer>> GetAnswersPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetAnswersCountAsync();
		
		Task<List<Answer>> GetAnswersAsync();

		Task<Answer> GetAnswerAsync(int id); 

		Task InsertAnswerAsync(Answer answer);

        Task<List<Answer>> GetAnswerByQuestionIdAsync(int id);

        Task<bool> UpdateAnswerAsync(Answer answer); 

		Task DeleteAnswerAsync(int id);
	}
}
