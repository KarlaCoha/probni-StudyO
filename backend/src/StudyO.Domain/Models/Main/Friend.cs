using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Domain.Models.Main
{
    public class Friend
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public Guid FriendId { get; set; }
        public string Status { get; set; }

        public virtual User User { get; set; }
        public virtual User FriendUsers { get; set; }
    }

}
