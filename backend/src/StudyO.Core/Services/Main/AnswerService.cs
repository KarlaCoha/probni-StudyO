using StudyO.Core.Dtos.Main;
using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Utilities.Paging.Dtos;
using StudyO.Core.Services.Main.Interfaces;

namespace StudyO.Core.Services.Main
{
    public class AnswerService : IAnswerService
    {
        private readonly IAnswerRepository _answerRepository;

        public AnswerService(IAnswerRepository answerRepository)
        {
            _answerRepository = answerRepository;
        }

        public async Task<PagedListDto<AnswerDto>> GetAnswersPagedAsync(TableMetadata? tableMetadata)
        {
            var count = await _answerRepository.GetAnswersCountAsync();
            var answers = await _answerRepository.GetAnswersPagedAsync(tableMetadata);
            var answerDtos = new List<AnswerDto>();

            foreach (var answer in answers)
            {
                answerDtos.Add(AnswerDto.CreateDto(answer));
            }
            var pagingMetadata = new Page(count, tableMetadata.Page);

            return new PagedListDto<AnswerDto>() { Data = answerDtos, Page = pagingMetadata };
        }

        public async Task<List<AnswerDto>> GetAnswersAsync()
        {
            var answers = await _answerRepository.GetAnswersAsync();
            var answerDtos = new List<AnswerDto>();
            foreach (var answer in answers)
            {
                answerDtos.Add(AnswerDto.CreateDto(answer));
            }

            return answerDtos;
        }

        public async Task<int> GetAnswersCountAsync()
        {
            return await _answerRepository.GetAnswersCountAsync();
        }

        public async Task<AnswerDto> GetAnswerAsync(int id)
        {
            var answer = await _answerRepository.GetAnswerAsync(id);
            return AnswerDto.CreateDto(answer);
        }

        public async Task InsertAnswerAsync(AnswerDto answerDto)
        {
            await _answerRepository.InsertAnswerAsync(AnswerDto.ToModel(answerDto));
        }

        public async Task<bool> UpdateAnswerAsync(AnswerDto answerDto)
        {
            return await _answerRepository.UpdateAnswerAsync(AnswerDto.ToModel(answerDto));
        }

        public async Task DeleteAnswerAsync(int id)
        {
            await _answerRepository.DeleteAnswerAsync(id);
        }

        public async Task<List<AnswerDto>> GetAnswerByQuestionIdAsync(int id)
        {
            var answers = await _answerRepository.GetAnswerByQuestionIdAsync(id);
            if(answers == null)
            {
                return null;
            }
            var answerDtos = new List<AnswerDto>();
            foreach (var answer in answers)
            {
                answerDtos.Add(AnswerDto.CreateDto(answer));
            }
            return answerDtos;
        }
    }
}
