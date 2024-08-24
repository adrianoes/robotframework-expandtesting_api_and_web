*** Settings ***

Library    Browser
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary

*** Keywords ***

logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
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
    ${data}    Create Dictionary    email=${user_email}    password=${user_password}
    ${header}    Create Dictionary    content-type=application/x-www-form-urlencoded
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseLU}    POST On Session    alias=expandtesting     url=/users/login    data=${data}   expected_status=200  
    ${json_responseLU}    Convert String To Json    ${responseLU.content}  
    ${user_email_ob}    Get Value From Json    ${json_responseLU}    data.email
    ${user_email_str}    Convert JSON To String	 ${user_email_ob}
    ${user_email_rsp}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseLU}    data.id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_name_ob}    Get Value From Json    ${json_responseLU}    data.name
    ${user_name_str}    Convert JSON To String	 ${user_name_ob}
    ${user_name_rsp}    Remove String    ${user_name_str}    [    ]    '    "  
    ${user_password_ob}    Get Value From Json    ${json_responseLU}    data.password
    ${user_password_str}    Convert JSON To String	 ${user_password_ob}
    ${user_password_rsp}    Remove String    ${user_password_str}    [    ]    '    "      
    ${user_token_ob}    Get Value From Json    ${json_responseLU}    data.token
    ${user_token_str}    Convert JSON To String	 ${user_token_ob}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    Should Be Equal    ${user_email}    ${user_email_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp}
    Should Be Equal    ${user_name}    ${user_name_rsp}   
    Should Be Equal    Login successful    ${responseLU.json()['message']}
    Log To Console    ${responseLU.json()['message']}
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}

deleteUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseDU}    DELETE On Session    alias=expandtesting     url=/users/delete-account    headers=${headers}    expected_status=200    
    ${json_responseDU}    Convert String To Json    ${responseDU.content} 
    Should Be Equal    Account successfully deleted    ${responseDU.json()['message']}
    Log To Console    ${responseDU.json()['message']}

deleteJsonFile(${bypassParalelismNumber})
    Remove File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    Log To Console    Json file deleted

createUserViaApi(${bypassParalelismNumber})
    ${old_timeout} =    Set Browser Timeout    1m 30 seconds
    Set Browser Timeout    ${old_timeout}
    ${random_email}    FakerLibrary.Email
    ${user_email}    Catenate    SEPARATOR=    ${random_letter}    ${random_email}
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    ${data}    Create Dictionary    email=${user_email}    name=${user_name}    password=${user_password}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCU}    POST On Session    alias=expandtesting     url=/users/register    data=${data}    expected_status=201
    ${json_responseCU}    Convert String To Json    ${responseCU.content} 
    # Object is got like ['xxxxxxxxxxxxxxxxxxxxxxxx']", so code block below is needed to remove unnecessary characters, letting be only xxxxxxxxxxxxxxxxxxxxxxxx
    ${user_email_ob}    Get Value From Json    ${json_responseCU}    data.email
    ${user_email_str}    Convert JSON To String	 ${user_email_ob}
    ${user_email_rsp}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_name_ob}    Get Value From Json    ${json_responseCU}    data.name
    ${user_name_str}    Convert JSON To String	 ${user_name_ob}
    ${user_name_rsp}    Remove String    ${user_name_str}    [    ]    '    " 
    Should Be Equal    ${user_email}    ${user_email_rsp}
    Should Be Equal    ${user_name}    ${user_name_rsp}   
    Should Be Equal    User account created successfully    ${responseCU.json()['message']}
    ${user_id_ob}    Get Value From Json    ${json_responseCU}    data.id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    "  
    Log To Console    ${responseCU.json()['message']}
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}
    
deleteNoteViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${note_id_data}    Get Value From Json    ${data}    $.note_id
    ${note_id_str}    Convert JSON To String	 ${note_id_data}
    ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseDN}    DELETE On Session    alias=expandtesting     url=/notes/${note_id}    headers=${headers}    expected_status=200    
    ${json_responseDN}    Convert String To Json    ${responseDN.content} 
    Should Be Equal    Note successfully deleted    ${responseDN.json()['message']}
    Log To Console    ${responseDN.json()['message']}

createNoteViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${note_category}    FakerLibrary.Random Element    elements=('Home', 'Work', 'Personal')
    ${note_description}    FakerLibrary.Sentence    nb_words=4
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    ${data}    Create Dictionary    category=${note_category}    description=${note_description}    title=${note_title}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCN}    POST On Session    alias=expandtesting     url=/notes    data=${data}    headers=${headers}    expected_status=200   
    ${json_responseCN}    Convert String To Json    ${responseCN.content}
    ${note_category_ob}    Get Value From Json    ${json_responseCN}    data.category
    ${note_category_str}    Convert JSON To String	 ${note_category_ob}
    ${note_category_rsp}    Remove String    ${note_category_str}    [    ]    '    " 
    ${note_description_ob}    Get Value From Json    ${json_responseCN}    data.description
    ${note_description_str}    Convert JSON To String	 ${note_description_ob}
    ${note_description_rsp}    Remove String    ${note_description_str}    [    ]    '    "     
    ${note_title_ob}    Get Value From Json    ${json_responseCN}    data.title
    ${note_title_str}    Convert JSON To String	 ${note_title_ob}
    ${note_title_rsp}    Remove String    ${note_title_str}    [    ]    '    " 
    ${note_id_ob}    Get Value From Json    ${json_responseCN}    data.id
    ${note_id_str}    Convert JSON To String	 ${note_id_ob}
    ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseCN}    data.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    Should Be Equal    ${note_category}    ${note_category_rsp}
    Should Be Equal    ${note_description}    ${note_description_rsp}
    Should Be Equal    ${note_title}    ${note_title_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp} 
    Should Be Equal    Note successfully created    ${responseCN.json()['message']}
    Log To Console    ${responseCN.json()['message']}
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"note_category":"${note_category}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_id":"${user_id}","user_token":"${user_token}"}

logInUserViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
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
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}

deleteUserViaUi(${bypassParalelismNumber})
    Go To    https://practice.expandtesting.com/notes/app/profile
    Click    selector=//button[contains(.,'Delete Account')]
    Click    selector=//button[@data-testid='note-delete-confirm']
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'Your account has been deleted. You should create a new account to continue.')]    state=visible    timeout=5m

 
createUserViaUi(${bypassParalelismNumber}) 
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
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}

createNoteViaUi(${bypassParalelismNumber}) 
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
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
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    #Number of clicks in the Completed checkbox
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=4
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    Go To    https://practice.expandtesting.com/notes/app
    Click    selector=//div[@class='page-layout']
    Click    selector=//button[contains(.,'+ Add Note')]
    Select Options By    data-testid=note-category    value    ${note_category}    
    IF    ${note_completed} == 1
        Check Checkbox    selector=//input[@data-testid='note-completed']
    END  
    Fill Text    selector=//input[@data-testid='note-title']    txt=${note_title}
    Fill Text    selector=//textarea[@data-testid='note-description']    txt=${note_description}
    Click    selector=//button[contains(.,'Create')]
    Wait For Elements State    selector=(//div[contains(.,'${note_title}')])[12]    state=visible    timeout=5m
    ${note_updated_at}    Get Text    selector=//p[contains(@data-testid,'note-card-updated-at')]
    Wait For Elements State    selector=(//div[contains(.,'${note_description}${note_updated_at}')])[12]    state=visible    timeout=5m
    IF    ${note_completed} == 1
        Scroll To Element    selector=//input[@data-testid='toggle-note-switch']
        Wait For Elements State    selector=//input[@data-testid='toggle-note-switch']    state=checked    timeout=5m
        #verify the header colors in the future
    ELSE
        Scroll To Element    selector=//input[@data-testid='toggle-note-switch']
        Wait For Elements State    selector=//input[@data-testid='toggle-note-switch']    state=unchecked    timeout=5m
    END    
    Click    selector=//a[contains(.,'View')]
    Wait For Elements State    selector=(//div[contains(.,'${note_title}')])[10]    state=visible    timeout=5m
    Wait For Elements State    selector=//p[contains(.,'${note_description}')]    state=visible    timeout=5m
    Wait For Elements State    selector=//p[contains(.,'${note_updated_at}')]    state=visible    timeout=5m
    IF    ${note_completed} == 1
        Scroll To Element    selector=//input[@type='checkbox'] 
        Wait For Elements State    selector=//input[@type='checkbox']    state=checked    timeout=5m
    ELSE
        Scroll To Element    selector=//input[@type='checkbox'] 
        Wait For Elements State    selector=//input[@type='checkbox']    state=unchecked    timeout=5m
    END
    Go To    https://practice.expandtesting.com/notes/app/
    ${note_id_full_url_extension}    Get Attribute    selector=//a[contains(.,'View')]    attribute=href
    ${note_id}    Remove String    ${note_id_full_url_extension}    https://practice.expandtesting.com/notes/app/notes/
    ${note_id_color}    Get Attribute    selector=//div[@data-testid='note-card-title']    attribute=style
    IF    "${note_completed}" == "1"
        Should Be Equal    ${note_id_color}    background-color: rgba(40, 46, 41, 0.6); color: rgb(255, 255, 255); 
    ELSE IF    "Home" == "${note_category}"
        Should Be Equal    ${note_id_color}    background-color: rgb(255, 145, 0); color: rgb(255, 255, 255);
    ELSE IF    "Personal" == "${note_category}"
        Should Be Equal    ${note_id_color}    background-color: rgb(50, 140, 160); color: rgb(255, 255, 255);
    ELSE
        Should Be Equal    ${note_id_color}    background-color: rgb(92, 107, 192); color: rgb(255, 255, 255);
    END 
    # Log To Console    ${note_id_color}
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"note_category":"${note_category}","note_completed":"${note_completed}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}

logInUserViaUi_when_user_was_created_via_api(${bypassParalelismNumber})
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
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    ${old_timeout} =    Set Browser Timeout    timeout=5m
    New Page    https://practice.expandtesting.com/notes/app/login
    Set Browser Timeout    ${old_timeout} 
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Click    selector=//button[contains(.,'Login')]
    Wait For Elements State    selector=//a[contains(.,'MyNotes')]    state=visible    timeout=5m
    Go To    https://practice.expandtesting.com/notes/app/profile
    ${user_id}    Get Attribute    selector=//input[@data-testid='user-id']    attribute=value    
    ${user_token}    LocalStorage Get Item   key=token 
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
