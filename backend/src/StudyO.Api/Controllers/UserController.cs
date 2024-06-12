using Microsoft.AspNetCore.Mvc;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Core.Security.Attributes;
using Microsoft.AspNetCore.JsonPatch;
using StudyO.Core.Services.Main;
using Microsoft.Extensions.Caching.Memory;

namespace StudyO.Api.Controllers
{
    [Produces("application/json")]
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly NotificationService _notificationService;
        private readonly IMemoryCache _cache;

        public UserController(IUserService user, NotificationService notificationService, IMemoryCache cache)
        {
            _userService = user;
            _notificationService = notificationService;
            _cache = cache;
        }

        [HttpGet("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetUsersPaged([FromQuery] TableMetadata? tableMetadata)
        {
            var result = await _userService.GetUsersPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetUsers()
        {
            var result = await _userService.GetUsersAsync();
            return Ok(result);
        }


        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetUser([FromRoute] Guid id)
        {
            var result = await _userService.GetUserAsync(id);
            return Ok(result);
        }

        [HttpGet("points/{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetUserPoints([FromRoute] Guid id)
        {
            var user = await _userService.GetUserAsync(id);
            var userPointsDto = new UserPointsDto
            {
                UserId = user.UserId,
                Points = user.Points
            };  
            return Ok(userPointsDto);
        }

        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertUser([FromBody] UserDto userDto)
        {
            await _userService.InsertUserAsync(userDto);
            return Ok();
        }

        [HttpPatch("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateUser(Guid id, [FromBody] JsonPatchDocument<UserDto> patchDoc)
        {
            if (patchDoc == null)
            {
                return BadRequest();
            }

            var userDto = await _userService.GetUserAsync(id);
            if (userDto == null)
            {
                return NotFound();
            }

            patchDoc.ApplyTo(userDto);

            if (!TryValidateModel(userDto))
            {
                return BadRequest(ModelState);
            }

            var deviceTokenOperation = patchDoc.Operations.FirstOrDefault(op => op.path.Equals("/DeviceToken", StringComparison.OrdinalIgnoreCase));
            if (deviceTokenOperation != null)
            {
                var deviceToken = deviceTokenOperation.value?.ToString();
                if (!string.IsNullOrEmpty(deviceToken))
                {
                    var registerResult = await _notificationService.RegisterDeviceAsync(id, deviceToken);
                    if (!registerResult)
                    {
                        return StatusCode(StatusCodes.Status500InternalServerError, "Failed to register device");
                    }
                }
            }

            var result = await _userService.UpdateUserAsync(userDto);
            if (!result)
            {
                return BadRequest("User not updated");
            }

            return Ok();
        }

        [HttpPost("send-challenge")]
        public async Task<IActionResult> SendChallengeRequest([FromBody] ChallengeRequestDto challengeRDto)
        {
            var challengedUser = await _userService.GetUserAsync(challengeRDto.ChallengedUserId);
            if (challengedUser == null)
            {
                return NotFound(new { Message = "Challenged User not found" });
            }

            var user = await _userService.GetUserAsync(challengeRDto.UserId);
            if (user != null)
            {
                await _notificationService.SendNotificationAsync(challengedUser.DeviceToken, $"You have a new challenge request from {user.Username}!");
            }
            challengeRDto.Status = "Pending";
            var saveChallenge = await _userService.InsertQuizzChallengeAsync(challengeRDto);

            if (!saveChallenge)
            {
                return NotFound(new { Message = "Challenge not saved" });
            }


            return Ok(new
            {
                Message = "Challenge request sent successfully",
                ChallengeRequest = challengeRDto
            });
        }


        [HttpPost("accept-challenge")]
        public async Task<IActionResult> AcceptChallengeRequest([FromBody] ChallengeRequestDto challengeRDto)
        {
            var challengedUser = await _userService.GetUserAsync(challengeRDto.ChallengedUserId);
            if (challengedUser == null)
            {
                return NotFound(new { Message = "Challenged User not found" });
            }

            var user = await _userService.GetUserAsync(challengeRDto.UserId);
            if (user != null)
            {
                await _notificationService.SendNotificationAsync(user.DeviceToken, $"Your challenge request was accepted by {challengedUser.Username}!");
            }

            
            var challenge = await _userService.GetQuizzChallengesAsync(challengeRDto);

            if (challenge == null)
            {
                return NotFound(new { Message = "Challenge not found" });
            }

            challenge.Status = "Accepted";

            var updateChallengeStatus =  await _userService.InsertQuizzChallengeAsync(challenge);

            if (!updateChallengeStatus) return BadRequest("Problem updating challenge status");

            return Ok(new
            {
                Message = "Challenge request accepted successfully",
                ChallengeRequest = challenge
            });
        }


        [HttpPost("reject-challenge")]
        public async Task<IActionResult> RejectChallengeRequest([FromBody] ChallengeRequestDto challengeRDto)
        {
            var cacheKey = $"SendChallengeCacheKey_{challengeRDto.ChallengedUserId}_{challengeRDto.UserId}_{challengeRDto.LessonId}";

            if (!_cache.TryGetValue(cacheKey, out ChallengeRequestDto cachedRequest))
            {
                return NotFound(new { Message = "Challenge request not found in cache" });
            }

            var challengedUser = await _userService.GetUserAsync(challengeRDto.ChallengedUserId);
            if (challengedUser == null)
            {
                return NotFound(new { Message = "Challenged User not found" });
            }

            var user = await _userService.GetUserAsync(challengeRDto.UserId);
            if (user != null)
            {
                await _notificationService.SendNotificationAsync(challengedUser.DeviceToken, $"Your challenge request was rejected by {challengedUser.Username}!");
            }

            cachedRequest.Status = "Rejected";
            _cache.Remove(cacheKey);

            return Ok(new
            {
                Message = "Challenge request rejected successfully",
                ChallengeRequest = cachedRequest
            });
        }

        [HttpPost("get-challenge")]
        public async Task<IActionResult> GetChallengeRequest([FromBody] ChallengeRequestDto challengeRDto)
        {
            var challengedUser = await _userService.GetUserAsync(challengeRDto.ChallengedUserId);
            if (challengedUser == null)
            {
                return NotFound(new { Message = "Challenged User not found" });
            }

            var user = await _userService.GetUserAsync(challengeRDto.UserId);
            if (user != null)
            {
                return NotFound(new { Message = "User that challenges not found" });
            }

           var challenge = await _userService.GetQuizzChallengesAsync(challengeRDto);
           
            if (challenge == null) 
            {
               return NotFound(new { Message = "Challenge not found" });
            }

            return Ok(new
            {
                Message = "Challenge request accepted successfully",
                ChallengeRequest = challenge
            });
        }


        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteUser([FromRoute] Guid id)
        {
            await _userService.DeleteUserAsync(id);
            return Ok();
        }
    }
}
