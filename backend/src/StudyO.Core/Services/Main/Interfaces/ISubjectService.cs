using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface ISubjectService
    {
        Task<PagedListDto<SubjectDto>> GetSubjectsPagedAsync(TableMetadata? tableMetadata);

        Task<List<SubjectDto>> GetSubjectsAsync();

        Task<int> GetSubjectsCountAsync();

        Task<SubjectDto> GetSubjectAsync(int id);

        Task InsertSubjectAsync(SubjectDto subjectDto);

        Task UpdateSubjectAsync(SubjectDto subjectDto);

        Task DeleteSubjectAsync(int id);
    }
}