using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface ISchoolClassRepository 
	{
		Task<List<SchoolClass>> GetSchoolClassesPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetSchoolClassesCountAsync();
		
		Task<List<SchoolClass>> GetSchoolClassesAsync();

		Task<SchoolClass> GetSchoolClassAsync(int id); 

		Task InsertSchoolClassAsync(SchoolClass schoolClass); 

		Task UpdateSchoolClassAsync(SchoolClass schoolClass); 

		Task DeleteSchoolClassAsync(int id);
	}
}