using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
	public record SchoolClassDto
	{
		[TableColumn("School class id", nameof(SchoolClassId), true, true)]
public int SchoolClassId { get; set; }  
		public int? ClassNumber { get; set; }  

		public static SchoolClassDto CreateDto(SchoolClass schoolClass)
		{
			return new SchoolClassDto
			{
				SchoolClassId = schoolClass.Id,
				ClassNumber = schoolClass.ClassNumber
			};
		}

		public static SchoolClass ToModel(SchoolClassDto schoolClassDto)
		{
			return new SchoolClass
			{
				Id = schoolClassDto.SchoolClassId,
				ClassNumber = schoolClassDto.ClassNumber
			};
		}
	}
}