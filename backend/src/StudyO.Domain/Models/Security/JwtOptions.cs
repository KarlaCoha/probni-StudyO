﻿namespace StudyO.Domain.Models.Security
{
    public class JwtOptions
    {
        public string? Issuer { get; set; }
        public string? Audience { get; set; }
        public string? SecretKey { get; set; }
        public string? Kid { get; set; }
        public int AccessTokenTTLMinutes { get; set; }
        public int RefreshTokenTTLDays { get; set; }
    }
}
