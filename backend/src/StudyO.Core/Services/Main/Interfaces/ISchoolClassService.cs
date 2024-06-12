using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface ISchoolClassService
    {
        Task<PagedListDto<SchoolClassDto>> GetSchoolClassesPagedAsync(TableMetadata? tableMetadata);

        Task<List<SchoolClassDto>> GetSchoolClassesAsync();

        Task<int> GetSchoolClassesCountAsync();

        Task<SchoolClassDto> GetSchoolClassAsync(int id);

        Task InsertSchoolClassAsync(SchoolClassDto schoolClassDto);

        Task UpdateSchoolClassAsync(SchoolClassDto schoolClassDto);

        Task DeleteSchoolClassAsync(int id);
    }
}