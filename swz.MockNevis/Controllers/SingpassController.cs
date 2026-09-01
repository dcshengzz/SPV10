using Microsoft.AspNetCore.Mvc;

namespace swz.MockNevis.Controllers
{
    public class SingpassController : AbstractMockNevisController
    {
        public SingpassController(Settings settings, MockNevisService<Flow.Singpass> mockNevisService)
            : base(settings.Singpass, mockNevisService) { }

        [HttpGet]
        [Route("singpass/nevisAuthPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult AuthenticationPath(string returnUrl) { return base.AuthenticationPath(returnUrl); }

        [HttpGet]
        [Route("singpass/tokenConsumptionPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult TokenConsumptionPath() { return base.TokenConsumptionPath(); }
    }
}
