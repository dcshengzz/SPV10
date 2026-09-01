
-- Run this scipt to add DeplymentRequest workflow

INSERT INTO [dbo].[WorkflowScheme] ([Code], [Scheme]) VALUES (N'DeploymentRequest', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="Deployment Reviewers" Rule="CheckRole" Value="DplyReviewer" />
    <Actor Name="Deployment Approvers" Rule="CheckRole" Value="DplyApprover" />
    <Actor Name="Deployment Creator" Rule="IsDplyAuthor" Value="" />
  </Actors>
  <Commands>
    <Command Name="Send For Review" />
    <Command Name="Approve" />
    <Command Name="Reject" />
  </Commands>
  <Activities>
    <Activity Name="Draft" State="Draft" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateTransitionHistory" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="WriteTransitionHistory" />
      </PreExecutionImplementation>
      <Designer X="59.99999999999996" Y="110.1111111111111" />
    </Activity>
    <Activity Name="For Review" State="For Review" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateTransitionHistory" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="WriteTransitionHistory" />
      </PreExecutionImplementation>
      <Designer X="289.99999999999994" Y="270.1111111111111" />
    </Activity>
    <Activity Name="For Approval" State="For Approval" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateTransitionHistory" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="WriteTransitionHistory" />
      </PreExecutionImplementation>
      <Designer X="673.888888888889" Y="81.55555555555554" />
    </Activity>
    <Activity Name="Active" State="Active" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="UpdateTransitionHistory" />
      </Implementation>
      <PreExecutionImplementation>
        <ActionRef Order="1" NameRef="WriteTransitionHistory" />
      </PreExecutionImplementation>
      <Designer X="633.8888888888889" Y="391.5555555555556" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="Start_Review_1" To="For Review" From="Draft" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Deployment Creator" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Send For Review" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="148.99999999999994" Y="227.1111111111111" />
    </Transition>
    <Transition Name="Review_Approve_1" To="For Approval" From="For Review" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Deployment Reviewers" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="610.8333333333334" Y="223.61111111111114" />
    </Transition>
    <Transition Name="Review_Start_1" To="Draft" From="For Review" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Deployment Reviewers" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="405.99999999999994" Y="142.1111111111111" />
    </Transition>
    <Transition Name="Approve_Review_1" To="For Review" From="For Approval" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Deployment Approvers" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="480.83333333333337" Y="113.61111111111117" />
    </Transition>
    <Transition Name="ForApproval_Active_1" To="Active" From="For Approval" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Deployment Approvers" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>');
