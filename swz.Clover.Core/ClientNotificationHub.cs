using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using swz.Clover.Core.Security;

namespace swz.Clover.Core
{
    public class ClientNotificationHub : Hub
    {
        public override async Task OnConnectedAsync()
        {
            if (!string.IsNullOrWhiteSpace(Context.UserIdentifier))
            {
                //await CloverRuntime.NotifyConnectedClients(GetType(), Context.UserIdentifier);
                await CloverRuntime.SpNotifyConnectedClients(GetType(), Context.UserIdentifier);


                var classifier = CloverRuntime.SignalRGroupClassifier;
                if (classifier != null)
                {
                    var groups = await classifier.Invoke(Context.UserIdentifier);
                    foreach (var groupName in groups)
                    {
                        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
                    }
                }
            }
           
            await base.OnConnectedAsync();
        }
    }

    public class SignalRIdProvider : IUserIdProvider
    {
        public virtual string GetUserId(HubConnectionContext connection)
        {
            var impersonated = connection.GetHttpContext()?.Request.Query[AdditionalClaims.ImpersonatedUserIdClaim];
            if (!string.IsNullOrEmpty(impersonated))
                return impersonated;

            var userId = connection.User?.FindFirst(ClaimTypes.Sid)?.Value;
            if (!string.IsNullOrEmpty(userId))
                return userId;
            
            return CloverRuntime.Security.CurrentUser?.Id.ToString();
        }
    }
}