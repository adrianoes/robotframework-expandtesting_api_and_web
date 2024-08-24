*** Settings ***

Resource    ../resources/test.resource
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    String
Library    FakerLibrary

*** Test Cases ***

Creates a new user account via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    ${random_letter}    FakerLibrary.Random Lowercase Letter
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
    logInUserViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Creates a new user account via API - Bad request
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    ${random_letter}    FakerLibrary.Random Lowercase Letter
    ${random_email}    FakerLibrary.Email
    ${user_email}    Catenate    SEPARATOR=    ${random_letter}    ${random_email}
    ${user_name}    FakerLibrary.Name
    ${user_password}    FakerLibrary.password
    ${data}    Create Dictionary    email='@'+${user_email}    name=${user_name}    password=${user_password}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCU}    POST On Session    alias=expandtesting     url=/users/register    data=${data}    expected_status=400
    ${json_responseCU}    Convert String To Json    ${responseCU.content}  
    Should Be Equal    A valid email address is required    ${responseCU.json()['message']}

Log in as an existing user via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
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
    deleteJsonFile(${bypassParalelismNumber})

Log in as an existing user via API - Bad request
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
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
    ${data}    Create Dictionary    email='@'+${user_email}    password=${user_password}
    ${header}    Create Dictionary    content-type=application/x-www-form-urlencoded
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseLU}    POST On Session    alias=expandtesting     url=/users/login    data=${data}   expected_status=400  
    ${json_responseLU}    Convert String To Json    ${responseLU.content}     
    Should Be Equal    A valid email address is required    ${responseLU.json()['message']}
    Log To Console    ${responseLU.json()['message']}
    logInUserViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Log in as an existing user via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
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
    ${data}    Create Dictionary    email=${user_email}    password='@'+${user_password}
    ${header}    Create Dictionary    content-type=application/x-www-form-urlencoded
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseLU}    POST On Session    alias=expandtesting     url=/users/login    data=${data}   expected_status=401  
    ${json_responseLU}    Convert String To Json    ${responseLU.content}     
    Should Be Equal    Incorrect email address or password    ${responseLU.json()['message']}
    Log To Console    ${responseLU.json()['message']}
    logInUserViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Retrieve user profile information via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
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
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseRU}    GET On Session    alias=expandtesting     url=/users/profile    headers=${headers}    expected_status=200    
    ${json_responseRU}    Convert String To Json    ${responseRU.content} 
    ${user_email_ob}    Get Value From Json    ${json_responseRU}    data.email
    ${user_email_str}    Convert JSON To String	 ${user_email_ob}
    ${user_email_rsp}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseRU}    data.id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_name_ob}    Get Value From Json    ${json_responseRU}    data.name
    ${user_name_str}    Convert JSON To String	 ${user_name_ob}
    ${user_name_rsp}    Remove String    ${user_name_str}    [    ]    '    "  
    ${user_password_ob}    Get Value From Json    ${json_responseRU}    data.password
    ${user_password_str}    Convert JSON To String	 ${user_password_ob}
    ${user_password_rsp}    Remove String    ${user_password_str}    [    ]    '    " 
    Should Be Equal    ${user_email}    ${user_email_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp}
    Should Be Equal    ${user_name}    ${user_name_rsp}   
    Should Be Equal    Profile successful    ${responseRU.json()['message']}
    Log To Console    ${responseRU.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})




Retrieve user profile information via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    # Retrieve user profile information via API - Bad Request is not applicable here since I was not able to make a bad request by changing the content type. Apparently robot has other means to deal with it and does not considers this header. Same for others like this one.
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
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
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token='@'+${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseRU}    GET On Session    alias=expandtesting     url=/users/profile    headers=${headers}    expected_status=401    
    ${json_responseRU}    Convert String To Json    ${responseRU.content}  
    Should Be Equal    Access token is not valid or has expired, you will need to login    ${responseRU.json()['message']}
    Log To Console    ${responseRU.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Update the user profile information via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    #Create a keyword to read all this stuff
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
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=10000000    max=99999999999999999999    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    ${updated_user_name}    FakerLibrary.Name
    ${data}    Create Dictionary    company=${updated_user_company}    name=${updated_user_name}    phone=${updated_user_phone}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseUU}    PATCH On Session    alias=expandtesting     url=/users/profile    data=${data}    headers=${headers}    expected_status=200    
    ${json_responseUU}    Convert String To Json    ${responseUU.content} 
    ${user_company_ob}    Get Value From Json    ${json_responseUU}    data.company
    ${user_company_str}    Convert JSON To String	 ${user_company_ob}
    ${user_company_rsp}    Remove String    ${user_company_str}    [    ]    '    " 
    ${user_email_ob}    Get Value From Json    ${json_responseUU}    data.email
    ${user_email_str}    Convert JSON To String	 ${user_email_ob}
    ${user_email_rsp}    Remove String    ${user_email_str}    [    ]    '    " 
    ${user_id_ob}    Get Value From Json    ${json_responseUU}    data.id
    ${user_id_str}    Convert JSON To String	 ${user_id_ob}
    ${user_id_rsp}    Remove String    ${user_id_str}    [    ]    '    " 
    ${user_name_ob}    Get Value From Json    ${json_responseUU}    data.name
    ${user_name_str}    Convert JSON To String	 ${user_name_ob}
    ${user_name_rsp}    Remove String    ${user_name_str}    [    ]    '    "  
    ${user_phone_ob}    Get Value From Json    ${json_responseUU}    data.phone
    ${user_phone_str}    Convert JSON To String	 ${user_phone_ob}
    ${user_phone_rsp}    Remove String    ${user_phone_str}    [    ]    '    " 
    Should Be Equal    ${updated_user_company}    ${user_company_rsp}
    Should Be Equal    ${user_email}    ${user_email_rsp}
    Should Be Equal    ${user_id}    ${user_id_rsp}
    Should Be Equal    ${updated_user_name}    ${user_name_rsp}  
    Should Be Equal    ${updated_user_phone}    ${user_phone_rsp} 
    Should Be Equal    Profile updated successful    ${responseUU.json()['message']}
    Log To Console    ${responseUU.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Update the user profile information via API - Bad Request
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    #Create a keyword to read all this stuff
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
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=10000000    max=99999999999999999999    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    ${updated_user_name}    FakerLibrary.Name
    ${data}    Create Dictionary    company=${updated_user_company}    name=a@#    phone=${updated_user_phone}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseUU}    PATCH On Session    alias=expandtesting     url=/users/profile    data=${data}    headers=${headers}    expected_status=400    
    ${json_responseUU}    Convert String To Json    ${responseUU.content} 
    Should Be Equal    User name must be between 4 and 30 characters    ${responseUU.json()['message']}
    Log To Console    ${responseUU.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Update the user profile information via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    #Create a keyword to read all this stuff
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
    ${updated_user_company}    FakerLibrary.Company
    ${updated_user_phone_int}    FakerLibrary.Random Int    min=10000000    max=99999999999999999999    step=1  
    ${updated_user_phone}    Convert To String    ${updated_user_phone_int}
    ${updated_user_name}    FakerLibrary.Name
    ${data}    Create Dictionary    company=${updated_user_company}    name=${updated_user_name}    phone=${updated_user_phone}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token='@'+${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseUU}    PATCH On Session    alias=expandtesting     url=/users/profile    data=${data}    headers=${headers}    expected_status=401    
    ${json_responseUU}    Convert String To Json    ${responseUU.content} 
    Should Be Equal    Access token is not valid or has expired, you will need to login    ${responseUU.json()['message']}
    Log To Console    ${responseUU.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Change a user\'s password via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${updated_user_password}    FakerLibrary.password
    ${data}    Create Dictionary    currentPassword=${user_password}    newPassword=${updated_user_password}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCP}    POST On Session    alias=expandtesting     url=/users/change-password    data=${data}    headers=${headers}    expected_status=200    
    ${json_responseCP}    Convert String To Json    ${responseCP.content}
    Should Be Equal    The password was successfully updated    ${responseCP.json()['message']}
    Log To Console    ${responseCP.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Change a user\'s password via API - Bad Request
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${updated_user_password}    FakerLibrary.password
    ${data}    Create Dictionary    currentPassword=${user_password}    newPassword='123'
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCP}    POST On Session    alias=expandtesting     url=/users/change-password    data=${data}    headers=${headers}    expected_status=400    
    ${json_responseCP}    Convert String To Json    ${responseCP.content}
    Should Be Equal    New password must be between 6 and 30 characters    ${responseCP.json()['message']}
    Log To Console    ${responseCP.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Change a user\'s password via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_password_data}    Get Value From Json    ${data}    $.user_password
    ${user_password_str}    Convert JSON To String	 ${user_password_data}
    ${user_password}    Remove String    ${user_password_str}    [    ]    '    "
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${updated_user_password}    FakerLibrary.password
    ${data}    Create Dictionary    currentPassword=${user_password}    newPassword=${updated_user_password}
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token='@'+${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseCP}    POST On Session    alias=expandtesting     url=/users/change-password    data=${data}    headers=${headers}    expected_status=401    
    ${json_responseCP}    Convert String To Json    ${responseCP.content}
    Should Be Equal    Access token is not valid or has expired, you will need to login    ${responseCP.json()['message']}
    Log To Console    ${responseCP.json()['message']}
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Log out a user via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token=${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseLOU}    DELETE On Session    alias=expandtesting     url=/users/logout    headers=${headers}    expected_status=200    
    ${json_responseLOU}    Convert String To Json    ${responseLOU.content} 
    Should Be Equal    User has been successfully logged out    ${responseLOU.json()['message']}
    Log To Console    ${responseLOU.json()['message']}
    logInUserViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Log out a user via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    " 
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token='@'+${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseLOU}    DELETE On Session    alias=expandtesting     url=/users/logout    headers=${headers}    expected_status=401    
    ${json_responseLOU}    Convert String To Json    ${responseLOU.content} 
    Should Be Equal    Access token is not valid or has expired, you will need to login    ${responseLOU.json()['message']}
    Log To Console    ${responseLOU.json()['message']}
    logInUserViaApi(${bypassParalelismNumber})
    deleteUserViaApi(${bypassParalelismNumber})
    deleteJsonFile(${bypassParalelismNumber})

Delete user account via API
    [Tags]  API    BASIC    FULL
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
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

Delete user account via API - Unauthorized
    [Tags]    API    FULL    NEGATIVE
    ${bypassParalelismNumber}    FakerLibrary.creditCardNumber
    createUserViaApi(${bypassParalelismNumber})
    logInUserViaApi(${bypassParalelismNumber})
    ${data}    Load Json From File    tests/fixtures/testdata-${bypassParalelismNumber}.json
    ${user_token_data}    Get Value From Json    ${data}    $.user_token
    ${user_token_str}    Convert JSON To String	 ${user_token_data}
    ${user_token}    Remove String    ${user_token_str}    [    ]    '    "
    ${headers}    Create Dictionary    content-type=application/x-www-form-urlencoded    X-Auth-Token='@'+${user_token}
    Create Session    alias=expandtesting    url=https://practice.expandtesting.com/notes/api    verify=true
    ${responseDU}    DELETE On Session    alias=expandtesting     url=/users/delete-account    headers=${headers}    expected_status=401    
    ${json_responseDU}    Convert String To Json    ${responseDU.content} 
    Should Be Equal    Access token is not valid or has expired, you will need to login    ${responseDU.json()['message']}
    Log To Console    ${responseDU.json()['message']}
    deleteJsonFile(${bypassParalelismNumber})