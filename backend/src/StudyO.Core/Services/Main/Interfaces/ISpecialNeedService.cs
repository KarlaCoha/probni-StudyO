using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface ISpecialNeedService
    {
        Task<PagedListDto<SpecialNeedDto>> GetSpecialNeedsPagedAsync(TableMetadata? tableMetadata);

        Task<List<SpecialNeedDto>> GetSpecialNeedsAsync();

        Task<int> GetSpecialNeedsCountAsync();

        Task<SpecialNeedDto> GetSpecialNeedAsync(int id);

        Task InsertSpecialNeedAsync(SpecialNeedDto specialNeedDto);

        Task UpdateSpecialNeedAsync(SpecialNeedDto specialNeedDto);

        Task DeleteSpecialNeedAsync(int id);
    }
}