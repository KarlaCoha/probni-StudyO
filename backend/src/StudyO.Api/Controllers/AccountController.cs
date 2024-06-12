using Azure.Core;
using Azure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;
using static System.Net.Mime.MediaTypeNames;
using StudyO.Core.Dtos.Main;
using System.Text;
using StudyO.Core.Infrastructure.EmailService;
using StudyO.Domain.Models.Main;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Infrastructure.Helpers;
using System.Security.Claims;
using System.Net.Http;
using Microsoft.AspNetCore.Http;
using Amazon.Runtime.Internal.Util;
using Microsoft.Extensions.Caching.Memory;
using System.Security.Cryptography;
using static Microsoft.ApplicationInsights.MetricDimensionNames.TelemetryContext;

namespace StudyO.Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AccountController : ControllerBase
    {
        
        private readonly IConfiguration _config;
        private readonly HttpClient _httpClient;
        private readonly EmailSender _emailSender;
        private readonly IAccountService _accountService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IMemoryCache _cache;

        public AccountController(
            IConfiguration config, EmailSender emailSender, IAccountService accountService, IHttpContextAccessor httpContextAccessor, IMemoryCache cache)
        {
            _emailSender = emailSender;
            _config = config;
            _httpClient = new HttpClient
            {
                BaseAddress = new System.Uri("https://localhost:7068")
            };
            _accountService = accountService;
            _httpContextAccessor = httpContextAccessor;
            _cache = cache;
        }


        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<ActionResult<UserDto>> Login(LoginDto loginDto)
        {
            var checkPassword =  await _accountService.VerifyPasswordAsync(loginDto.Email, loginDto.Password);
            if (!checkPassword) return Unauthorized("Invalid username or password");
           
            var user = await _accountService.SignInUsersAsync(loginDto.Email,loginDto.Password);

            if (user.IsRegistered == null || !user.IsRegistered.Value)
            {
                return Unauthorized("Email not confirmed");
            }


            return user;
            
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ActionResult<Domain.Models.Main.User>> Register(RegisterDto registerDto)
        {
            var checkEmail = await _accountService.FindUserByEmailAsync(registerDto.Email);

            if (checkEmail != null)
            {
                ModelState.AddModelError("email", "Email taken");
                return ValidationProblem();
            }

            var checkUserName = await _accountService.CheckUsernameAsync(registerDto.Username);

            if (checkUserName)
            {
                ModelState.AddModelError("username", "Username taken");
                return ValidationProblem();
            }

            registerDto.Password = PasswordHasher.HashPassword(registerDto.Password);

            var apiKey = Guid.NewGuid();

            var user = RegisterDto.ToUser(registerDto,apiKey);

            var verificationCode = GenerateVerificationCode();
            _cache.Set(user.Email, verificationCode, TimeSpan.FromHours(1));

            var claims = new ClaimsIdentity(new[]
               {
                    new Claim(ClaimTypes.Email, registerDto.Email),
                    new Claim("XApiKeyUser", apiKey.ToString()) 
                });
           

            var isMailSend = SendMail(user.Email, verificationCode);

            if (!await isMailSend) return BadRequest("Problem sending email for verification");

            var saveuser = await _accountService.RegisterUserAsync(user);
            if(!saveuser) return BadRequest("Problem registering user");

            return Ok("Check your email for verification codel");
        }

        [AllowAnonymous]
        [HttpPost("verifyEmail")]
        public async Task<IActionResult> VerifyEmail(VerifyEmailDto verifyEmailDto)
        {
            if (!_cache.TryGetValue(verifyEmailDto.Email, out string cachedCode) || cachedCode != verifyEmailDto.Code)
            {
                return BadRequest("Invalid or expired verification code");
            }

            var userDto = await _accountService.FindUserByEmailAsync(verifyEmailDto.Email);
            if (userDto == null) return Unauthorized();
            
            userDto.DeviceToken = verifyEmailDto.DeviceToken;
            var user = UserDto.ToModel(userDto);
            var result = await _accountService.ConfirmRegistrationAsync(user);

            if (result == null)
            {
                return BadRequest("Problem confirming registration");
            }

            _cache.Remove(verifyEmailDto.Email);

            return Ok("Email confirmed - you can now login");
        }

        [AllowAnonymous]
        [HttpGet("resendEmailConfirmationCode")]
        public async Task<IActionResult> ResendEmailConfirmationCode(string email)
        {
            var userDto = await _accountService.FindUserByEmailAsync(email);
            if (userDto == null) return Unauthorized();

            var verificationCode = GenerateVerificationCode();
            _cache.Set(userDto.Email, verificationCode, TimeSpan.FromHours(1));

            var isMailSend = await SendMail(userDto.Email, verificationCode);
            if (!isMailSend) return BadRequest("Problem sending email for verification");

            return Ok("Email verification code resent");
        }


        [Authorize]
        [HttpGet("current-user")]
        public async Task<ActionResult<UserDto>> GetCurrentUser()
        {
            var userEmail = User.FindFirstValue(ClaimTypes.Email);
            var user = await _accountService.FindUserByEmailAsync(userEmail);
            if (user == null)
            {
                return Unauthorized();
            }

            return Ok(user);
        }

        private string GenerateVerificationCode()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, 6)
              .Select(s => s[RandomNumberGenerator.GetInt32(s.Length)]).ToArray());
        }

        private async Task<bool> SendMail(string email, string verificationCode)
        {
            var message = $"<p>Your verification code is: <strong>{verificationCode}</strong></p>";

            var isMailSend = _emailSender.SendEmailAsync(email, "Please copy the code", message);
            return isMailSend;
        }


    }
}
