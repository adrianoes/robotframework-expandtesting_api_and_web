*** Settings ***

Library    RequestsLibrary

*** Test Cases ***

Check api health 
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api
    ${responseCH}    GET On Session    alias=expandtesting     url=/health-check   expected_status=200 
    ${message}    Set Variable    ${responseCH.json()['message']}    
    Should Be Equal    ${message}    Notes API is Running
    # Log To Console    ${message} 