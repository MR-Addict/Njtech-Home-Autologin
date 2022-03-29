import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# load json file
profile = json.load(open("./assets/profile.json"))
provider = {
    "cmcc": '//span[@value="@cmcc"]',
    "telecom": '//span[@value="@telecom"]'
}
# initialize the Chrome driver
driver = webdriver.Chrome("./assets/chromedriver.exe")

# head to Njtech login page
driver.get("https://u.njtech.edu.cn/cas/login?service=https%3A%2F%2Fu.njtech.edu.cn%2Foauth2%2Fauthorize%3Fclient_id%3DOe7wtp9CAMW0FVygUasZ%26response_type%3Dcode%26state%3Dnjtech%26s%3Df682b396da8eb53db80bb072f5745232")
# wait until page loaded
driverWait = WebDriverWait(driver, 30)
WebDriverWait(driver, 30).until(
    EC.element_to_be_clickable(driver.find_element(By.ID, "login"))
)

# find username field and send the username itself to the input field
driver.find_element(By.ID, "username").send_keys(profile["username"])
# find password field and insert password as well
driver.find_element(By.ID, "password").send_keys(profile["password"])
# insert provider chinese name
driver.find_element(By.ID, "channelshow").click()
# insert provider name
driver.find_element(By.XPATH, provider[profile["provider"]]).click()
# click login button
driver.find_element(By.ID, "login").click()

# wait util ewn page loaded
Element = WebDriverWait(driver, 10).until(
    EC.element_to_be_clickable(driver.find_element(By.ID, "main-link"))
)

# close the driver
driver.close()
