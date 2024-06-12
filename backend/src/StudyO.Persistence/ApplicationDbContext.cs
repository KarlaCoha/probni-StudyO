using Microsoft.EntityFrameworkCore;
using StudyO.Domain.Models;
using StudyO.Domain.Models.Main;

namespace StudyO.Persistence;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }
    

    public virtual DbSet<Answer> Answers { get; set; }

    public virtual DbSet<Lesson> Lessons { get; set; }

    public virtual DbSet<Question> Questions { get; set; }

    public virtual DbSet<SchoolClass> SchoolClasses { get; set; }

    public virtual DbSet<SpecialNeed> SpecialNeeds { get; set; }

    public virtual DbSet<Subject> Subjects { get; set; }

    public virtual DbSet<User> Users { get; set; }
    public virtual DbSet<Friend> Friends { get; set; }

    public virtual DbSet<UserSpecialNeed> UserSpecialNeeds { get; set; }
    public virtual DbSet<UserAuthentication> UserAuthentications { get; set; }

    public virtual DbSet<Challenge> Challenges { get; set; }
    public virtual DbSet<QuizResult> QuizResults { get; set; }


   

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Answer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("answers_pkey");

            entity.ToTable("answers");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AnswerDescription).HasColumnName("answer_description");
            entity.Property(e => e.AnswerText).HasColumnName("answer_text");
            entity.Property(e => e.CorrectAnswer).HasColumnName("correct_answer");
            entity.Property(e => e.QuestionId).HasColumnName("question_id");

            entity.HasOne(d => d.Question).WithMany(p => p.Answers)
                .HasForeignKey(d => d.QuestionId)
                .HasConstraintName("answers_question_id_fkey");
        });

        modelBuilder.Entity<Lesson>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("lessons_pkey");

            entity.ToTable("lessons");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.LessonDescription).HasColumnName("lesson_description");
            entity.Property(e => e.LessonName)
                .HasMaxLength(100)
                .HasColumnName("lesson_name");
            entity.Property(e => e.SubjectId).HasColumnName("subject_id");

            entity.HasOne(d => d.Subject).WithMany(p => p.Lessons)
                .HasForeignKey(d => d.SubjectId)
                .HasConstraintName("lessons_subject_id_fkey");
        });

        modelBuilder.Entity<Question>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("questions_pkey");

            entity.ToTable("questions");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.LessonId).HasColumnName("lesson_id");
            entity.Property(e => e.QuestionText).HasColumnName("question_text");

            entity.HasOne(d => d.Lesson).WithMany(p => p.Questions)
                .HasForeignKey(d => d.LessonId)
                .HasConstraintName("questions_lesson_id_fkey");
        });

        modelBuilder.Entity<SchoolClass>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("school_classes_pkey");

            entity.ToTable("school_classes");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClassNumber).HasColumnName("class_number");
        });

        modelBuilder.Entity<SpecialNeed>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("special_needs_pkey");

            entity.ToTable("special_needs");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
        });

        modelBuilder.Entity<Subject>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("subjects_pkey");

            entity.ToTable("subjects");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClassId).HasColumnName("class_id");
            entity.Property(e => e.Grade).HasColumnName("grade");
            entity.Property(e => e.SubjectName)
                .HasMaxLength(50)
                .HasColumnName("subject_name");

            entity.HasOne(d => d.Class).WithMany(p => p.Subjects)
                .HasForeignKey(d => d.ClassId)
                .HasConstraintName("subjects_class_id_fkey");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("users_pkey");

            entity.ToTable("users");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.DateOfBirth).HasColumnName("date_of_birth");
            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.FirstName).HasColumnName("first_name");
            entity.Property(e => e.Gender).HasColumnName("gender");
            entity.Property(e => e.LastName).HasColumnName("last_name");
            entity.Property(e => e.Password).HasColumnName("password");
            entity.Property(e => e.SchoolClassId).HasColumnName("school_class_id");
            entity.Property(e => e.SpecialNeedsId).HasColumnName("special_needs_id");
            entity.Property(e => e.Username).HasColumnName("username");
            entity.Property(e => e.Points).HasColumnName("points");

            entity.HasOne(d => d.SchoolClass).WithMany(p => p.Users)
                .HasForeignKey(d => d.SchoolClassId)
                .HasConstraintName("users_school_class_id_fkey");

                entity.HasOne(d => d.SpecialNeeds).WithMany(p => p.Users)
                    .HasForeignKey(d => d.SpecialNeedsId)
                    .HasConstraintName("user_special_needs_id_fkey");

                entity.HasMany(u => u.Friends)
                       .WithOne(f => f.User)
                       .HasForeignKey(f => f.UserId)
                       .OnDelete(DeleteBehavior.ClientSetNull)
                       .HasConstraintName("friends_user_id_fkey");

                entity.HasMany(u => u.ReceivedRequests)
                        .WithOne(f => f.FriendUsers)
                        .HasForeignKey(f => f.FriendId)
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("friends_friend_id_fkey");

        });

        modelBuilder.Entity<Challenge>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("challenges_pkey");

            entity.ToTable("challenges");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.SenderId).HasColumnName("sender_id");
            entity.Property(e => e.LessonId).HasColumnName("lesson_id");
            entity.Property(e => e.ReceiverId).HasColumnName("receiver_id");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasColumnName("status");

            entity.HasOne(d => d.Sender)
                   .WithMany()
                   .HasForeignKey(d => d.SenderId)
                   .OnDelete(DeleteBehavior.ClientSetNull)
                   .HasConstraintName("challenges_sender_id_fkey");

            entity.HasOne(d => d.Receiver)
                .WithMany()
                .HasForeignKey(d => d.ReceiverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("challenges_receiver_id_fkey");

        });

        modelBuilder.Entity<QuizResult>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("quiz_results_pkey");

            entity.ToTable("quiz_results");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChallengeId).HasColumnName("challenge_id");
            entity.Property(e => e.SenderScore).HasColumnName("sender_score");
            entity.Property(e => e.ReceiverScore).HasColumnName("receiver_score");
            

            entity.HasOne(d => d.Challenge)
                .WithMany()
                .HasForeignKey(d => d.ChallengeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("quiz_results_challenge_id_fkey");
        });

        modelBuilder.Entity<Friend>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("friends_pkey");

            entity.ToTable("friends");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.FriendId).HasColumnName("friend_id");
            entity.Property(e => e.Status).HasColumnName("status");

            entity.HasOne(d => d.User)
                .WithMany(p => p.Friends)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("friends_user_id_fkey");

            entity.HasOne(d => d.FriendUsers)
                .WithMany(p => p.ReceivedRequests)
                .HasForeignKey(d => d.FriendId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("friends_friend_id_fkey");
        });



        modelBuilder.Entity<UserSpecialNeed>()
            .HasKey(usn => new { usn.UserId, usn.SpecialNeedId });

        modelBuilder.Entity<UserSpecialNeed>(entity =>
        {
            entity.HasKey(usn => new { usn.UserId, usn.SpecialNeedId }).HasName("user_special_needs_pk");

            entity.ToTable("user_special_needs");

            entity.Property(e => e.UserId)
                .ValueGeneratedNever()
                .HasColumnName("user_id");

            entity.Property(e => e.SpecialNeedId)
                .HasColumnName("special_need_id");

            
            entity.HasOne(usn => usn.User)
                .WithMany(u => u.UserSpecialNeeds)
                .HasForeignKey(usn => usn.UserId);

            entity.HasOne(usn => usn.SpecialNeed)
                .WithMany(sn => sn.UserSpecialNeeds)
                .HasForeignKey(usn => usn.SpecialNeedId);
        });


        modelBuilder.Entity<UserAuthentication>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("users_authentication_pk");

            entity.ToTable("users_authentication");

            entity.Property(e => e.UserId)
                .ValueGeneratedNever()
                .HasColumnName("user_id");
            entity.Property(e => e.ApiKey).HasColumnName("api_key");
            entity.Property(e => e.IsRegistered).HasColumnName("is_registered");
            entity.Property(e => e.DeviceToken).HasColumnName("device_token");

            entity.HasOne(d => d.User).WithOne(p => p.UserAuthentication)
                .HasForeignKey<UserAuthentication>(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("users_authentication_fk");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
