*** Settings ***
Documentation    REST API test
Library          RequestsLibrary
Library          Collections

*** Variables ***
${url}          https://url.com
${endpoint}     /endpoint
${user}         user
${password}     1234

*** Test Cases ***
Get Clientes Request
    Authenticate
    Get Clientes
    Listar dados clientes

*** Keywords ***
Authenticate
    ${auth}                       Create List           ${user}         ${password}
    Create Session                Proposal              ${url}          auth=${auth}    verify=true

Get Clientes
    ${resp}                       Get On Session        Proposal     ${endpoint}     expected_status=200
    Should Be Equal As Strings    ${resp.status_code}   200
    ${dictionary}     Evaluate    json.loads("""${resp.content}""")     json
    Set Suite Variable    ${dictionary}

Listar Dados Clientes
    ${todos_clientes}  Set Variable    ${dictionary['clientes']}
    FOR    ${cliente}     IN      @{todos_clientes}
        ${id}             Get From Dictionary    ${cliente}    id
        ${nome}           Get From Dictionary    ${cliente}    nome
        ${email}          Get From Dictionary    ${cliente}    email
        ${cidade}         Get From Dictionary    ${cliente}    cidade
        ${estado}         Get From Dictionary    ${cliente}    estado
        Log To Console    ${id}
        Log To Console    ${nome}
        Log To Console    ${email}
        Log To Console    ${cidade}
        Log To Console    ${estado}
    END

