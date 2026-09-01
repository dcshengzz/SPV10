using Microsoft.AspNetCore.Mvc;

namespace swz.MockNevis.Controllers
{
    public class CorppassController : AbstractMockNevisController
    {
        public CorppassController(Settings settings, MockNevisService<Flow.Corppass> mockNevisService) 
            : base(settings.Corppass, mockNevisService) { }

        [HttpGet]
        [Route("corppass/nevisAuthPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult AuthenticationPath(string returnUrl) { return base.AuthenticationPath(returnUrl); }

        [HttpGet]
        [Route("corppass/tokenConsumptionPath")]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public override ActionResult TokenConsumptionPath() { return base.TokenConsumptionPath(); }
    }
}
