### Occupancy prediction using sensor data 
#### Link to already deployed app: [occupancy prediction](https://buidingdetect.herokuapp.com/)

This is a model predictive control for optimizing the performance of heating, ventilation and airconditioning system. For simulation purpose, this app is deployed on heroku and the steps taken to do that is outlined as follows:

1. Create a Github account if you don't have one.
2. After creating, follow the steps provided to push this repository. Otherwise, you can fork it from this [link](https://github.com/SamsonOso/detecting-occupancy.git).
3. Create an [Heroku account](https://www.heroku.com/) and log in

      i. Click this link: [new app ](https://dashboard.heroku.com/apps) and create a new app (Only type the name for the app in App name and choose region (Europe) then click Create app as shown in screenshot below) 
      ![alt text](https://i.ibb.co/SmgCv1y/newapp.png)
      
      ii. After creating the app, navigate to the Settings tab. Scroll down and Click on Add Buildpack. 
      
            a. In the textbox, copy and paste this link: https://github.com/virtualstaticvoid/heroku-buildpack-r.git
            b. Click on Save changes
      iii. Navigate to the Deploy tab
            a. For Deployment method, select and connect to Github, search for the name of repository(detecting-occupancy
) cloned in step 1,
                  Click Connect, to add the repository
            b. Scroll down to Manual deploy at the bottom
                  1. Select the main branch and click Deploy Branch
                  2. Wait for a while for deployment to complete
4. As shown in sample screenshot below, when Deployment is complete, click on the View button to see deployed app
![alt text](https://i.ibb.co/9yTBdxK/complete.png)
