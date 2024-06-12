using Microsoft.AspNetCore.Mvc;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Core.Security.Attributes;

namespace StudyO.Api.Controllers
{
    [Produces("application/json")]
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class SpecialNeedController : ControllerBase
    {
        private readonly ISpecialNeedService _specialNeedService;

        public SpecialNeedController(ISpecialNeedService specialNeed)
        {
            _specialNeedService = specialNeed;
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSpecialNeedsPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _specialNeedService.GetSpecialNeedsPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSpecialNeeds()
        {
            var result = await _specialNeedService.GetSpecialNeedsAsync();
            return Ok(result);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSpecialNeed([FromRoute] int id)
        {
            var result = await _specialNeedService.GetSpecialNeedAsync(id);
            return Ok(result);
        }

        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertSpecialNeed([FromBody] SpecialNeedDto specialNeedDto)
        {
            await _specialNeedService.InsertSpecialNeedAsync(specialNeedDto);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateSpecialNeed([FromBody] SpecialNeedDto specialNeedDto)
        {
            await _specialNeedService.UpdateSpecialNeedAsync(specialNeedDto);
            return Ok();
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteSpecialNeed([FromRoute] int id)
        {
            await _specialNeedService.DeleteSpecialNeedAsync(id);
            return Ok();
        }
    }
}
