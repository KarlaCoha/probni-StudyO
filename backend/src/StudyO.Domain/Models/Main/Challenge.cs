using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Domain.Models.Main
{
    public class Challenge
    {
        public Guid Id { get; set; }
        public Guid SenderId { get; set; }
        public Guid ReceiverId { get; set; }
        public string Status { get; set; }
        public int LessonId { get; set; }

        public User Sender { get; set; }
        public User Receiver { get; set; }

    }
}
