using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
	public record QuestionDto
	{
		[TableColumn("Question id", nameof(QuestionId), true, true)]
public int QuestionId { get; set; }  
		public string? QuestionText { get; set; }  
		public int? LessonId { get; set; }  

		public static QuestionDto CreateDto(Question question)
		{
			return new QuestionDto
			{
				QuestionId = question.Id,
				QuestionText = question.QuestionText,
				LessonId = question.LessonId
			};
		}

		public static Question ToModel(QuestionDto questionDto)
		{
			return new Question
			{
				Id = questionDto.QuestionId,
				QuestionText = questionDto.QuestionText,
				LessonId = questionDto.LessonId
			};
		}
	}
}