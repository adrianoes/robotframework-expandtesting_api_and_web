*** Settings ***

Resource    ../resources/test.resource
Library    Browser     
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary  
Library    Collections

*** Test Cases ***

Create a new note via API and WEB
    [Tags]    API_AND_WEB    BASIC    FULL
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
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
    Create File    tests/fixtures/testdata-${randomNumber}.json	{"note_category":"${note_category}","note_completed":"${note_completed}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}","user_token":"${user_token}"}
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Create a new note via API and WEB - Invalid title
    [Tags]    API_AND_WEB    FULL    NEGATIVE
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
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
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    #Number of clicks in the Completed checkbox
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=4
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    ${old_timeout} =    Set Browser Timeout    timeout=5m
    Go To    https://practice.expandtesting.com/notes/app
    Set Browser Timeout    ${old_timeout}
    Click    selector=//div[@class='page-layout']
    Click    selector=//button[@data-testid='add-new-note']
    Select Options By    data-testid=note-category    value    ${note_category}    
    IF    ${note_completed} == 1
        Check Checkbox    selector=//input[@data-testid='note-completed']
    END  
    Fill Text    selector=//input[@data-testid='note-title']    txt='e'
    Fill Text    selector=//textarea[@data-testid='note-description']    txt=${note_description}
    Click    selector=//button[contains(.,'Create')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Title should be between 4 and 100 characters')]    state=visible    timeout=5m
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Create a new note via API and WEB - Invalid description
    [Tags]    API_AND_WEB    FULL    NEGATIVE
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
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
    Fill Text    selector=//textarea[@data-testid='note-description']    txt='e'
    Click    selector=//button[contains(.,'Create')]
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Description should be between 4 and 1000 characters')]    state=visible    timeout=5m
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Get all notes via API and WEB
    [Tags]    API_AND_WEB    BASIC    FULL
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    #token us read for when we want to use api custom commands to help ui tests.
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${note_category_last_element}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    ${arrayCategory}    Create List    ${note_category_last_element}    Home   Work    Personal        
    ${arrayCompleted}    Create List    1    0    0    0
    ${note_description_1}    FakerLibrary.Sentence  nb_words=4
    ${note_description_2}    FakerLibrary.Sentence  nb_words=4
    ${note_description_3}    FakerLibrary.Sentence  nb_words=4
    ${note_description_4}    FakerLibrary.Sentence  nb_words=4
    ${arrayDescription}    Create List    ${note_description_1}    ${note_description_2}    ${note_description_3}    ${note_description_4}
    ${note_title_1}    FakerLibrary.Sentence  nb_words=3
    ${note_title_2}    FakerLibrary.Sentence  nb_words=3
    ${note_title_3}    FakerLibrary.Sentence  nb_words=3
    ${note_title_4}    FakerLibrary.Sentence  nb_words=3
    ${arrayTitle}    Create List    ${note_title_1}    ${note_title_2}    ${note_title_3}    ${note_title_4}
    ${arrayNoteUpdatedAt}    Create List    ${0}    ${0}    ${0}    ${0}
    ${arrayNoteId}    Create List    ${0}    ${0}    ${0}    ${0}
    FOR    ${i}    IN RANGE    ${4}        
        ${note_category}    Get From List    ${arrayCategory}    ${i}       
        ${note_completed}    Get From List    ${arrayCompleted}    ${i}
        ${note_description}    Get From List    ${arrayDescription}    ${i}
        ${note_title}    Get From List    ${arraytitle}    ${i}
        Go To    https://practice.expandtesting.com/notes/app
        Click    selector=//div[@class='page-layout']
        ${old_timeout} =    Set Browser Timeout    timeout=5m
        Click    selector=//button[contains(.,'+ Add Note')]
        Set Browser Timeout    ${old_timeout} 
        Select Options By    data-testid=note-category    value    ${note_category}    
        IF    ${note_completed} == 1
            Check Checkbox    selector=//input[@data-testid='note-completed']
        END  
        Fill Text    selector=//input[@data-testid='note-title']    txt=${note_title}
        Fill Text    selector=//textarea[@data-testid='note-description']    txt=${note_description}
        Click    selector=//button[contains(.,'Create')]    
        Log To Console    ${note_category}
        Log To Console    ${note_completed}
    END       
    FOR    ${i}    IN RANGE    1    5                
        ${note_updated_at}    Get Text    xpath=(//p[@data-testid='note-card-updated-at'])[5-${i}]  
        Set List Value     ${arrayNoteUpdatedAt}    ${i-1}    ${note_updated_at} 
        Log To Console    ${note_updated_at} 
        Log To Console    ${arrayNoteUpdatedAt} 
    END
    FOR    ${i}    IN RANGE    1    5   
    #Still don't know why it must be 5 here instead of 4. Contact me if you know. Get -i vlue so starts from the end of the list, which has the first created values. 
        ${note_category}    Get From List    ${arrayCategory}    -${i}      
        ${note_completed}    Get From List    ${arrayCompleted}    -${i}
        ${note_description}    Get From List    ${arrayDescription}    -${i}
        ${note_title}    Get From List    ${arraytitle}    -${i}      
        ${note_updated_at}    Get From List    ${arrayNoteUpdatedAt}    -${i}
        Wait For Elements State    (//div[@data-testid='note-card-title'])[${i}][contains(.,'${note_title}')]    state=visible    timeout=5m
        ${note_id_color}    Get Attribute    selector=(//div[@data-testid='note-card-title'])[${i}][contains(.,'${note_title}')]    attribute=style
        IF    "${note_completed}" == "1"
            Should Be Equal    ${note_id_color}    background-color: rgba(40, 46, 41, 0.6); color: rgb(255, 255, 255); 
        ELSE IF    "Home" == "${note_category}"
            Should Be Equal    ${note_id_color}    background-color: rgb(255, 145, 0); color: rgb(255, 255, 255);
        ELSE IF    "Personal" == "${note_category}"
            Should Be Equal    ${note_id_color}    background-color: rgb(50, 140, 160); color: rgb(255, 255, 255);
        ELSE
            Should Be Equal    ${note_id_color}    background-color: rgb(92, 107, 192); color: rgb(255, 255, 255);
        END 
        Wait For Elements State    selector=(//div[@class='card-body d-flex flex-column'])[${i}][contains(.,'${note_description}${note_updated_at}')]    state=visible    timeout=5m
        IF    ${note_completed} == 1
            Wait For Elements State    selector=(//input[@type='checkbox'])[${i}]    state=checked    timeout=5m
        #verify the header colors in the future
        ELSE
            Wait For Elements State    selector=(//input[@type='checkbox'])[${i}]    state=unchecked    timeout=5m
        END 
    END
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update an existing note via API and WEB
    [Tags]    API_AND_WEB    BASIC    FULL
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
    createNoteViaWeb(${randomNumber})
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=5
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    Go To    https://practice.expandtesting.com/notes/app
    Click    selector=//button[@data-testid='note-edit']
    Select Options By    data-testid=note-category    value    ${note_category}
    IF    ${note_completed} == 1
        Check Checkbox    selector=//input[@data-testid='note-completed']
    END 
    Fill Text    selector=//input[@data-testid='note-title']    txt=${note_title}
    Fill Text    selector=//textarea[@data-testid='note-description']    txt=${note_description}
    Click    selector=//button[@data-testid='note-submit']
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
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update an existing note via API and WEB - Invalid title
    [Tags]    API_AND_WEB    FULL    NEGATIVE
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
    createNoteViaWeb(${randomNumber})
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=5
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    Go To    https://practice.expandtesting.com/notes/app
    Click    selector=//button[@data-testid='note-edit']
    Select Options By    data-testid=note-category    value    ${note_category}
    IF    ${note_completed} == 1
        Check Checkbox    selector=//input[@data-testid='note-completed']
    END 
    Fill Text    selector=//input[@data-testid='note-title']    txt='e'
    Fill Text    selector=//textarea[@data-testid='note-description']    txt=${note_description}
    Click    selector=//button[@data-testid='note-submit']
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Title should be between 4 and 100 characters')]    state=visible    timeout=5m
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update an existing note via API and WEB - Invalid description
    [Tags]    API_AND_WEB    FULL    NEGATIVE
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
    createNoteViaWeb(${randomNumber})
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=5
    ${note_title}    FakerLibrary.Sentence    nb_words=3
    Go To    https://practice.expandtesting.com/notes/app
    Click    selector=//button[@data-testid='note-edit']
    Select Options By    data-testid=note-category    value    ${note_category}
    IF    ${note_completed} == 1
        Check Checkbox    selector=//input[@data-testid='note-completed']
    END 
    Fill Text    selector=//input[@data-testid='note-title']    txt=${note_title}
    Fill Text    selector=//textarea[@data-testid='note-description']    txt='e'
    Click    selector=//button[@data-testid='note-submit']
    Wait For Elements State    selector=//div[@class='invalid-feedback'][contains(.,'Description should be between 4 and 1000 characters')]    state=visible    timeout=5m
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Update the completed status of a note via API and WEB
    [Tags]    API_AND_WEB    BASIC    FULL
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber})
    createNoteViaWeb(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${note_category_data}    Get Value From Json    ${data}    $.note_category
    ${note_category_str}    Convert JSON To String	 ${note_category_data}
    ${note_category}    Remove String    ${note_category_str}    [    ]    '    "    
    Go To    https://practice.expandtesting.com/notes/app
    ${checkbox_state_initial}    Get Checkbox State    selector=//input[@data-testid='toggle-note-switch']
    Log To Console    ${checkbox_state_initial}
    ${note_id_color_initial}    Get Attribute    selector=//div[@data-testid='note-card-title']    attribute=style
    Log To Console    ${note_id_color_initial}
    Click    selector=//input[@data-testid='toggle-note-switch']
    #I think that robot was so fast and did not give enought time for style to change color here, so I input reload key
    # Reload
    ${checkbox_state_final}    Get Checkbox State    selector=//input[@data-testid='toggle-note-switch']
    Log To Console    ${checkbox_state_final}
    ${note_id_color_final}    Get Attribute    selector=//div[@data-testid='note-card-title']    attribute=style
    Log To Console    ${note_id_color_final}
    IF    ${checkbox_state_final} == True
        Log To Console    Checkeddddddddddd
        Should Be Equal    ${note_id_color_final}    background-color: rgba(40, 46, 41, 0.6); color: rgb(255, 255, 255); 
    ELSE IF    "Home" == "${note_category}"
        Log To Console    Uncheckeddddddddd
        Should Be Equal    ${note_id_color_final}    background-color: rgb(255, 145, 0); color: rgb(255, 255, 255);
    ELSE IF    "Personal" == "${note_category}"
        Log To Console    Uncheckeddddddddd
        Should Be Equal    ${note_id_color_final}    background-color: rgb(50, 140, 160); color: rgb(255, 255, 255);
    ELSE
        Log To Console    Uncheckeddddddddd
        Should Be Equal    ${note_id_color_final}    background-color: rgb(92, 107, 192); color: rgb(255, 255, 255);
    END 
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})

Delete a note via API and WEB
    [Tags]    API_AND_WEB    BASIC    FULL
    ${randomNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${randomNumber}) 
    logInUserViaWeb_when_user_was_created_via_api(${randomNumber}) 
    createNoteViaWeb(${randomNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${randomNumber}.json
    ${note_title_data}    Get Value From Json    ${data}    $.note_title
    ${note_title_str}    Convert JSON To String	 ${note_title_data}
    ${note_title}    Remove String    ${note_title_str}    [    ]    '    " 
    Go To    https://practice.expandtesting.com/notes/app/
    Click    selector=//button[@data-testid='note-delete']
    Click    selector=//button[@data-testid='note-delete-confirm']
    #did not work when selector is coded instead of xpath
    Get Element Count    xpath=(//div[contains(.,'${note_title}')])[12]  ==  0           
    deleteUserViaApi(${randomNumber})
    Close Browser
    deleteJsonFile(${randomNumber})