using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface IAnswerService
    {
        Task<PagedListDto<AnswerDto>> GetAnswersPagedAsync(TableMetadata? tableMetadata);

        Task<List<AnswerDto>> GetAnswersAsync();

        Task<int> GetAnswersCountAsync();

        Task<AnswerDto> GetAnswerAsync(int id);
        Task<List<AnswerDto>> GetAnswerByQuestionIdAsync(int id);

        Task InsertAnswerAsync(AnswerDto answerDto);

        Task<bool> UpdateAnswerAsync(AnswerDto answerDto);

        Task DeleteAnswerAsync(int id);
    }
}
