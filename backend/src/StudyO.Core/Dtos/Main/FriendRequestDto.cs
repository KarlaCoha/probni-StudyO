using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;

namespace StudyO.Core.Dtos.Main
{
    public class FriendRequestDto
    {
        public Guid UserId { get; set; }
        public Guid FriendId { get; set; }

        public static Friend ToModel(FriendRequestDto friendRequestDto)
        {
            return new Friend
            {
                Id = Guid.NewGuid(),
                UserId = friendRequestDto.UserId,
                FriendId = friendRequestDto.FriendId,
                Status = "Pending"
            };
        }
    }
}
