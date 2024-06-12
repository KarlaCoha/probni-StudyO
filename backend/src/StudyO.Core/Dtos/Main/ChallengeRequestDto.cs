using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;

namespace StudyO.Core.Dtos.Main
{
    public class ChallengeRequestDto
    {

        public Guid? Id { get; set; }
        public Guid UserId { get; set; }
        public Guid ChallengedUserId { get; set; }
        public int LessonId { get; set; }
        public string? Status { get; set; } = "Pending";

        public static Challenge ToChallengeModel (ChallengeRequestDto challengeRequestDto) 
        {
            return new Challenge
            {
                Id = challengeRequestDto.Id ?? Guid.NewGuid(),
                SenderId = challengeRequestDto.UserId,
                ReceiverId = challengeRequestDto.ChallengedUserId,
                Status = challengeRequestDto.Status,
                LessonId = challengeRequestDto.LessonId
            };
        }

        public static ChallengeRequestDto ToChallengeRequestDto(Challenge challenge)
        {
            return new ChallengeRequestDto
            {
                Id = challenge.Id,
                UserId = challenge.SenderId,
                ChallengedUserId = challenge.ReceiverId,
                Status = challenge.Status,
            };
        }
    }
}
