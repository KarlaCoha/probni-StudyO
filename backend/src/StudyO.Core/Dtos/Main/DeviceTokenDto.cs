using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Core.Dtos.Main
{
    public class DeviceTokenDto
    {
        public Guid UserId { get; set; }
        public string Token { get; set; } 
    }

}
