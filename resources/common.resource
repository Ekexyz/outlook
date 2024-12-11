*** Settings ***
Documentation             Example resource file with custom keywords. NOTE: Some keywords below may need
...                       minor changes to work in different instances.
Library                   QForce
Library                   QVision
Library                   String
Library                   DateTime

*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                chrome


*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order    QForce                      QWeb                        QVision
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    Evaluate                    random.seed()               random                      # initialize random generator
    SetConfig                   DefaultTimeout              45s                         #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig                   Delay                       0.3

End suite
    Close All Browsers
