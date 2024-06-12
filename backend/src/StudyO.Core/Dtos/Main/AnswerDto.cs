using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
    public record AnswerDto
    {
        [TableColumn("Answer id", nameof(AnswerId), true, true)]
        public int AnswerId { get; set; }
        public string? AnswerText { get; set; }
        public string? AnswerDescription { get; set; }
        public int? QuestionId { get; set; }
        public int? CorrectAnswer { get; set; }

        public static AnswerDto CreateDto(Answer answer)
        {
            return new AnswerDto
            {
                AnswerId = answer.Id,
                AnswerText = answer.AnswerText,
                AnswerDescription = answer.AnswerDescription,
                QuestionId = answer.QuestionId,
                CorrectAnswer = answer.CorrectAnswer
            };
        }

        public static Answer ToModel(AnswerDto answerDto)
        {
            return new Answer
            {
                Id = answerDto.AnswerId,
                AnswerText = answerDto.AnswerText,
                AnswerDescription = answerDto.AnswerDescription,
                QuestionId = answerDto.QuestionId,
                CorrectAnswer = answerDto.CorrectAnswer
            };
        }
    }
}
