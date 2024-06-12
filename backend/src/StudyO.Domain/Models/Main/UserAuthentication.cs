using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Domain.Models.Main
{
    public class UserAuthentication
    {
        public Guid? UserId { get; set; }
        public virtual User User { get; set; }
        public bool? IsRegistered { get; set; }
        public Guid? ApiKey { get; set; }
        public string? DeviceToken { get; set; }
    }
}
