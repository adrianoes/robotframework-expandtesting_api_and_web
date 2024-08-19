*** Settings ***

Library    Browser
Resource    ../resources/test_trial_browserlib.resource


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
    New Browser    headless=False
    New Page    https://practice.expandtesting.com/notes/app/register
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@name='name']    txt=${user_name}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Fill Text    selector=//input[@name='confirmPassword']    txt=${user_password}
    Scroll To Element    selector=//button[contains(.,'Register')]
    Click    selector=//button[contains(.,'Register')]
    Wait For Elements State    selector=//b[contains(.,'User account created successfully')]    state=visible
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_name":"${user_name}","user_password":"${user_password}"}
    logInUserViaUi(${bypassParalelismNumber})
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

