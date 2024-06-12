using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class LessonService : ILessonService
    {
        private readonly ILessonRepository _lessonRepository;

        public LessonService(ILessonRepository lessonRepository)
        {
            _lessonRepository = lessonRepository;
        }

        public async Task<PagedListDto<LessonDto>> GetLessonsPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _lessonRepository.GetLessonsCountAsync();
            var lessons = await _lessonRepository.GetLessonsPagedAsync(tableMetadata);
            var lessonDtos = new List<LessonDto>();

            foreach (var lesson in lessons)
            {
                lessonDtos.Add(LessonDto.CreateDto(lesson));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<LessonDto>() { Data = lessonDtos, Page = pagingMetadata };
        }

        public async Task<List<LessonDto>> GetLessonsAsync()
        {
            var lessons = await _lessonRepository.GetLessonsAsync();
            var lessonDtos = new List<LessonDto>();
            foreach (var lesson in lessons)
            {
                lessonDtos.Add(LessonDto.CreateDto(lesson));
            }

            return lessonDtos;
        }

        public async Task<int> GetLessonsCountAsync()
        {
            return await _lessonRepository.GetLessonsCountAsync();
        }

        public async Task<LessonDto> GetLessonAsync(int id)
        {
            var lesson = await _lessonRepository.GetLessonAsync(id);
            return LessonDto.CreateDto(lesson);
        }

        public async Task InsertLessonAsync(LessonDto lessonDto)
        {
            await _lessonRepository.InsertLessonAsync(LessonDto.ToModel(lessonDto));
        }

        public async Task UpdateLessonAsync(LessonDto lessonDto)
        {
            await _lessonRepository.UpdateLessonAsync(LessonDto.ToModel(lessonDto));
        }

        public async Task DeleteLessonAsync(int id)
        {
            await _lessonRepository.DeleteLessonAsync(id);
        }
    }
}
