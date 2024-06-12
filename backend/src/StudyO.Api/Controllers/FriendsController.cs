using Amazon.Runtime.Internal.Util;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using StudyO.Core.Dtos.Main;
using StudyO.Core.Services.Main;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using static Microsoft.ApplicationInsights.MetricDimensionNames.TelemetryContext;

namespace StudyO.Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class FriendsController : ControllerBase
    {
        private readonly NotificationService _notificationService;
        private readonly IFriendService _friendService;
        private readonly IUserService _userService;
        private readonly IMemoryCache _cache;

        public FriendsController(NotificationService notificationService, IFriendService friendService, IMemoryCache cache, IUserService userService)
        {
            _notificationService = notificationService;
            _friendService = friendService;
            _cache = cache;
            _userService = userService;
        }


        [HttpPost("send-request")]
        public async Task<IActionResult> SendFriendRequest([FromBody] FriendRequestDto requestDto)
        {
            var friendRequest = new Friend
            {
                Id = Guid.NewGuid(),
                UserId = requestDto.UserId,
                FriendId = requestDto.FriendId,
                Status = "Pending"
            };

            var result = await _friendService.InsertFriendAsync(friendRequest);
            if (!result)
            {
                return NotFound(new { Message = "Friend request not saved" });
            }

            var user = await _userService.GetUserAsync(friendRequest.UserId);
            if (user != null)
            {
                await _notificationService.SendNotificationAsync(user.DeviceToken, "You have a new friend request!");
            }

            return Ok(new { Message = "Friend request sent successfully" });
        }

        [HttpPost("accept-request")]
        public async Task<IActionResult> AcceptFriendRequest([FromBody] FriendActionDto friendActionDto)
        {
            var friendRequest = await _friendService.GetActiveFriendRequestAsync(friendActionDto);

            if (friendRequest == null)
            {
                return NotFound(new { Message = "Friend request not found" });
            }

            var friendRequestAccepted = await _friendService.AcceptFriendRequestAsync(friendRequest);

            if (friendRequestAccepted == null)
            {
                return NotFound(new { Message = "Friend request not accepted" });
            }

         

            return Ok(new { Message = "Friend request accepted" });
        }

        [HttpPost("reject-request")]
        public async Task<IActionResult> RejectFriendRequest([FromBody] FriendActionDto friendActionDto)
        {
            var friendRequest = await _friendService.GetActiveFriendRequestAsync(friendActionDto);

            if (friendRequest == null)
            {
                return NotFound(new { Message = "Friend request not found" });
            }

           var rejectFriendRequest = await _friendService.RejectFriendRequest(friendActionDto);

           if(!rejectFriendRequest) return BadRequest(new { Message = "Friend request not rejected" });

            return Ok(new { Message = "Friend request rejected" });
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetFriendPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _friendService.GetFriendsPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetFriend()
        {
            const string cacheKey = "GetFriendCacheKey";
            if (!_cache.TryGetValue(cacheKey, out IEnumerable<Friend> cachedfriend))
            {
                var result = await _friendService.GetFriendsAsync();

                var cacheOptions = new MemoryCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(6)
                };
                _cache.Set(cacheKey, result, cacheOptions);

                foreach (var Friend in result)
                {
                    string individualCacheKey = $"GetFriendCacheKey_{Friend.FriendId}";
                    _cache.Set(individualCacheKey, Friend, cacheOptions);
                }
                return Ok(result);
            }
            return Ok(cachedfriend);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetFriend([FromRoute] Guid id)
        {
            string cacheKey = $"GetFriendCacheKey_{id}";

            if (!_cache.TryGetValue(cacheKey, out Friend cachedFriend))
            {
                var result = await _friendService.GetFriendAsync(id);
                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }

            return Ok(cachedFriend);
        }


        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertFriend([FromBody] FriendDto friendDto)
        {
            var friend = FriendDto.ToModel(friendDto);
            await _friendService.InsertFriendAsync(friend);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateFriend([FromRoute] Guid id, [FromBody] FriendDto friendDto)
        {
            if (id != friendDto.Id)
            {
                return BadRequest("ID mismatch");
            }

            var updatedFriend = await _friendService.UpdateFriendAsync(friendDto);
            if (!updatedFriend)
            {
                return NotFound();
            }

            string cacheKey = $"GetFriendCacheKey_{id}";
            _cache.Remove(cacheKey);

            const string friendCacheKey = "GetFriendCacheKey";
            _cache.Remove(friendCacheKey);

            return Ok(updatedFriend);
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteFriend([FromRoute] int id)
        {
            await _friendService.DeleteFriendAsync(id);
            return Ok();
        }
    }
}


