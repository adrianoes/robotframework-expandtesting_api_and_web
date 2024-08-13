*** Settings ***

Resource    ../resources/test.resource
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary
Library    Collections

*** Test Cases ***

Creates a new note via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
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
    #This command will be kept for studying purpose only since there is already a deleteUserViaApi to delete user right away.
    deleteNoteViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Get all notes via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${arrayCategory}    Create List    Home    Home   Work    Personal
    ${arrayCompleted}    Create List    false    false    false    true
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
    ${arrayNoteId}    Create List    ${0}    ${0}    ${0}    ${0}
    FOR    ${i}    IN RANGE    ${4}        
        ${note_category}    Get From List    ${arrayCategory}    ${i}       
        ${note_completed}    Get From List    ${arrayCompleted}    ${i}
        ${note_description}    Get From List    ${arrayDescription}    ${i}
        ${note_title}    Get From List    ${arraytitle}    ${i}
        ${data}    Create Dictionary    category=${note_category}    completed=${note_completed}   description=${note_description}    title=${note_title}
        ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
        Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
        ${responseCNs}    POST On Session    alias=expandtesting     url=/notes    data=${data}    headers=${headers}    expected_status=200   
        ${json_responseCNs}    Convert String To Json    ${responseCNs.content}
        ${note_category_ob}    Get Value From Json    ${json_responseCNs}    data.category
        ${note_category_str}    Convert JSON To String	 ${note_category_ob}
        ${note_category_rsp}    Remove String    ${note_category_str}    [    ]    '    " 
        ${note_completed_ob}    Get Value From Json    ${json_responseCNs}    data.completed
        ${note_completed_str}    Convert JSON To String	 ${note_completed_ob}
        ${note_completed_rsp}    Remove String    ${note_completed_str}    [    ]    '    " 
        ${note_description_ob}    Get Value From Json    ${json_responseCNs}    data.description
        ${note_description_str}    Convert JSON To String	 ${note_description_ob}
        ${note_description_rsp}    Remove String    ${note_description_str}    [    ]    '    "     
        ${note_title_ob}    Get Value From Json    ${json_responseCNs}    data.title
        ${note_title_str}    Convert JSON To String	 ${note_title_ob}
        ${note_title_rsp}    Remove String    ${note_title_str}    [    ]    '    " 
        ${note_id_ob}    Get Value From Json    ${json_responseCNs}    data.id
        ${note_id_str}    Convert JSON To String	 ${note_id_ob}
        ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
        ${user_id_ob}    Get Value From Json    ${json_responseCNs}    data.user_id
        ${user_id_str}    Convert JSON To String	 ${user_id_ob}
        ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
        Should Be Equal    ${note_category}    ${note_category_rsp}
        Should Be Equal    ${note_completed}    ${note_completed_rsp}
        Should Be Equal    ${note_description}    ${note_description_rsp}
        Set List Value    ${arrayNoteId}    ${i}    ${note_id}    
        Should Be Equal    ${note_title}    ${note_title_rsp}
        Should Be Equal    ${user_id}    ${user_id_rsp} 
        Should Be Equal    Note successfully created    ${responseCNs.json()['message']}
        Log To Console    ${responseCNs.json()['message']}   
    END
    # Log To Console    ${arrayNoteId} 
    FOR    ${i}    IN RANGE    ${4}         
        ${note_category}    Get From List    ${arrayCategory}    ${i}
        ${note_completed}    Get From List    ${arrayCompleted}    ${i}
        ${note_description}    Get From List    ${arrayDescription}    ${i}
        ${note_id}    Get From List    ${arrayNoteId}    ${i} 
        ${note_title}    Get From List    ${arrayTitle}    ${i} 
        ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
        Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
        ${responseGNs}    GET On Session    alias=expandtesting     url=/notes/${note_id}    headers=${headers}    expected_status=200    
        ${json_responseGNs}    Convert String To Json    ${responseGNs.content}
        ${note_category_ob}    Get Value From Json    ${json_responseGNs}    data.category
        ${note_category_str}    Convert JSON To String	 ${note_category_ob}
        ${note_category_rsp}    Remove String    ${note_category_str}    [    ]    '    " 
        ${note_completed_ob}    Get Value From Json    ${json_responseGNs}    data.completed
        ${note_completed_str}    Convert JSON To String	 ${note_completed_ob}
        ${note_completed_rsp}    Remove String    ${note_completed_str}    [    ]    '    " 
        ${note_description_ob}    Get Value From Json    ${json_responseGNs}    data.description
        ${note_description_str}    Convert JSON To String	 ${note_description_ob}
        ${note_description_rsp}    Remove String    ${note_description_str}    [    ]    '    "     
        ${note_title_ob}    Get Value From Json    ${json_responseGNs}    data.title
        ${note_title_str}    Convert JSON To String	 ${note_title_ob}
        ${note_title_rsp}    Remove String    ${note_title_str}    [    ]    '    " 
        ${note_id_ob}    Get Value From Json    ${json_responseGNs}    data.id
        ${note_id_str}    Convert JSON To String	 ${note_id_ob}
        ${note_id_rsp}    Remove String    ${note_id_str}    [    ]    '    " 
        ${user_id_ob}    Get Value From Json    ${json_responseGNs}    data.user_id
        ${user_id_str}    Convert JSON To String	 ${user_id_ob}
        ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
        Should Be Equal    ${note_category}    ${note_category_rsp}
        Should Be Equal    ${note_completed}    ${note_completed_rsp}
        Should Be Equal    ${note_description}    ${note_description_rsp}
        Should Be Equal    ${note_id}    ${note_id_rsp}      
        Should Be Equal    ${note_title}    ${note_title_rsp}
        Should Be Equal    ${user_id}    ${user_id_rsp} 
        Should Be Equal    Note successfully retrieved    ${responseGNs.json()['message']}
        Log To Console    ${responseGNs.json()['message']}
    END    
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Get note by ID via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    createNoteViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${note_category_data}    Get Value From Json    ${data}    $.note_category
    ${note_category_str}    Convert JSON To String	 ${note_category_data}
    ${note_category}    Remove String    ${note_category_str}    [    ]    '    " 
    ${note_description_data}    Get Value From Json    ${data}    $.note_description
    ${note_description_str}    Convert JSON To String	 ${note_description_data}
    ${note_description}    Remove String    ${note_description_str}    [    ]    '    " 
    ${note_id_data}    Get Value From Json    ${data}    $.note_id
    ${note_id_str}    Convert JSON To String	 ${note_id_data}
    ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
    ${note_title_data}    Get Value From Json    ${data}    $.note_title
    ${note_title_str}    Convert JSON To String	 ${note_title_data}
    ${note_title}    Remove String    ${note_title_str}    [    ]    '    " 
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseGN}    GET On Session    alias=expandtesting     url=/notes/${note_id}    headers=${headers}    expected_status=200    
    ${json_responseGN}    Convert String To Json    ${responseGN.content} 
    Should Be Equal    Note successfully retrieved    ${responseGN.json()['message']}
    Log To Console    ${responseGN.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Update an existing note via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    createNoteViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json    
    ${note_category_data}    Get Value From Json    ${data}    $.note_category
    ${note_category_str}    Convert JSON To String	 ${note_category_data}
    ${note_category}    Remove String    ${note_category_str}    [    ]    '    " 
    #Did not figure it out how to randomize boolean values and pass it to the request body. Until then, it goes hardcoded.
    ${note_completed}    Set Variable    false
    ${note_description_data}    Get Value From Json    ${data}    $.note_description
    ${note_description_str}    Convert JSON To String	 ${note_description_data}
    ${note_description}    Remove String    ${note_description_str}    [    ]    '    " 
    ${note_id_data}    Get Value From Json    ${data}    $.note_id
    ${note_id_str}    Convert JSON To String	 ${note_id_data}
    ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
    ${note_title_data}    Get Value From Json    ${data}    $.note_title
    ${note_title_str}    Convert JSON To String	 ${note_title_data}
    ${note_title}    Remove String    ${note_title_str}    [    ]    '    " 
    ${updated_note_description}    FakerLibrary.Sentence    nb_words=5
    ${updated_note_title}    FakerLibrary.Sentence    nb_words=3
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${data}    Create Dictionary    category=${note_category}    completed=${note_completed}   description=${note_description}    title=${note_title}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseUN}    PUT On Session    alias=expandtesting     url=/notes/${note_id}    data=${data}    headers=${headers}    expected_status=200   
    ${json_responseUN}    Convert String To Json    ${responseUN.content}
    ${note_category_ob}    Get Value From Json    ${json_responseUN}    data.category
    ${note_category_str}    Convert JSON To String	 ${note_category_ob}
    ${note_category_rsp}    Remove String    ${note_category_str}    [    ]    '    " 
    ${note_category_rsp_bool}    Convert To Boolean    ${note_category_rsp}    
    ${note_completed_ob}    Get Value From Json    ${json_responseUN}    data.completed
    ${note_completed_str}    Convert JSON To String	 ${note_completed_ob}
    ${note_completed_rsp}    Remove String    ${note_completed_str}    [    ]    '    " 
    ${note_description_ob}    Get Value From Json    ${json_responseUN}    data.description
    ${note_description_str}    Convert JSON To String	 ${note_description_ob}
    ${note_description_rsp}    Remove String    ${note_description_str}    [    ]    '    "   
    ${note_id_ob}    Get Value From Json    ${json_responseUN}    data.id
    ${note_id_str}    Convert JSON To String	 ${note_id_ob}
    ${note_id_rsp}    Remove String    ${note_id_str}    [    ]    '    " 
    ${note_title_ob}    Get Value From Json    ${json_responseUN}    data.title
    ${note_title_str}    Convert JSON To String	 ${note_title_ob}
    ${note_title_rsp}    Remove String    ${note_title_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseUN}    data.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    Should Be Equal    ${note_category}    ${note_category_rsp}
    Should Be Equal    ${note_completed}    ${note_completed_rsp}
    Should Be Equal    ${note_description}    ${note_description_rsp}
    Should Be Equal    ${note_id}    ${note_id_rsp}
    Should Be Equal    ${note_title}    ${note_title_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp} 
    Should Be Equal    Note successfully Updated    ${responseUN.json()['message']}
    Log To Console    ${responseUN.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Update the completed status of a note via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    createNoteViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json    
    ${note_category_data}    Get Value From Json    ${data}    $.note_category
    ${note_category_str}    Convert JSON To String	 ${note_category_data}
    ${note_category}    Remove String    ${note_category_str}    [    ]    '    " 
    #Did not figure it out how to randomize boolean values and pass it to the request body. Until then, it goes hardcoded.
    ${note_completed}    Set Variable    true
    ${note_description_data}    Get Value From Json    ${data}    $.note_description
    ${note_description_str}    Convert JSON To String	 ${note_description_data}
    ${note_description}    Remove String    ${note_description_str}    [    ]    '    " 
    ${note_id_data}    Get Value From Json    ${data}    $.note_id
    ${note_id_str}    Convert JSON To String	 ${note_id_data}
    ${note_id}    Remove String    ${note_id_str}    [    ]    '    " 
    ${note_title_data}    Get Value From Json    ${data}    $.note_title
    ${note_title_str}    Convert JSON To String	 ${note_title_data}
    ${note_title}    Remove String    ${note_title_str}    [    ]    '    " 
    ${user_id_data}    Get Value From Json    ${data}    $.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_data}
    ${user_id}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${data}    Create Dictionary    completed=${note_completed}   
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseUCSN}    PATCH On Session    alias=expandtesting     url=/notes/${note_id}    data=${data}    headers=${headers}    expected_status=200   
    ${json_responseUCSN}    Convert String To Json    ${responseUCSN.content}
    ${note_category_ob}    Get Value From Json    ${json_responseUCSN}    data.category
    ${note_category_str}    Convert JSON To String	 ${note_category_ob}
    ${note_category_rsp}    Remove String    ${note_category_str}    [    ]    '    " 
    ${note_category_rsp_bool}    Convert To Boolean    ${note_category_rsp}    
    ${note_completed_ob}    Get Value From Json    ${json_responseUCSN}    data.completed
    ${note_completed_str}    Convert JSON To String	 ${note_completed_ob}
    ${note_completed_rsp}    Remove String    ${note_completed_str}    [    ]    '    " 
    ${note_description_ob}    Get Value From Json    ${json_responseUCSN}    data.description
    ${note_description_str}    Convert JSON To String	 ${note_description_ob}
    ${note_description_rsp}    Remove String    ${note_description_str}    [    ]    '    "   
    ${note_id_ob}    Get Value From Json    ${json_responseUCSN}    data.id
    ${note_id_str}    Convert JSON To String	 ${note_id_ob}
    ${note_id_rsp}    Remove String    ${note_id_str}    [    ]    '    " 
    ${note_title_ob}    Get Value From Json    ${json_responseUCSN}    data.title
    ${note_title_str}    Convert JSON To String	 ${note_title_ob}
    ${note_title_rsp}    Remove String    ${note_title_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseUCSN}    data.user_id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    Should Be Equal    ${note_category}    ${note_category_rsp}
    Should Be Equal    ${note_completed}    ${note_completed_rsp}
    Should Be Equal    ${note_description}    ${note_description_rsp}
    Should Be Equal    ${note_id}    ${note_id_rsp}
    Should Be Equal    ${note_title}    ${note_title_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp} 
    Should Be Equal    Note successfully Updated    ${responseUCSN.json()['message']}
    Log To Console    ${responseUCSN.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Delete a note by ID via API
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    createNoteViaApi(${bypassParalelismNumber})
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
    deleteJsonFile(${bypassParalelismNumber})

