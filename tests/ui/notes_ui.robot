*** Settings ***

Resource    ../resources/test.resource

Library    Browser    
 
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
    ${note_category}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    #Number of clicks in the Completed checkbox
    ${note_completed}    FakerLibrary.Random Int    1    2    1
    ${note_description}    FakerLibrary.Sentence    nb_words=5
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
    Wait For Elements State    selector=(//div[contains(.,'${note_title}')])[12]    state=visible
    ${note_updated_at}    Get Text    selector=//p[contains(@data-testid,'note-card-updated-at')]
    Wait For Elements State    selector=(//div[contains(.,'${note_description}${note_updated_at}')])[12]    state=visible
    IF    ${note_completed} == 1
        Wait For Elements State    selector=//input[@data-testid='toggle-note-switch']    state=checked
        #verify the header colors in the future
    ELSE
        Wait For Elements State    selector=//input[@data-testid='toggle-note-switch']    state=unchecked
    END    
    Click    selector=//a[contains(.,'View')]
    Wait For Elements State    selector=(//div[contains(.,'${note_title}')])[10]    state=visible
    Wait For Elements State    selector=//p[contains(.,'${note_description}')]    state=visible
    Wait For Elements State    selector=//p[contains(.,'${note_updated_at}')]    state=visible
    IF    ${note_completed} == 1
        Wait For Elements State    selector=//input[@type='checkbox']    state=checked
    ELSE
        Wait For Elements State    selector=//input[@type='checkbox']    state=unchecked
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
    Create File    tests/fixtures/testdata-${bypassParalelismNumber}.json	{"note_category":"${note_category}","note_completed":"${note_completed}","note_description":"${note_description}","note_id":"${note_id}","note_title":"${note_title}","user_email":"${user_email}","user_id":"${user_id}","user_name":"${user_name}","user_password":"${user_password}"}
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Get all notes via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber})
    logInUserViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    #token us read for when we want to use api custom commands to help ui tests.
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${note_category_last_element}    FakerLibrary.Random Element    elements=("Home", "Personal", "Work")
    ${arrayCategory}    Create List    ${note_category_last_element}    Home   Work    Personal        
    ${arrayCompleted}    Create List    1    0    0    0
    ${note_description_1}    FakerLibrary.Sentence  nb_words=5
    ${note_description_2}    FakerLibrary.Sentence  nb_words=5
    ${note_description_3}    FakerLibrary.Sentence  nb_words=5
    ${note_description_4}    FakerLibrary.Sentence  nb_words=5
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
        Click    selector=//button[contains(.,'+ Add Note')]
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
        Wait For Elements State    (//div[@data-testid='note-card-title'])[${i}][contains(.,'${note_title}')]    state=visible
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
        Wait For Elements State    selector=(//div[@class='card-body d-flex flex-column'])[${i}][contains(.,'${note_description}${note_updated_at}')]    state=visible
        IF    ${note_completed} == 1
            Wait For Elements State    selector=(//input[@type='checkbox'])[${i}]    state=checked
        #verify the header colors in the future
        ELSE
            Wait For Elements State    selector=(//input[@type='checkbox'])[${i}]    state=unchecked
        END 
    END
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})

Delete a note via UI
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaUi(${bypassParalelismNumber}) 
    logInUserViaUi(${bypassParalelismNumber}) 
    createNoteViaUi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${note_title_data}    Get Value From Json    ${data}    $.note_title
    ${note_title_str}    Convert JSON To String	 ${note_title_data}
    ${note_title}    Remove String    ${note_title_str}    [    ]    '    " 
    Go To    https://practice.expandtesting.com/notes/app/
    Click    selector=//button[@data-testid='note-delete']
    Click    selector=//button[@data-testid='note-delete-confirm']
    #did not work when selector is coded instead of xpath
    Get Element Count    xpath=(//div[contains(.,'${note_title}')])[12]  ==  0           
    deleteUserViaUi(${bypassParalelismNumber})
    Close Browser
    deleteJsonFile(${bypassParalelismNumber})