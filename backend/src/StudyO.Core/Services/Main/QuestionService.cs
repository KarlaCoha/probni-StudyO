using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class QuestionService : IQuestionService
    {
        private readonly IQuestionRepository _questionRepository;

        public QuestionService(IQuestionRepository questionRepository)
        {
            _questionRepository = questionRepository;
        }

        public async Task<PagedListDto<QuestionDto>> GetQuestionsPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _questionRepository.GetQuestionsCountAsync();
            var questions = await _questionRepository.GetQuestionsPagedAsync(tableMetadata);
            var questionDtos = new List<QuestionDto>();

            foreach (var question in questions)
            {
                questionDtos.Add(QuestionDto.CreateDto(question));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<QuestionDto>() { Data = questionDtos, Page = pagingMetadata };
        }

        public async Task<List<QuestionDto>> GetQuestionsAsync()
        {
            var questions = await _questionRepository.GetQuestionsAsync();
            var questionDtos = new List<QuestionDto>();
            foreach (var question in questions)
            {
                questionDtos.Add(QuestionDto.CreateDto(question));
            }

            return questionDtos;
        }

        public async Task<int> GetQuestionsCountAsync()
        {
            return await _questionRepository.GetQuestionsCountAsync();
        }

        public async Task<QuestionDto> GetQuestionAsync(int id)
        {
            var question = await _questionRepository.GetQuestionAsync(id);
            return QuestionDto.CreateDto(question);
        }

        public async Task InsertQuestionAsync(QuestionDto questionDto)
        {
            await _questionRepository.InsertQuestionAsync(QuestionDto.ToModel(questionDto));
        }

        public async Task<bool> UpdateQuestionAsync(QuestionDto questionDto)
        {
           return await _questionRepository.UpdateQuestionAsync(QuestionDto.ToModel(questionDto));
        }

        public async Task DeleteQuestionAsync(int id)
        {
            await _questionRepository.DeleteQuestionAsync(id);
        }
    }
}
