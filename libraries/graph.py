from O365 import Account, MSGraphProtocol
from datetime import datetime, timedelta
from robot.api import logger
from bs4 import BeautifulSoup
import re

# https://pypi.org/project/O365/
# Add App registration to your Azure AD
# - Set client secret
# - Add permissions (Mail.Read)
# Doesn't work with personal account, needs to be a corporate.

def  get_email_content(client_id: str,
                       client_secret: str,
                       tenant: str,
                       email: str,
                       subject: str,
                       minutes: int):

    credentials = (client_id, client_secret)
    account = Account(credentials, 
                      auth_flow_type='credentials',
                      tenant_id=tenant)
    
    account.authenticate()
    logger.console("authenticated")
    mailbox = account.mailbox(resource=email)

    inbox = mailbox.inbox_folder()

    # subtract provided minutes from current date
    today = datetime.now()
    past_date = today - timedelta(minutes=minutes)

    query = mailbox.new_query().on_attribute('subject').contains(subject)
    # return only messages that have been received after provided datetime.
    # if minutes=5 return messages received within last 5 minutes.
    query.chain('and').on_attribute('received_date_time').greater_equal(past_date)

    messages = inbox.get_messages(limit=1, query=query)
    # returns latest message first
    # so just process the first one and return
    for message in messages:
        logger.console(message.get_body_text())

        # parse links from message
        links = []
        soup = message.get_body_soup()
        for link in soup.findAll('a', attrs={'href': re.compile("^https://")}):
            links.append(link.get('href'))

        my_dict = {}
        my_dict['text'] = message.get_body_text()
        my_dict['links'] = links

        return my_dict
