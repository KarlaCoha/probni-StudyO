using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudyO.Core.Dtos.Main
{
    public record VerifyEmailDto
    {
        public string Email { get; set; }
        public string Code { get; set; }
        public string? DeviceToken { get; set; }
    }
}
