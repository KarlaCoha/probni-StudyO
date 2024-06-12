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
    public class SubjectController : ControllerBase
    {
        private readonly ISubjectService _subjectService;

        public SubjectController(ISubjectService subject)
        {
            _subjectService = subject;
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSubjectsPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _subjectService.GetSubjectsPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSubjects()
        {
            var result = await _subjectService.GetSubjectsAsync();
            return Ok(result);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetSubject([FromRoute] int id)
        {
            var result = await _subjectService.GetSubjectAsync(id);
            return Ok(result);
        }

        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertSubject([FromBody] SubjectDto subjectDto)
        {
            await _subjectService.InsertSubjectAsync(subjectDto);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateSubject([FromBody] SubjectDto subjectDto)
        {
            await _subjectService.UpdateSubjectAsync(subjectDto);
            return Ok();
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteSubject([FromRoute] int id)
        {
            await _subjectService.DeleteSubjectAsync(id);
            return Ok();
        }
    }
}
