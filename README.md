## Occupancy prediction using sensor data 

This is a model predictive control for optimizing the performance of heating, ventilation and airconditioning system. For simulation purpose, this app is deployed on heroku and the steps taken to do that is outlined as follows:

1. Fork or clone this repository as your own
2. Create an [Heroku account](https://www.heroku.com/)
      1. Click this link: [new app ](https://dashboard.heroku.com/apps) and create a new app (Only choose app name and region(EU) and click create app as shown in screenshot below) 
      ![alt text](https://i.ibb.co/SmgCv1y/newapp.png)
      
      2. After creating the app, navigate to the Settings tab. Scroll down and Click on Add Buildpack. 
            1. In the textbox, copy and paste this link: https://github.com/virtualstaticvoid/heroku-buildpack-r.git
            2. Click on save changes
      3. Navigate to the Deploy tab
            1. For Deployment method, select and connect to github, search for the name of repository(detecting-occupancy
) cloned in step 1
                  1. Click Connect, to add the repository
            3. Scroll down to Manual deploy at the bottom
                  1. Select the main branch and click Deploy Branch
                  2. Wait for a while for deployment to complete
4. As shown in screenshot below, when Deployment is complete, click on the View button to see deployed app
![alt text](https://i.ibb.co/9yTBdxK/complete.png)
