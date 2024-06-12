using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface ISubjectRepository 
	{
		Task<List<Subject>> GetSubjectsPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetSubjectsCountAsync();
		
		Task<List<Subject>> GetSubjectsAsync();

		Task<Subject> GetSubjectAsync(int id); 

		Task InsertSubjectAsync(Subject subject); 

		Task UpdateSubjectAsync(Subject subject); 

		Task DeleteSubjectAsync(int id);
	}
}