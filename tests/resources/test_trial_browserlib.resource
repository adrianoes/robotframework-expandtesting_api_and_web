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
    ${user_email}    FakerLibrary.Email
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
    ${note_description}    FakerLibrary.Sentence    nb_words=5
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
    ${user_name_data}    Get Value From Json    ${data}    $.user_name
    ${user_name_str}    Convert JSON To String	 ${user_name_data}
    ${user_name}    Remove String    ${user_name_str}    [    ]    '    " 
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    New Page    https://practice.expandtesting.com/notes/app/login
    Fill Text    selector=//input[@id='email']    txt=${user_email}
    Fill Text    selector=//input[@id='password']    txt=${user_password}
    Scroll To Element    selector=//button[contains(.,'Login')]
    Click    selector=//button[contains(.,'Login')]
    Wait For Elements State    selector=//a[contains(.,'MyNotes')]    state=visible
    New Page    https://practice.expandtesting.com/notes/app/profile
    Scroll To Element    selector=//input[@data-testid='user-id']
    ${user_id}    Get Attribute    selector=//input[@data-testid='user-id']    attribute=value    
    ${user_token}    LocalStorage Get Item   key=token 
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}

deleteUserViaUi(${bypassParalelismNumber})
    New Page    https://practice.expandtesting.com/notes/app/profile
    Scroll To Element    selector=//button[contains(.,'Delete Account')]
    Click    selector=//button[contains(.,'Delete Account')]
    Click    selector=//button[@data-testid='note-delete-confirm']
    Wait For Elements State    selector=//div[@data-testid='alert-message'][contains(.,'Your account has been deleted. You should create a new account to continue.')]    state=visible

 
createUserViaUi(${bypassParalelismNumber})   
    ${user_email}    FakerLibrary.Email
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    # Chrome presents an error only in github actions when tests are ran in normal browser. Something related to chromedriver. So if tests run in headless the problem disappear. 
    Open Browser    url=https://practice.expandtesting.com/notes/app/register    browser=chrome    options=add_argument("--no-sandbox")
    # To run the tests with UI, comment the line below and uncomment the line above. 
    # Open Browser    url=https://practice.expandtesting.com/notes/app/register    browser=headlesschrome    options=add_argument("--no-sandbox")
    Maximize Browser Window
    Scroll Element Into View    locator=//input[@id='email']
    Input Text    locator=//input[@id='email']    text=${user_email}
    Input Text    locator=//input[@name='name']    text=${user_name}
    Input Text    locator=//input[@id='password']    text=${user_password}
    Input Text    locator=//input[@name='confirmPassword']    text=${user_password}
    Scroll Element Into View    locator=//button[contains(.,'Register')]
    Click Button    locator=//button[contains(.,'Register')]
    Wait Until Element Is Visible    locator=//b[contains(.,'User account created successfully')]
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"user_email":"${user_email}","user_name":"${user_name}","user_password":"${user_password}"}

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
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    #Number of clicks in the Completed checkbox
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=5
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    Go To    url=https://practice.expandtesting.com/notes/app
    Click Element    locator=//div[@class='page-layout']
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Click Element    locator=//button[contains(.,'+ Add Note')]
    #It did not work with locator instead of xpath. Don't know why.
    Select From List By Value    xpath=//select[@data-testid='note-category']    ${note_category}
    IF    ${note_completed} == 1
        Wait Until Keyword Succeeds    1 min    1 sec    Select Checkbox    locator=//input[@data-testid='note-completed']
    END  
    Input Text    locator=//input[@data-testid='note-title']    text=${note_title}
    Input Text    locator=//textarea[@data-testid='note-description']    text=${note_description}
    Click Element    locator=//button[contains(.,'Create')]
    #Try to use Scroll Element To View to see if it works instead of Arrow Down key
    Click Element    locator=//div[@class='page-layout']
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
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    (//div[contains(.,'${note_title}')])[12]
    ${note_updated_at}    Get Text    //p[contains(@data-testid,'note-card-updated-at')]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    (//div[contains(.,'${note_description}${note_updated_at}')])[12]
    IF    ${note_completed} == 1
        Checkbox Should Be Selected    locator=//input[@data-testid='toggle-note-switch']
        #verify the header colors in the future
    ELSE
        Checkbox Should Not Be Selected    locator=//input[@data-testid='toggle-note-switch']
    END    
    Click Element    locator=//a[contains(.,'View')]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    (//div[contains(.,'${note_title}')])[10]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    //p[contains(.,'${note_description}')]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    //p[contains(.,'${note_updated_at}')]
    IF    ${note_completed} == 1
        Checkbox Should Be Selected    locator=//input[@type='checkbox']
    ELSE
        Checkbox Should Not Be Selected    locator=//input[@type='checkbox']
    END
    Go To    url=https://practice.expandtesting.com/notes/app/
    Click Element    locator=//div[@class='page-layout']
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    Press Keys  None  ARROW_DOWN
    #Not able to get the note id part of the url because iframe took over. I can use get all notes request when mixing ui and api tests.
    # Got note id using Get Element Attribute keyword
    ${note_id_full_url_extension}    Get Element Attribute    locator=//a[contains(.,'View')]    attribute=href
    ${note_id}    Remove String    ${note_id_full_url_extension}    https://practice.expandtesting.com/notes/app/notes/
    ${note_id_color}    Get Element Attribute    locator=//div[@data-testid='note-card-title']    attribute=style
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
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"note_category":"${note_category}","note_completed":"${note_completed}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}
    