# NOTE: readme.txt contains important information you need to take into account
# before running this suite.

*** Settings ***
Resource              ../resources/common.resource
Resource              ../resources/graph.resource
Suite Setup           Setup Browser
Suite Teardown        End suite


*** Test Cases ***
Connecting to shared mailbox
    # added argument minutes=int to only check emails that have been received eg. within last 5 minutes
    # in this example.
    # If email is not found it will sleep 30s and try again
    # NOTE: Keyword now returns a dictionary or None {text: body, links: [https://link1, https://linkN]}
    ${email_body}=    Get Email Content           client_id=${client_id}    client_secret=${client_secret}    tenant=${tenant_id}
    ...               email=${email_address}      subject=${email_subject}  minutes=5

    Log To Console    ${email_body}

    IF                ${email_body} is not None
        Log To Console                            We have a message.
    ELSE
        WHILE         ${email_body} is None
            Log To Console                        No Email located, trying again in 30 seconds.
            Sleep     30
            ${email_body}=                        Get Email Content           client_id=${client_id}      client_secret=${client_secret}    tenant=${tenant_id}
            ...       email=${email_address}      subject=${email_subject}    minutes=2

            Log To Console                        ${email_body}
        END
    END

    # Update these with how you would utilize the returned content.
    Should Contain    ${email_body}[text]         Online ordering for Seed is here!

    # Example: Email might contain several links, find out the correct one and use Goto with index.
    ${my_link}=       Set Variable                ${email_body}[links][0]
    Goto              ${my_link}

    # Loop list of links to find a correct one. Use @ to get list context.
    FOR               ${link}                     IN                          @{email_body}[links]
        Log To Console                            ${link}
        # TODO
        # GoTo        ${link}
    END
