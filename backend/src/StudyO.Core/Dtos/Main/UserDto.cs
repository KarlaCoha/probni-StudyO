using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Attributes;

namespace StudyO.Core.Dtos.Main
{
	public record UserDto
	{
        [TableColumn("User id", nameof(UserId), true, false)]
        public Guid? UserId { get; set; }
        public string? FirstName { get; set; }  
		public string? LastName { get; set; }  
		public string? Gender { get; set; }  
		public string? DateOfBirth { get; set; }  
		public int? SchoolClassId { get; set; }  
		public int? SpecialNeedsId { get; set; }  
		public string? Username { get; set; }  
		public string? Password { get; set; }  
		public string? Email { get; set; }  
		public string? DeviceToken { get; set; }  
		public int? Points { get; set; }  
		public bool? IsRegistered { get; set; }  

		public static UserDto CreateDto(User user)
		{
			return new UserDto
			{
				UserId = user.Id,
				FirstName = user.FirstName,
				LastName = user.LastName,
				Gender = user.Gender,
				DateOfBirth = user.DateOfBirth,
				SchoolClassId = user.SchoolClassId,
				SpecialNeedsId = user.SpecialNeedsId,
				Username = user.Username,
				Password = user.Password,
                DeviceToken = user.UserAuthentication?.DeviceToken,
				Email = user.Email,
				Points = user.Points ?? 0,
                IsRegistered = user.UserAuthentication?.IsRegistered ?? false
			};
		}

		public static User ToModel(UserDto userDto)
		{
			return new User
			{
				Id = userDto.UserId ?? Guid.NewGuid(),
				FirstName = userDto.FirstName,
				LastName = userDto.LastName,
				Gender = userDto.Gender,
				DateOfBirth = userDto.DateOfBirth,
				SchoolClassId = userDto.SchoolClassId,
				SpecialNeedsId = userDto.SpecialNeedsId,
				Username = userDto.Username,
				Password = userDto.Password,
				Email = userDto.Email,
				Points = userDto.Points ?? 0,
                UserAuthentication = new UserAuthentication
                {
                    IsRegistered = userDto.IsRegistered,
                    DeviceToken = userDto.IsRegistered == true ? userDto.DeviceToken : null
                }
			};
		}
	}
}
