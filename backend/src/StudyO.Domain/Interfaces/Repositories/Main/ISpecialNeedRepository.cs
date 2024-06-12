using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;

namespace StudyO.Domain.Interfaces.Repositories.Main
{
    public interface ISpecialNeedRepository 
	{
		Task<List<SpecialNeed>> GetSpecialNeedsPagedAsync(TableMetadata? tableMetadata = null); 

		Task<int> GetSpecialNeedsCountAsync();
		
		Task<List<SpecialNeed>> GetSpecialNeedsAsync();

		Task<SpecialNeed> GetSpecialNeedAsync(int id); 

		Task InsertSpecialNeedAsync(SpecialNeed specialNeed); 

		Task UpdateSpecialNeedAsync(SpecialNeed specialNeed); 

		Task DeleteSpecialNeedAsync(int id);
	}
}