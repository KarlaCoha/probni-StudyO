using Microsoft.AspNetCore.Mvc;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Core.Security.Attributes;
using Microsoft.Extensions.Caching.Memory;
using StudyO.Domain.Models.Main;

namespace StudyO.Api.Controllers
{
    [Produces("application/json")]
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class AnswerController : ControllerBase
    {
        private readonly IAnswerService _answerService;
        private readonly IMemoryCache _cache;

        public AnswerController(IAnswerService answer, IMemoryCache memoryCache)
        {
            _answerService = answer;
            _cache = memoryCache;
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetAnswersPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _answerService.GetAnswersPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetAnswers()
        {
            const string cacheKey = "GetAnswersCacheKey";
            if (!_cache.TryGetValue(cacheKey, out IEnumerable<Answer> cachedAnswers))
            {
                var result = await _answerService.GetAnswersAsync();
           
                var cacheOptions = new MemoryCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(6)
                };
                _cache.Set(cacheKey, result, cacheOptions);

                foreach (var answer in result)
                {
                    string individualCacheKey = $"GetAnswerCacheKey_{answer.AnswerId}";
                    _cache.Set(individualCacheKey, answer, cacheOptions);
                }
                return Ok(result);
            }
            return Ok(cachedAnswers);
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetAnswer([FromRoute] int id)
        {
          
                var result = await _answerService.GetAnswerAsync(id);
                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            
        }

        [HttpGet("question/{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetAnswerByQuestionId([FromRoute] int id)
        {
                var result = await _answerService.GetAnswerByQuestionIdAsync(id);
                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
           
        }


        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertAnswer([FromBody] AnswerDto answerDto)
        {
            await _answerService.InsertAnswerAsync(answerDto);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateAnswer([FromRoute] int id, [FromBody] AnswerDto answerDto)
        {
            if (id != answerDto.AnswerId)
            {
                return BadRequest("ID mismatch");
            }

            var updatedAnswer = await _answerService.UpdateAnswerAsync(answerDto);
            if (!updatedAnswer)
            {
                return NotFound();
            }

            string cacheKey = $"GetAnswerCacheKey_{id}";
            _cache.Remove(cacheKey);

            const string answersCacheKey = "GetAnswersCacheKey";
            _cache.Remove(answersCacheKey);

            return Ok(updatedAnswer);
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteAnswer([FromRoute] int id)
        {
            await _answerService.DeleteAnswerAsync(id);
            return Ok();
        }
    }
}
