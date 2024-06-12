using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
	public record SpecialNeedDto
	{
		[TableColumn("Special need id", nameof(SpecialNeedId), true, true)]
public int SpecialNeedId { get; set; }  
		public string? Name { get; set; }  

		public static SpecialNeedDto CreateDto(SpecialNeed specialNeed)
		{
			return new SpecialNeedDto
			{
				SpecialNeedId = specialNeed.Id,
				Name = specialNeed.Name
			};
		}

		public static SpecialNeed ToModel(SpecialNeedDto specialNeedDto)
		{
			return new SpecialNeed
			{
				Id = specialNeedDto.SpecialNeedId,
				Name = specialNeedDto.Name
			};
		}
	}
}