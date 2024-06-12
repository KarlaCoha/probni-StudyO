using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface ILessonRepository 
	{
		Task<List<Lesson>> GetLessonsPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetLessonsCountAsync();
		
		Task<List<Lesson>> GetLessonsAsync();

		Task<Lesson> GetLessonAsync(int id); 

		Task InsertLessonAsync(Lesson lesson); 

		Task UpdateLessonAsync(Lesson lesson); 

		Task DeleteLessonAsync(int id);
	}
}