using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using swz.Clover.Core.Metadata;
using swz.SurveyPlus.IntranetApplication.Models.StoredProcedures;

namespace swz.SurveyPlus.IntranetApplication
{
    /// <summary>
    /// Background service that checks the most recent UpdatedDate and CreatedDate values in dwMetadata to
    /// see if they are newer than when the MetadataCaches were last flushed, and if so, flush them.
    /// This is mainly to allow survey form changes to propagate to other server's caches in a multi-server
    /// environment, though it is agnostic to type of metadata that changes and just flushes them all.
    /// </summary>
    public class MetadataCachesFlusher : BackgroundService
    {
        private readonly ILogger<MetadataCachesFlusher> logger;
        private readonly MetadataCaches metadataCaches;
        private readonly TimeSpan interval;
        private readonly IHostApplicationLifetime applicationLifetime;

        public MetadataCachesFlusher(
            ILogger<MetadataCachesFlusher> logger,
            IHostApplicationLifetime applicationLifetime,
            MetadataCaches metadataCaches,
            SurveyPlusOptions surveyPlusOptions)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.applicationLifetime = applicationLifetime ?? throw new ArgumentNullException(nameof(applicationLifetime));
            this.metadataCaches = metadataCaches ?? throw new ArgumentNullException(nameof(metadataCaches));
            if(surveyPlusOptions == null) throw new ArgumentNullException(nameof(surveyPlusOptions));

            interval = TimeSpan.FromMinutes(surveyPlusOptions.MetadataCacheCheckMinutes);
        }

        protected override async Task ExecuteAsync(CancellationToken cancellation)
        {
            //Wait for application to finish startup before trying to do anything
            //(We get called while Configure is still in progress, so application not fully setup yet - e.g. no db provider yet)
            TaskCompletionSource tcs = new TaskCompletionSource();
            using var registration = applicationLifetime.ApplicationStarted.Register(() => tcs.TrySetResult());
            await Task.WhenAny(tcs.Task, Task.Delay(Timeout.InfiniteTimeSpan, cancellation));

            logger.LogInformation(nameof(ExecuteAsync) + " - background service starting");

            //Service loop. Check now, then every n minutes
            while (!cancellation.IsCancellationRequested)
            {
                try
                {
                    await Task.Delay(interval, cancellation);

                    const int driftBufferSeconds = 5; //allows for small differences in server/db times to avoid unnecessary double-flushes
                    DateTime latestDb = await spSP_GetMetadataChangeDate.MostRecentChange();
                    DateTime lastFlushed = metadataCaches.LastFlushed;
                    bool isFlushRequired = latestDb > lastFlushed.AddSeconds(driftBufferSeconds);

                    if (logger.IsEnabled(LogLevel.Trace))
                    {
                        logger.LogTrace(nameof(ExecuteAsync) + " checking - interval={0}, latestDb={1}, lastFlushed={2}, driftBufferSeconds={3}, isFlushRequired={4}", interval, latestDb, lastFlushed, driftBufferSeconds, isFlushRequired);
                    }

                    if (latestDb > lastFlushed)
                    {
                        logger.LogDebug(nameof(ExecuteAsync) + " - Flushing metadata caches");
                        metadataCaches.Flush();
                    }
                }
                catch(OperationCanceledException)
                {
                    logger.LogTrace(nameof(ExecuteAsync) + " - cancelled");
                }
                catch (Exception e)
                {
                    logger.LogError(e, nameof(ExecuteAsync) + " - caught unexpected exception");
                }
            } //endwhile
            logger.LogInformation(nameof(ExecuteAsync) + " - background service terminating");
        }
    }
}
