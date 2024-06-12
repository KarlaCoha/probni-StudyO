using StudyO.Domain.Interfaces.Repositories.Main;
using StudyO.Domain.Models.Main;
using StudyO.Utilities.Paging.Models;
using Microsoft.EntityFrameworkCore;
using StudyO.Utilities.Paging;

namespace StudyO.Persistence.Main
{
    public class SpecialNeedRepository : ISpecialNeedRepository
    {
        private readonly ApplicationDbContext _context;
        public SpecialNeedRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<SpecialNeed>> GetSpecialNeedsPagedAsync(TableMetadata? tableMetadata)
        {
            var query = PagingHelper.CreateTableQuery(_context.SpecialNeeds, tableMetadata);
            return await query.ToListAsync();
        }

        public async Task<int> GetSpecialNeedsCountAsync()
        {
            return await _context.SpecialNeeds.CountAsync();
        }

        public async Task<List<SpecialNeed>> GetSpecialNeedsAsync()
        {
            return await _context.SpecialNeeds.ToListAsync();
        }

        public async Task<SpecialNeed> GetSpecialNeedAsync(int id)
        {
            return await _context.SpecialNeeds.FindAsync(id);
        }

        public async Task InsertSpecialNeedAsync(SpecialNeed specialNeed)
        {
            _context.SpecialNeeds.Add(specialNeed);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateSpecialNeedAsync(SpecialNeed specialNeed)
        {
            var existingSpecialNeed = await _context.SpecialNeeds.FindAsync(specialNeed.Id);
            if (existingSpecialNeed != null)
            {
                _context.Entry(existingSpecialNeed).CurrentValues.SetValues(specialNeed);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteSpecialNeedAsync(int id)
        {
            var specialNeed = await _context.SpecialNeeds.FindAsync(id);
            if (specialNeed != null)
            {
                _context.SpecialNeeds.Remove(specialNeed);
                await _context.SaveChangesAsync();
            }
        }
    }
}
