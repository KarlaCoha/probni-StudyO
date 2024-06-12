using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface ILessonService
    {
        Task<PagedListDto<LessonDto>> GetLessonsPagedAsync(TableMetadata? tableMetadata);

        Task<List<LessonDto>> GetLessonsAsync();

        Task<int> GetLessonsCountAsync();

        Task<LessonDto> GetLessonAsync(int id);

        Task InsertLessonAsync(LessonDto lessonDto);

        Task UpdateLessonAsync(LessonDto lessonDto);

        Task DeleteLessonAsync(int id);
    }
}
