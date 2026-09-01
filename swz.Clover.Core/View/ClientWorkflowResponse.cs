using System.Collections.Generic;

namespace swz.Clover.Core.View
{
    public class ClientWorkflowResponse
    {
       public  List<ClientWorkflowCommand> Commands { get; set; }
        public  List<ClientWorkflowState> States { get; set; }
    }
}