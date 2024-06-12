using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
	public record SubjectDto
	{
		[TableColumn("Subject id", nameof(SubjectId), true, true)]
public int SubjectId { get; set; }  
		public string? SubjectName { get; set; }  
		public int? Grade { get; set; }  
		public int? ClassId { get; set; }  

		public static SubjectDto CreateDto(Subject subject)
		{
			return new SubjectDto
			{
				SubjectId = subject.Id,
				SubjectName = subject.SubjectName,
				Grade = subject.Grade,
				ClassId = subject.ClassId
			};
		}

		public static Subject ToModel(SubjectDto subjectDto)
		{
			return new Subject
			{
				Id = subjectDto.SubjectId,
				SubjectName = subjectDto.SubjectName,
				Grade = subjectDto.Grade,
				ClassId = subjectDto.ClassId
			};
		}
	}
}