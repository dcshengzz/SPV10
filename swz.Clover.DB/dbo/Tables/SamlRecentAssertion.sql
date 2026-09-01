CREATE TABLE [dbo].[SamlRecentAssertion] (
    [AssertionID] NVARCHAR (128) NOT NULL,
    [Expiration]  DATETIME       NOT NULL,
    PRIMARY KEY CLUSTERED ([AssertionID] ASC)
);

