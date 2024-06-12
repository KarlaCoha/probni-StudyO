using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;

namespace StudyO.Core.Services.Main.Interfaces
{
    public interface IQuestionService
    {
        Task<PagedListDto<QuestionDto>> GetQuestionsPagedAsync(TableMetadata? tableMetadata);

        Task<List<QuestionDto>> GetQuestionsAsync();

        Task<int> GetQuestionsCountAsync();

        Task<QuestionDto> GetQuestionAsync(int id);

        Task InsertQuestionAsync(QuestionDto questionDto);

        Task<bool> UpdateQuestionAsync(QuestionDto questionDto);

        Task DeleteQuestionAsync(int id);
    }
}
