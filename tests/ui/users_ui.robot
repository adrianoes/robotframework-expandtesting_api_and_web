*** Settings ***

Resource    ../resources/test.resource
Library    Browser
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary    

*** Test Cases ***

Creates a new user account via UI
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    ${random_letter}    FakerLibrary.Random Lowercase Letter
    ${random_email}    FakerLibrary.Email
    ${user_email}    Catenate    SEPARATOR=    ${random_letter}    ${random_email}
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    ${old_timeout} =    Set Browser Timeout    timeout=5m
    New Page    https://practice.expandtesting.com/notes/app/register
    Set Browser Timeout    ${old_timeout} 
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@name='name']    txt=${user_name}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Fill Text    selector=//input[@name='confirmPassword']    txt=${user_password}
    #Below command will be commented but left here to remind better applicability of Browser library instead of selenium library
    # Scroll To Element    selector=//button[contains(.,'Register')]
    Click    selector=//button[contains(.,'Register')]
    ${resp}    Wait For Response    matcher=https://practice.expandtesting.com/notes/api/users/register    timeout=5m
    ${body}    Set Variable    ${resp["body"]}
    ${body_str}    Convert To String	 ${body}
    ${user_id_partial}    Fetch From Left    ${body_str}    ', 'name': 
    ${user_id}    Fetch From Right    ${user_id_partial}    'id': '       
    # Log To Console      ${user_id}
    Wait For Elements State    selector=//b[contains(.,'User account created successfully')]    state=visible    timeout=5m
    Create File    tests/fixtures/testdata-${randomNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}
    logInUserViaUi(${randomNumber})
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Creates a new user account via UI - Invalid e-mail
    [Tags]    UI    FULL    NEGATIVE 
    ${randomNumber}    FakerLibrary.creditCardNumber
    ${random_letter}    FakerLibrary.Random Lowercase Letter
    ${random_email}    FakerLibrary.Email
    ${user_email}    Catenate    SEPARATOR=    ${random_letter}    ${random_email}
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    ${old_timeout} =    Set Browser Timeout    timeout=5m
    New Page    https://practice.expandtesting.com/notes/app/register
    Set Browser Timeout    ${old_timeout} 
    Fill Text    selector=//input[@id='email']    txt='@'+${user_email}
    Fill Text    selector=//input[@name='name']    txt=${user_name}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Fill Text    selector=//input[@name='confirmPassword']    txt=${user_password}
    Click    selector=//button[contains(.,'Register')]
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'A valid email address is required')]    state=visible    timeout=5m

Creates a new user account via UI - Wrong password
    [Tags]    UI    FULL    NEGATIVE 
    ${randomNumber}    FakerLibrary.creditCardNumber
    ${random_letter}    FakerLibrary.Random Lowercase Letter
    ${random_email}    FakerLibrary.Email
    ${user_email}    Catenate    SEPARATOR=    ${random_letter}    ${random_email}
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    ${old_timeout} =    Set Browser Timeout    timeout=5m
    New Page    https://practice.expandtesting.com/notes/app/register
    Set Browser Timeout    ${old_timeout} 
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@name='name']    txt=${user_name}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Fill Text    selector=//input[@name='confirmPassword']    txt='e'+${user_password}
    Click    selector=//button[contains(.,'Register')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Passwords don')]    state=visible    timeout=5m


Log in as an existing user via UI
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
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
    Wait For Elements State    selector=//a[contains(.,'MyNotes')]    state=visible    timeout=5m
    Go To    https://practice.expandtesting.com/notes/app/profile
    # After concluding this method to grab user_id, other one catching it in the response was implemented. This one will remain here so both ways were presented.
    # ${user_id}    Get Attribute    selector=//input[@data-testid='user-id']    attribute=value    
    ${user_token}    LocalStorage Get Item   key=token 
    Create File    tests/fixtures/testdata-${randomNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Log in as an existing user via UI - Wrong password
    [Tags]    UI    FULL    NEGATIVE  
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    Go To    https://practice.expandtesting.com/notes/app/login
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@id='password']    txt='e'+${user_password}
    Click    selector=//button[contains(.,'Login')]
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'Incorrect email address or password')]    state=visible    timeout=5m
    logInUserViaUi(${randomNumber})
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Log in as an existing user via UI - Invalid e-mail 
    [Tags]    UI    FULL    NEGATIVE 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    Go To    https://practice.expandtesting.com/notes/app/login
    Fill Text    selector=//input[@id='email']    txt='@'+${user_email}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Click    selector=//button[contains(.,'Login')]
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'A valid email address is required')]    state=visible    timeout=5m
    logInUserViaUi(${randomNumber})
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Retrieve user profile information via UI
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_name_data}    Get Value From Json    ${data}    $.user_name
    ${user_name_str}    Convert JSON To String	 ${user_name_data}
    ${user_name}    Remove String    ${user_name_str}    [    ]    '    " 
    Go To    https://practice.expandtesting.com/notes/app/profile
    ${user_email_profile}    Get Attribute    selector=//input[@data-testid='user-email']    attribute=value
    ${user_name_profile}    Get Attribute    selector=//input[@data-testid='user-name']    attribute=value
    Should Be Equal    ${user_email}    ${user_email_profile}
    Should Be Equal    ${user_name}    ${user_name_profile}
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update user profile information via UI
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
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
    Wait For Elements State    selector=//div[@class='d-flex'][contains(.,'Profile updated successful')]    state=visible    timeout=5m
    ${user_company_profile}    Get Attribute    selector=//input[@data-testid='user-company']    attribute=value
    ${user_email_profile}    Get Attribute    selector=//input[@data-testid='user-email']    attribute=value
    ${user_name_profile}    Get Attribute    selector=//input[@data-testid='user-name']    attribute=value
    ${user_phone_profile}    Get Attribute    selector=//input[@data-testid='user-phone']    attribute=value
    Should Be Equal    ${updated_user_company}    ${user_company_profile}
    Should Be Equal    ${user_email}    ${user_email_profile}
    Should Be Equal    ${updated_user_name}    ${user_name_profile}
    Should Be Equal    ${updated_user_phone}    ${user_phone_profile}
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update user profile information via UI - Invalid company name
    [Tags]    UI    FULL    NEGATIVE  
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_name}    FakerLibrary.Name
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=10000000    max=99999999999999999999    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    Fill Text    selector=//input[@data-testid='user-company']    txt='e'
    Fill Text    selector=//input[@data-testid='user-name']    txt=${updated_user_name}
    Fill Text    selector=//input[@data-testid='user-phone']    txt=${updated_user_phone}
    Click    selector=//button[contains(.,'Update profile')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'company name should be between 4 and 30 characters')]    state=visible    timeout=5m
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update user profile information via UI - Invalid phone number 
    [Tags]    UI    FULL    NEGATIVE  
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_email_data}    Get Value From Json    ${data}    $.user_email
    ${user_email_str}    Convert JSON To String	 ${user_email_data}
    ${user_email}    Remove String    ${user_email_str}    [    ]    '    " 
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_name}    FakerLibrary.Name
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=1    max=2    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    Fill Text    selector=//input[@data-testid='user-company']    txt='e'
    Fill Text    selector=//input[@data-testid='user-name']    txt=${updated_user_name}
    Fill Text    selector=//input[@data-testid='user-phone']    txt=${updated_user_phone}
    Click    selector=//button[contains(.,'Update profile')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Phone number should be between 8 and 20 digits')]    state=visible    timeout=5m
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Change a user\'s password via UI 
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
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
    Wait For Elements State    selector=//div[@class='d-flex'][contains(.,'The password was successfully updated')]    state=visible    timeout=5m
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Change a user\'s password via UI - Type same password
    [Tags]    UI    FULL    NEGATIVE 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    ${user_new_password}    FakerLibrary.password
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Change password')]
    Fill Text    selector=//input[contains(@data-testid,'current-password')]    txt=${user_password}
    Fill Text    selector=//input[contains(@data-testid,'new-password')]    txt=${user_new_password}
    Fill Text    selector=//input[contains(@data-testid,'confirm-password')]    txt=${user_password}
    Click    selector=//button[contains(.,'Update password')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Passwords don')]    state=visible    timeout=5m
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Log out a user via UI
    [Tags]    UI    BASIC    FULL  
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Logout')]
    Wait For Elements State    selector=//a[contains(.,'Login')]    state=visible    timeout=5m
    logInUserViaUi(${randomNumber})
    deleteUserViaUi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Delete user account via UI
    [Tags]    UI    BASIC    FULL 
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${randomNumber}) 
    logInUserViaUi(${randomNumber})
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Delete Account')]
    Click    selector=//button[@data-testid='note-delete-confirm']
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'Your account has been deleted. You should create a new account to continue.')]    state=visible    timeout=5m
    Close Browser
    deleteJsonFile(${randomNumber})
