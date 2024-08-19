*** Settings ***

Library    Browser
Resource    ../resources/test.resource
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
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    New Page    https://practice.expandtesting.com/notes/app/register
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@name='name']    txt=${user_name}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Fill Text    selector=//input[@name='confirmPassword']    txt=${user_password}
    #Below command will be commented but left here to remind better applicability of Browser library instead of selenium library
    # Scroll To Element    selector=//button[contains(.,'Register')]
    Click    selector=//button[contains(.,'Register')]
    Wait For Elements State    selector=//b[contains(.,'User account created successfully')]    state=visible
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_name":"${user_name}","user_password":"${user_password}"}
    logInUserViaUi(${bypassParalelismNumber})
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
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
    Go To    https://practice.expandtesting.com/notes/app/login
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Click    selector=//button[contains(.,'Login')]
    Wait For Elements State    selector=//a[contains(.,'MyNotes')]    state=visible
    Go To    https://practice.expandtesting.com/notes/app/profile
    ${user_id}    Get Attribute    selector=//input[@data-testid='user-id']    attribute=value    
    ${user_token}    LocalStorage Get Item   key=token 
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Retrieve user profile information via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_name_data}    Get Value From Json    ${data}    $.user_name
    ${user_name_str}    Convert JSON To String	 ${user_name_data}
    ${user_name}    Remove String    ${user_name_str}    [    ]    '    " 
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//div[@class='page-layout']
    ${user_email_profile}    Get Attribute    selector=//input[@data-testid='user-email']    attribute=value
    ${user_name_profile}    Get Attribute    selector=//input[@data-testid='user-name']    attribute=value
    Should Be Equal    ${user_email}    ${user_email_profile}
    Should Be Equal    ${user_name}    ${user_name_profile}
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Update user profile information via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_name}    FakerLibrary.Name
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=10000000    max=99999999999999999999    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    Fill Text    selector=//input[@data-testid='user-company']    txt=${updated_user_company}
    Fill Text    selector=//input[@data-testid='user-name']    txt=${updated_user_name}
    Fill Text    selector=//input[@data-testid='user-phone']    txt=${updated_user_phone}
    Click    selector=//button[contains(.,'Update profile')]
    Wait For Elements State    selector=//div[@class='d-flex'][contains(.,'Profile updated successful')]    state=visible
    ${user_company_profile}    Get Attribute    selector=//input[@data-testid='user-company']    attribute=value
    ${user_email_profile}    Get Attribute    selector=//input[@data-testid='user-email']    attribute=value
    ${user_name_profile}    Get Attribute    selector=//input[@data-testid='user-name']    attribute=value
    ${user_phone_profile}    Get Attribute    selector=//input[@data-testid='user-phone']    attribute=value
    Should Be Equal    ${updated_user_company}    ${user_company_profile}
    Should Be Equal    ${user_email}    ${user_email_profile}
    Should Be Equal    ${updated_user_name}    ${user_name_profile}
    Should Be Equal    ${updated_user_phone}    ${user_phone_profile}
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Change a user\'s password via UI 
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    ${user_new_password}    FakerLibrary.password
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Change password')]
    Fill Text    selector=//input[contains(@data-testid,'current-password')]    txt=${user_password}
    Fill Text    selector=//input[contains(@data-testid,'new-password')]    txt=${user_new_password}
    Fill Text    selector=//input[contains(@data-testid,'confirm-password')]    txt=${user_new_password}
    Click    selector=//button[contains(.,'Update password')]
    Wait For Elements State    selector=//div[@class='d-flex'][contains(.,'The password was successfully updated')]    state=visible
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Log out a user via UI 
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Logout')]
    Wait For Elements State    selector=//a[contains(.,'Login')]    state=visible
    logInUserViaUi(${bypassParalelismNumber})
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Delete user account via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber})
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Delete Account')]
    Click    selector=//button[@data-testid='note-delete-confirm']
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'Your account has been deleted. You should create a new account to continue.')]    state=visible
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})
