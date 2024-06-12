using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class SchoolClassService : ISchoolClassService
    {
        private readonly ISchoolClassRepository _schoolClassRepository;

        public SchoolClassService(ISchoolClassRepository schoolClassRepository)
        {
            _schoolClassRepository = schoolClassRepository;
        }

        public async Task<PagedListDto<SchoolClassDto>> GetSchoolClassesPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _schoolClassRepository.GetSchoolClassesCountAsync();
            var schoolClasses = await _schoolClassRepository.GetSchoolClassesPagedAsync(tableMetadata);
            var schoolClassDtos = new List<SchoolClassDto>();

            foreach (var schoolClass in schoolClasses)
            {
                schoolClassDtos.Add(SchoolClassDto.CreateDto(schoolClass));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<SchoolClassDto>() { Data = schoolClassDtos, Page = pagingMetadata };
        }

        public async Task<List<SchoolClassDto>> GetSchoolClassesAsync()
        {
            var schoolClasses = await _schoolClassRepository.GetSchoolClassesAsync();
            var schoolClassDtos = new List<SchoolClassDto>();
            foreach (var schoolClass in schoolClasses)
            {
                schoolClassDtos.Add(SchoolClassDto.CreateDto(schoolClass));
            }

            return schoolClassDtos;
        }

        public async Task<int> GetSchoolClassesCountAsync()
        {
            return await _schoolClassRepository.GetSchoolClassesCountAsync();
        }

        public async Task<SchoolClassDto> GetSchoolClassAsync(int id)
        {
            var schoolClass = await _schoolClassRepository.GetSchoolClassAsync(id);
            return SchoolClassDto.CreateDto(schoolClass);
        }

        public async Task InsertSchoolClassAsync(SchoolClassDto schoolClassDto)
        {
            await _schoolClassRepository.InsertSchoolClassAsync(SchoolClassDto.ToModel(schoolClassDto));
        }

        public async Task UpdateSchoolClassAsync(SchoolClassDto schoolClassDto)
        {
            await _schoolClassRepository.UpdateSchoolClassAsync(SchoolClassDto.ToModel(schoolClassDto));
        }

        public async Task DeleteSchoolClassAsync(int id)
        {
            await _schoolClassRepository.DeleteSchoolClassAsync(id);
        }
    }
}
