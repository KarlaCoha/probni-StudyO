namespace StudyO.Domain.Interfaces.Jwt.Interfaces
{
    public interface IJwtUtils
    {
        public string GenerateJwtToken(string userAccountId);
        public int? ValidateJwtToken(string token);
        public string GenerateRefreshToken(string userAccountId);
    }
}
