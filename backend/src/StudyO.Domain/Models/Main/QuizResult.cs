using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Domain.Models.Main
{
    public class QuizResult
    {
        public Guid Id { get; set; }
        public Guid ChallengeId { get; set; }
        public int? SenderScore { get; set; }
        public int? ReceiverScore { get; set; }

        public Challenge Challenge { get; set; }
    }
}
