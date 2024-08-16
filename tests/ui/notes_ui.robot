*** Settings ***

Resource    ../resources/test.resource
Library    SeleniumLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary  
Library    Collections  

*** Test Cases ***

Create a new note via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
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
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Work", "Personal")
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
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    (//div[contains(.,'${note_title}')])[10]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    //p[contains(.,'${note_description}')]
    Wait Until Keyword Succeeds    1 min    1 sec    Wait Until Element Is Visible    //p[contains(.,'${note_updated_at}')]
    IF    ${note_completed} == 1
        Checkbox Should Be Selected    locator=//input[@type='checkbox']
    ELSE
        Checkbox Should Not Be Selected    locator=//input[@type='checkbox']
    END
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
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"note_category":"${note_category}","note_completed":"${note_completed}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})
