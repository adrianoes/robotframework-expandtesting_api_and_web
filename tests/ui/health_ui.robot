*** Settings ***

Library    Browser

*** Test Cases ***

Check ui health
    New Browser    headless=True    
    #When headless, use the line above and not the 2 lines below
    # New Browser    headless=False    args=["--start-maximized"]
    # New Context    viewport=${None}
    New Page    https://practice.expandtesting.com/notes/app/