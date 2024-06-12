using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class SpecialNeedService : ISpecialNeedService
    {
        private readonly ISpecialNeedRepository _specialNeedRepository;

        public SpecialNeedService(ISpecialNeedRepository specialNeedRepository)
        {
            _specialNeedRepository = specialNeedRepository;
        }

        public async Task<PagedListDto<SpecialNeedDto>> GetSpecialNeedsPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _specialNeedRepository.GetSpecialNeedsCountAsync();
            var specialNeeds = await _specialNeedRepository.GetSpecialNeedsPagedAsync(tableMetadata);
            var specialNeedDtos = new List<SpecialNeedDto>();

            foreach (var specialNeed in specialNeeds)
            {
                specialNeedDtos.Add(SpecialNeedDto.CreateDto(specialNeed));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<SpecialNeedDto>() { Data = specialNeedDtos, Page = pagingMetadata };
        }

        public async Task<List<SpecialNeedDto>> GetSpecialNeedsAsync()
        {
            var specialNeeds = await _specialNeedRepository.GetSpecialNeedsAsync();
            var specialNeedDtos = new List<SpecialNeedDto>();
            foreach (var specialNeed in specialNeeds)
            {
                specialNeedDtos.Add(SpecialNeedDto.CreateDto(specialNeed));
            }

            return specialNeedDtos;
        }

        public async Task<int> GetSpecialNeedsCountAsync()
        {
            return await _specialNeedRepository.GetSpecialNeedsCountAsync();
        }

        public async Task<SpecialNeedDto> GetSpecialNeedAsync(int id)
        {
            var specialNeed = await _specialNeedRepository.GetSpecialNeedAsync(id);
            return SpecialNeedDto.CreateDto(specialNeed);
        }

        public async Task InsertSpecialNeedAsync(SpecialNeedDto specialNeedDto)
        {
            await _specialNeedRepository.InsertSpecialNeedAsync(SpecialNeedDto.ToModel(specialNeedDto));
        }

        public async Task UpdateSpecialNeedAsync(SpecialNeedDto specialNeedDto)
        {
            await _specialNeedRepository.UpdateSpecialNeedAsync(SpecialNeedDto.ToModel(specialNeedDto));
        }

        public async Task DeleteSpecialNeedAsync(int id)
        {
            await _specialNeedRepository.DeleteSpecialNeedAsync(id);
        }
    }
}
