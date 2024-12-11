# outlook

This Example will connected to a Outlook Mailbox and return a Dictionary of Email Body and Links.
This Example uses O365 library for authorization and Email retrieval. Beautifulsoup4 is used to parse links from the Email body.

Add Copado Robotic Testing secret variables on Test Job level for the ones defined in graph.resource file.
Example usage can be located in test.robot file.

Library https://pypi.org/project/O365/

Add App registration into your Azure AD to obtain OAuth2 credentials.
- Add permissions scope (Mail.Read)
- Save client credentials
  
Doesn't work with personal account, needs to be a corporate.
