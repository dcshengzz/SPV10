using Microsoft.AspNetCore.Mvc;

namespace swz.MockNetrust.Controllers
{
    public class CorppassController : AbstractMockNetrustController
    {
        public CorppassController(Settings settings, MockNetrustService mockNetrustService)
            : base(settings.Corppass, mockNetrustService) { }

        [HttpGet("corppass/spcpAuthPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult SpcpAuthPath() { return base.SpcpAuthPath(); }

        [HttpPost("corppass/spcpAuthSubmit")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult SpcpAuthSubmit() { return base.SpcpAuthSubmit(); }

        [HttpGet("corppass/netrustGatewayPath")]
        [HttpPost("corppass/netrustGatewayPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult NetrustGatewayPath() { return base.NetrustGatewayPath(); }
    }
}
