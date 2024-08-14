*** Settings ***

Resource    ../resources/test.resource
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
    # Chrome presents an error only in github actions when tests are ran in normal browser. Something related to chromedriver. So if tests run in headless the problem disappear. 
    # Open Browser    url=https://practice.expandtesting.com/notes/app/register    browser=chrome    options=add_argument("--no-sandbox")
    # To run the tests with UI, comment the line below and uncomment the line above. 
    Open Browser    url=https://practice.expandtesting.com/notes/app/register    browser=headlesschrome    options=add_argument("--no-sandbox")
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
    logInUserViaUi(${bypassParalelismNumber})
    deleteUserViaUi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Log in as an existing user via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_name_data}    Get Value From Json    ${data}    $.user_name
    ${user_name_str}    Convert JSON To String	 ${user_name_data}
    ${user_name}    Remove String    ${user_name_str}    [    ]    '    " 
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    Go To    url=https://practice.expandtesting.com/notes/app/login
    Click Element    locator=//div[@class='page-layout']
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
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
    ${user_id}    Get Value    locator=(//div[contains(@class,'form-group mb-2')])[1]
    Click Element    locator=//div[@class='page-layout']
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    ${user_token}    Execute Javascript   return window["localStorage"].getItem("token")  
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
    deleteUserViaUi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Delete user account via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    Go To    url=https://practice.expandtesting.com/notes/app/profile
    Click Button    locator=//button[contains(.,'Delete Account')]
    Click Button    locator=//button[@data-testid='note-delete-confirm']
    Wait Until Element Is Visible    locator=//div[@data-testid='alert-message'][contains(.,'Your account has been deleted. You should create a new account to continue.')]
    deleteJsonFile(${bypassParalelismNumber})