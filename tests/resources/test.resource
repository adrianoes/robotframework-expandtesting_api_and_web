*** Settings ***

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
