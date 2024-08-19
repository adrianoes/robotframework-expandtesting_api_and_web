# robot-expandtesting_UI_and_API

UI and API testing in [expandtesting](https://practice.expandtesting.com/notes/app/) note app. This project contains basic examples on how to use Robot Framework to test UI, API and how to combine UI and API tests. Good practices such as hooks, custom commands and tags, among others, are used. All the necessary support documentation to develop this project is placed here. When it comes to the API part, it deals with the x-www-form-urlencoded content type. Although custom commands are used, the assertion code to each test is kept in it so we can work independently in each test. It creates one .json file for each test so we can share data between different requests in the test. The .json file is excluded after each test execution. 

# Pre-requirements:

| Requirement                     | Version        | Note                                                            |
| :------------------------------ |:---------------| :-------------------------------------------------------------- |
| Node.js                         | 18.18.0        | -                                                               |
| Python                          | 3.12.5         | -                                                               |
| Visual Studio Code              | 1.89.1         | -                                                               |
| Robot Framework                 | 7.0.1          | -                                                               | 
| SeleniumLibrary                 | 6.3.0          | -                                                               | 
| RequestsLibrary                 | 0.9.7          | -                                                               | 
| JSONLibrary                     | 0.5            | -                                                               | 
| robotframework-faker            | 5.0.0          | -                                                               | 
| Robot Framework Language Server | v1.12.0        | -                                                               |
| Chrome                          | 127.0.6533.100 | -                                                               |
| Firefox                         | 129.0          | -                                                               |
| Chrome webdriver                | 127.0.6533.99  | -                                                               |
| Firefox geckodriver             | 0.35.0         | -                                                               |
| Chrome TruePath                 | 1.0.0          | Optional. Recommended so you can work with accurate locators.   |              

# Installation:

- See [Node.js page](https://nodejs.org/en) and install the aforementioned Node.js version. Keep all the preferenced options as they are.
- See [python page](https://www.python.org/downloads/) and download the latest Python stable version. Start the installation and check the checkboxes below: 
  - :white_check_mark: Use admin privileges when installing py.exe 
  - :white_check_mark: Add python.exe to PATH
and keep all the other preferenced options as they are.
- See [Visual Studio Code page](https://code.visualstudio.com/) and install the latest VSC stable version. Keep all the prefereced options as they are until you reach the possibility to check the checkboxes below: 
  - :white_check_mark: Add "Open with code" action to Windows Explorer file context menu. 
  - :white_check_mark: Add "Open with code" action to Windows Explorer directory context menu.
Check then both to add both options in context menu.
- Open windows propmpt as admin and execute ```pip install robotframework``` to install Robot Framework.
- Open windows propmpt as admin and execute ```pip install robotframework-browser``` to install Browser library.
- Open windows propmpt as admin and execute ```pip install robotframework-requests``` to install RequestsLibrary.
- Open windows propmpt as admin and execute ```pip install robotframework-jsonlibrary``` to install JSONLibrary.
- Open windows propmpt as admin and execute ```pip install robotframework-faker``` to install robotframework-faker.
- Open windows propmpt as admin and execute ```pip install setuptools``` to install setuptools package.
- Look for Robot Framework Language Server in the extensions marketplace and install the one from Robocorp.
- See [chrome page](https://www.google.com/chrome/dr/download/) and install Chrome browser.
- See [firefox page](https://www.mozilla.org/pt-BR/firefox/new/) and install Firefox browser.
- See [chromedriver page](https://googlechromelabs.github.io/chrome-for-testing/) and look for the binary file of the chromedriver that has same version of your Chrome browser, copy its URL and paste it in chrome browser. Donwload is supposed to start automatically.
- See [geckodriver page](https://github.com/mozilla/geckodriver/releases) and download the geckodriver related to your system's capabilities.
- Unzip both Chrome and Firefox drivers inside Python scripts folder (C:\Users\user_name\AppData\Local\Programs\Python\Python312\Scripts). This folder must be configured in windows environment varibles.
- See [TruePath page](https://chromewebstore.google.com/detail/truepath/mgjhkhhbkkldiihlajcnlfchfcmhipmn?hl=pt-BR) and install TruePath extension.
- Execute ```rfbrowser init``` to initialize the Browser library.

# Tests:

- Execute ```robot -d ./results tests``` to run all tests in headless mode and store results in separated folder.
- Execute ```robot -d ./results .\tests\ui\users_ui.robot``` to run all the tests in the users_ui suite in headless mode and store results in separated folder.
- Execute ```robot -d ./results -t "Change a user\'s password via UI" tests/ui/users_ui.robot``` to run Change a user's password via UI test case inside users_ui suite and store results in separated folder.
- Hit :point_right:**Testing** button on left side bar in VSC and choose the tests you want to execute.

# Support:

- [expandtesting API documentation page](https://practice.expandtesting.com/notes/api/api-docs/)
- [expandtesting API demonstration page](https://www.youtube.com/watch?v=bQYvS6EEBZc)
- [SeleniumLibrary](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
- [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests#readme)
- [JSONLibrary](https://robotframework-thailand.github.io/robotframework-jsonlibrary/JSONLibrary.html#library-documentation-top)
- [FakerLibrary](https://marketsquare.github.io/robotframework-faker/)
- [String](https://robotframework.org/robotframework/latest/libraries/String.html#Remove%20String)
- [OperatingSystem](https://robotframework.org/robotframework/latest/libraries/OperatingSystem.html)
- [BuiltIn](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)
- [Error regarding installing robotframework-jsonlibrary explicitly](https://blog.finxter.com/fixed-modulenotfounderror-no-module-named-robotframework-jsonlibrary/)
- [No module named 'pkg_resources'](https://cursos.alura.com.br/forum/topico-problemas-com-a-library-no-robot-339325)
- [InsecureRequestWarning: Unverified HTTPS request is being made in Robot Framework.](https://stackoverflow.com/a/45223128/10519428)
- [How can i get the Local Storage data using "Execute Javascript" Keyword in Robot Framework](https://stackoverflow.com/a/73624779/10519428)
- [WebDriverException: unknown error: DevToolsActivePort file doesn't exist while trying to initiate Chrome Browser](https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t)
- [How to perform a FOR loop in the Robot Framework!?](https://www.youtube.com/watch?v=j6AB2Rh4mKw)
- [Set List Value](https://robotframework.org/robotframework/latest/libraries/Collections.html#Set%20List%20Value)
- [Element not visible sometimes with Robot Framework](https://stackoverflow.com/a/33317412/10519428)
- [How to use IF ELSE in Robot Framework #12](https://www.youtube.com/watch?v=NcLXjVz163A)
- [How to Use IF and ELSE in Robot Framework](https://stackoverflow.com/a/72145975/10519428)
- [Can't extract url value from ahref to variable](https://forum.robotframework.org/t/cant-extract-url-value-from-ahref-to-variable/3159/4)
- [Unable to scroll down the web page using the Robot Framework](https://stackoverflow.com/questions/31947891/unable-to-scroll-down-the-web-page-using-the-robot-framework?rq=3)

# Tips:

- UI and API tests to send password reset link to user's email and API tests to verify a password reset token and reset a user's password must be tested manually as they rely on e-mail verification.
- Always check drivers and browsers versios before running the tests. They should be compatible.