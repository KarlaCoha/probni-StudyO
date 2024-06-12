using System;
using System.Net.Mail;
using Microsoft.Extensions.Configuration;

namespace StudyO.Core.Infrastructure.EmailService
{
    public class EmailSender
    {
        private readonly IConfiguration _config;

        public EmailSender(IConfiguration config)
        {
            _config = config;
        }

        public bool SendEmailAsync(string userEmail, string emailSubject, string msg)
        {
            var emailSettings = _config.GetSection("EmailSettings");
            string fromMail = emailSettings["FromEmail"];
            string fromPassword = emailSettings["FromPassword"];
           

            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress(fromMail);
            mailMessage.To.Add(new MailAddress(userEmail));
            mailMessage.Subject = emailSubject;
            mailMessage.IsBodyHtml = true;
            mailMessage.Body = msg;

            SmtpClient client = new SmtpClient();
            client.Credentials = new System.Net.NetworkCredential(fromMail, fromPassword);
            client.Host = "smtp.gmail.com";
            client.Port = 587;
            client.EnableSsl = true;

            try
            {
                client.Send(mailMessage);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return false;
        }
    }
}
