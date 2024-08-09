*** Settings ***

Library    SeleniumLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary
    

*** Test Cases ***

Creates a new user account via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    ${user_email}    FakerLibrary.Email
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password

    Open Browser    url=https://practice.expandtesting.com/notes/app/register    browser=chrome    options=add_argument("--no-sandbox")


    
    Maximize Browser Window
    Click Element    locator=//div[@class='page-layout']
    #Iframe covers Register button and no other keywords like Scrol Element To View or Click Button. I can create a keyword for this action and adapt it according to each need. 
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Input Text    locator=//input[@id='email']    text=${user_email}
    Input Text    locator=//input[@name='name']    text=${user_name}
    Input Text    locator=//input[@id='password']    text=${user_password}
    Input Text    locator=//input[@name='confirmPassword']    text=${user_password}
    Click Element    locator=//div[@class='page-layout']
    #Iframe covers Register button and no other keywords like Scrol Element To View or Click Button. I can create a keyword for this action and adapt it according to each need. 
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Click Button    locator=//button[contains(.,'Register')]
    Wait Until Element Is Visible    locator=//b[contains(.,'User account created successfully')]
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_name":"${user_name}","user_password":"${user_password}"}

    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    Go To    url=https://practice.expandtesting.com/notes/app/login
    Input Text    locator=//input[@id='email']    text=${user_email}
    Input Text    locator=//input[@id='password']    text=${user_password}
    Click Element    locator=//div[@class='page-layout']
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Click Button    locator=//button[contains(.,'Login')]
    Wait Until Element Is Visible    locator=//a[contains(.,'MyNotes')]
    Go To    url=https://practice.expandtesting.com/notes/app/profile
    ${user_id}    Get Value    locator=//input[@id='user-id']
    ${user_token}    Execute Javascript   return window["localStorage"].getItem("token")  
    Log To Console    ${user_token}
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
