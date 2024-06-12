using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface IQuestionRepository 
	{
		Task<List<Question>> GetQuestionsPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetQuestionsCountAsync();
		
		Task<List<Question>> GetQuestionsAsync();

		Task<Question> GetQuestionAsync(int id); 

		Task InsertQuestionAsync(Question question); 

		Task<bool> UpdateQuestionAsync(Question question); 

		Task DeleteQuestionAsync(int id);
	}
}
