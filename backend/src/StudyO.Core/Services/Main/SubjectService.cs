using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class SubjectService : ISubjectService
    {
        private readonly ISubjectRepository _subjectRepository;

        public SubjectService(ISubjectRepository subjectRepository)
        {
            _subjectRepository = subjectRepository;
        }

        public async Task<PagedListDto<SubjectDto>> GetSubjectsPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _subjectRepository.GetSubjectsCountAsync();
            var subjects = await _subjectRepository.GetSubjectsPagedAsync(tableMetadata);
            var subjectDtos = new List<SubjectDto>();

            foreach (var subject in subjects)
            {
                subjectDtos.Add(SubjectDto.CreateDto(subject));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<SubjectDto>() { Data = subjectDtos, Page = pagingMetadata };
        }

        public async Task<List<SubjectDto>> GetSubjectsAsync()
        {
            var subjects = await _subjectRepository.GetSubjectsAsync();
            var subjectDtos = new List<SubjectDto>();
            foreach (var subject in subjects)
            {
                subjectDtos.Add(SubjectDto.CreateDto(subject));
            }

            return subjectDtos;
        }

        public async Task<int> GetSubjectsCountAsync()
        {
            return await _subjectRepository.GetSubjectsCountAsync();
        }

        public async Task<SubjectDto> GetSubjectAsync(int id)
        {
            var subject = await _subjectRepository.GetSubjectAsync(id);
            return SubjectDto.CreateDto(subject);
        }

        public async Task InsertSubjectAsync(SubjectDto subjectDto)
        {
            await _subjectRepository.InsertSubjectAsync(SubjectDto.ToModel(subjectDto));
        }

        public async Task UpdateSubjectAsync(SubjectDto subjectDto)
        {
            await _subjectRepository.UpdateSubjectAsync(SubjectDto.ToModel(subjectDto));
        }

        public async Task DeleteSubjectAsync(int id)
        {
            await _subjectRepository.DeleteSubjectAsync(id);
        }
    }
}
