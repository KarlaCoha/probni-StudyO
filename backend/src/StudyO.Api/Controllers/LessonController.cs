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
    public class LessonController : ControllerBase
    {
        private readonly ILessonService _lessonService;

        public LessonController(ILessonService lesson)
        {
            _lessonService = lesson;
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetLessonsPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _lessonService.GetLessonsPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetLessons()
        {
            var result = await _lessonService.GetLessonsAsync();
            return Ok(result);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetLesson([FromRoute] int id)
        {
            var result = await _lessonService.GetLessonAsync(id);
            return Ok(result);
        }

        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertLesson([FromBody] LessonDto lessonDto)
        {
            await _lessonService.InsertLessonAsync(lessonDto);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateLesson([FromBody] LessonDto lessonDto)
        {
            await _lessonService.UpdateLessonAsync(lessonDto);
            return Ok();
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteLesson([FromRoute] int id)
        {
            await _lessonService.DeleteLessonAsync(id);
            return Ok();
        }
    }
}
