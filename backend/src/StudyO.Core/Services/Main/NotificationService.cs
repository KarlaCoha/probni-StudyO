using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace StudyO.Core.Services.Main
{
    public class NotificationService
    {
        private readonly NotificationHubClient _hub;

        public NotificationService(IConfiguration configuration)
        {
            var connectionString = configuration["NotificationHub:ConnectionString"];
            var hubName = configuration["NotificationHub:HubName"];
            _hub = NotificationHubClient.CreateClientFromConnectionString(connectionString, hubName);

            Console.WriteLine($"Connection String: {connectionString}");
            Console.WriteLine($"Hub Name: {hubName}");
        }


        public async Task<bool> RegisterDeviceAsync(Guid userId, string deviceHandle)
        {
            var tag = userId.ToString();

            try
            {
                var existingRegistrations = await _hub.GetRegistrationsByChannelAsync(deviceHandle, 100);
                foreach (var registration in existingRegistrations)
                {
                    if (registration.Tags.Contains(tag))
                    {
                        await _hub.DeleteRegistrationAsync(registration);
                    }
                }
               
                var result = await _hub.CreateFcmV1NativeRegistrationAsync(deviceHandle, new[] { tag });
                return result != null;
            }
            catch (Exception ex)
            {
                
                Console.Error.WriteLine($"Error registering device: {ex.Message}");
                return false;
            }
        }






        public async Task SendNotificationAsync(string fcmToken, string message)
        {
            var androidPayload = new JObject
            {
                ["message"] = new JObject
                {
                    ["token"] = fcmToken,
                    ["notification"] = new JObject
                    {
                        ["title"] = "Notification Title",
                        ["body"] = message
                    }
                }
            };

            try
            {
                var payloadJson = androidPayload.ToString(Formatting.None);
                Console.WriteLine($"Sending notification to token: {fcmToken} with payload: {payloadJson}");
                await _hub.SendFcmV1NativeNotificationAsync(payloadJson);
                Console.WriteLine("Notification sent successfully to token: " + fcmToken);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error sending notification: {ex.Message}");
                Console.Error.WriteLine($"Stack Trace: {ex.StackTrace}");
            }
        }


    }

}
