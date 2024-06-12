using Microsoft.AspNetCore.Mvc;
using StudyO.Core.Services.Main.Interfaces;
using StudyO.Core.Dtos.Main;
using StudyO.Utilities.Paging.Models;
using StudyO.Core.Security.Attributes;
using Microsoft.Extensions.Caching.Memory;
using StudyO.Core.Services.Main;
using StudyO.Domain.Models.Main;

namespace StudyO.Api.Controllers
{
    [Produces("application/json")]
    [ApiController]
    [Authorize]
    [Route("[controller]")]
    public class QuestionController : ControllerBase
    {
        private readonly IQuestionService _questionService;
        private readonly IMemoryCache _cache;

        public QuestionController(IQuestionService question, IMemoryCache cache)
        {
            _questionService = question;
            _cache = cache;
        }

        [HttpPost("paged")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetQuestionsPaged([FromBody] TableMetadata? tableMetadata)
        {
            var result = await _questionService.GetQuestionsPagedAsync(tableMetadata);
            return Ok(result);
        }

        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetQuestions()
        {
            
            const string cacheKey = "GetQuestionsCacheKey";
            if (!_cache.TryGetValue(cacheKey, out IEnumerable<Question> cachedQuestions))
            {
                var result = await _questionService.GetQuestionsAsync();

                var cacheOptions = new MemoryCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(6)
                };
                _cache.Set(cacheKey, result, cacheOptions);

                foreach (var question in result)
                {
                    string individualCacheKey = $"GetQuestionsCacheKey_{question.QuestionId}";
                    _cache.Set(individualCacheKey, question, cacheOptions);
                }
                return Ok(result);
            }
            return Ok(cachedQuestions);
        }
    

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetQuestion([FromRoute] int id)
        {
            
            string cacheKey = $"GetQuestionCacheKey_{id}";

            if (!_cache.TryGetValue(cacheKey, out Answer cachedQuestion))
            {
                var result = await _questionService.GetQuestionAsync(id);
                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }

            return Ok(cachedQuestion);
        }

        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> InsertQuestion([FromBody] QuestionDto questionDto)
        {
            await _questionService.InsertQuestionAsync(questionDto);
            return Ok();
        }

        [HttpPatch()]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateQuestion([FromRoute] int id,[FromBody] QuestionDto questionDto)
        {
            await _questionService.UpdateQuestionAsync(questionDto);
            if (id != questionDto.QuestionId)
            {
                return BadRequest("ID mismatch");
            }

            var updatedQuestion = await _questionService.UpdateQuestionAsync(questionDto);
            if (!updatedQuestion)
            {
                return NotFound();
            }

            string cacheKey = $"GetQuestionCacheKey_{id}";
            _cache.Remove(cacheKey);

            const string questionCacheKey = "GetQuestionCacheKey";
            _cache.Remove(questionCacheKey);

            return Ok(updatedQuestion);
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteQuestion([FromRoute] int id)
        {
            await _questionService.DeleteQuestionAsync(id);
            return Ok();
        }
    }
}
