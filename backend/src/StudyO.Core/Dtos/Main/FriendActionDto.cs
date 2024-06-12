using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StudyO.Domain.Models.Main;

namespace StudyO.Core.Dtos.Main
{
    public class FriendActionDto
    {
        public Guid UserId { get; set; }
        public Guid FriendId { get; set; }


    }

   
}
