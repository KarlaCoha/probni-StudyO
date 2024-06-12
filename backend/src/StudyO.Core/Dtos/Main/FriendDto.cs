using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;

namespace StudyO.Core.Dtos.Main
{
    public record FriendDto
    {
        public Guid? Id { get; set; }
        public Guid UserId { get; set; }
        public Guid FriendId { get; set; }
        public string Status { get; set; }

        public static Friend ToModel(FriendDto friendtDto)
        {
            return new Friend
            {
                Id = friendtDto.Id ?? Guid.NewGuid(),
                UserId = friendtDto.UserId,
                FriendId = friendtDto.FriendId,
                Status = "Pending"
            };
        }

        public static FriendDto ToDto(Friend friend)
        {
            return new FriendDto
            {
                Id = friend.Id,
                UserId = friend.UserId,
                FriendId = friend.FriendId,
                Status = friend.Status,
            };
        }

    }
}
