using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace swz.Clover.SPCP.OIDC
{
    /// <summary>
    /// Implementation of the ISPCPHandler interface for use with OIDC implementations that
    /// use an IOidcProcessor (such as IMDA, and probably EMA).
    /// This class is threadsafe, and it assumes the IOidcProcessor is also threadsafe.
    /// </summary>
    public class OidcCorppassHandler : ISPCPHandler
    {
        private readonly ILogger logger;
        private readonly SPCPOptions spcpOptions;
        private readonly OidcSettings oidcSettings;
        private readonly IOidcProcessor oidcProcessor;

        public OidcCorppassHandler(
            ILogger<OidcCorppassHandler> logger, 
            SPCPOptions spcpOptions,
            CorppassOidcSettings corppassOidcSettings,
            IOidcProcessor oidcProcessor)
        {
            this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
            this.spcpOptions = spcpOptions ?? throw new ArgumentNullException(nameof(spcpOptions));
            this.oidcProcessor = oidcProcessor ?? throw new ArgumentNullException(nameof(oidcProcessor));
            if (corppassOidcSettings == null) throw new ArgumentNullException(nameof(corppassOidcSettings));
            this.oidcSettings = corppassOidcSettings.GetOidcSettings(spcpOptions.Environment);
        }

        /// <summary>
        /// Marshall some information and then delegate to the OidcProcessor for more specific handling.
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public async Task<SPCPHandlerResult> Handle(HttpRequest request, SPCPFlow flow)
        {
            if (flow != SPCPFlow.Corppass) throw new NotImplementedException("Unsupported SPCP flow:" + flow);
            if (request == null) throw new ArgumentNullException(nameof(request));
            try
            {
                if (spcpOptions.IsSPCPLogin == false)
                {
                    logger.LogError(nameof(Handle) + "- Corppass login is not enabled. Not able to login into CorpPas");
                    return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.NotEnabled);
                }
                    
                if(logger.IsEnabled(LogLevel.Trace))
                {
                    logger.LogTrace(nameof(Handle) + " - flow={0}, IsStateChekEnabled={1}", flow, oidcSettings.IsStateCheckEnabled);
                }
                    
                string strCode = request.Query["code"]; //authorization code
                if (string.IsNullOrWhiteSpace(strCode))
                {
                    logger.LogError(nameof(Handle) + " - OIDC code not specified in request. Not able to login into CorpPass");
                    return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
                }

                if(oidcSettings.IsStateCheckEnabled)
                {
                    //Purpose of the state is to provide a preliminary check that the incoming request
                    //is from legit sender *before* we go through the effort of exchanging the code for 
                    //the token and checking the nonce
                    string state = request.Query["state"]; //random state value that was passed to spcp
                    if (string.IsNullOrWhiteSpace(state))
                    {
                        logger.LogError(nameof(Handle) + " - OIDC state not specified in request. Not able to login into CorpPass");
                        return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
                    }

                    string originalState = request.HttpContext?.Session?.GetString("state");
                    if (string.IsNullOrWhiteSpace(originalState))
                    {
                        logger.LogError(nameof(Handle) + "- OIDC state not recorded in session. Not able to login into CorpPass");
                        return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
                    }
                    
                    if(!originalState.Equals(state, StringComparison.Ordinal))
                    {
                        logger.LogError(nameof(Handle) + " - OIDC state in request does not match OIDC state in session. expected={0}, received={1}. Not able to login into CorpPass", originalState, state);
                        return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
                    }
                }

                string strNonce = request.HttpContext?.Session?.GetString("nonce");
                if (string.IsNullOrWhiteSpace(strNonce))
                {
                    logger.LogError(nameof(Handle) + " - Nonce not specified in session. Not able to login into CorpPass");
                    return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidRequest);
                }

                //Processor handles impl dependent exchange of the code for the actual token (json)
                //(for example, by calling spcp gateway)
                string oidcAccessToken = await oidcProcessor.GetAccessToken(strCode);

                if (string.IsNullOrEmpty(oidcAccessToken))
                {
                    logger.LogError(nameof(Handle) + " - Gateway return token is empty. Not able to login into Corppass");
                    return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidGatewayResponse);
                }

                //Processor will verify the token is valid (for example by checking a nonce or signature etc)
                //and return us the identity of the respondent. It returns null for invalid tokens.
                string cPEntID = await oidcProcessor.ProcessAccessToken(oidcAccessToken, strNonce);
                if (cPEntID == null)
                {
                    logger.LogError(nameof(Handle) + " - Token process do not found cPEndID or nonce not match. Not able to login into CorpPass");
                    return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InvalidAccessToken);
                }

                return SPCPHandlerResult.Success(uId: cPEntID);
            }
            catch (Exception e)
            {
                logger.LogError(e, nameof(Handle) + " - Unexpected exception thrown. Not able to login into CorpPass");
                return SPCPHandlerResult.Fail(SPCPHandlerResult.Outcome.InternalError);
            }
            finally
            {
                if (oidcSettings.IsNonceCleanupEnabled) 
                    request.HttpContext?.Session?.Remove("nonce");
                if(oidcSettings.IsStateCheckEnabled)
                    request.HttpContext?.Session?.Remove("state");
            }
        }
    }
}
